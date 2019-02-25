local class = require('class')
local Event = require('event')
local Sound = require('sound')
local UI    = require('ui')
local Util  = require('util')

local colors = _G.colors

UI.Notification = class(UI.Window)
UI.Notification.defaults = {
	UIElement = 'Notification',
	backgroundColor = colors.gray,
	height = 3,
}
function UI.Notification:draw()
end

function UI.Notification:enable()
end

function UI.Notification:error(value, timeout)
	self.backgroundColor = colors.red
	Sound.play('entity.villager.no', .5)
	self:display(value, timeout)
end

function UI.Notification:info(value, timeout)
	self.backgroundColor = colors.gray
	self:display(value, timeout)
end

function UI.Notification:success(value, timeout)
	self.backgroundColor = colors.green
	self:display(value, timeout)
end

function UI.Notification:cancel()
	if self.timer then
		Event.off(self.timer)
		self.timer = nil
	end

	if self.canvas then
		self.enabled = false
		self.canvas:removeLayer()
		self.canvas = nil
	end
end

function UI.Notification:display(value, timeout)
	self.enabled = true
	local lines = Util.wordWrap(value, self.width - 2)
	self.height = #lines + 1
	self.y = self.parent.height - self.height + 1
	if self.canvas then
		self.canvas:removeLayer()
	end

	self.canvas = self:addLayer(self.backgroundColor, self.textColor)
	self:addTransition('expandUp', { ticks = self.height })
	self.canvas:setVisible(true)
	self:clear()
	for k,v in pairs(lines) do
		self:write(2, k, v)
	end

	self.timer = Event.onTimeout(timeout or 3, function()
		self:cancel()
		self:sync()
	end)
end