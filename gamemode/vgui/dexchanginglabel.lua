local PANEL = {}

local function empty() end

function PANEL:SetChangeFunction(func, autosize)
	self.Think = function(me)
		local val = func()
		if self.LastValue ~= val and val ~= nil then
			self.LastValue = val

			self:SetText(val)

			if autosize then
				self:SizeToContents()
			end

			if self.OnChanged then
				self:OnChanged(val)
			end
		end
	end
end

function PANEL:RemoveChangeFunction()
	self.Think = empty
end

function PANEL:SetChangedFunction(func)
	self.OnChanged = func
end

function PANEL:RemoveChangedFunction()
	self.OnChanged = empty
end

vgui.Register("DEXChangingLabel", PANEL, "DLabel")
