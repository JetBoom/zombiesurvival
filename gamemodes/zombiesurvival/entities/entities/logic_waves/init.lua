ENT.Type = "point"

function ENT:Initialize()
	self.Wave = self.Wave or -1
end

function ENT:Think()
end

function ENT:AcceptInput(name, activator, caller, args)
	name = string.lower(name)
	if string.sub(name, 1, 2) == "on" then
		self:FireOutput(name, activator, caller, args)
	elseif name == "advancewave" then
		gamemode.Call("SetWaveActive", false)
		gamemode.Call("SetWaveStart", CurTime())
		return true
	elseif name == "endwave" then
		gamemode.Call("SetWaveEnd", CurTime())
		return true
	elseif name == "setwave" then
		gamemode.Call("SetWave", tonumber(args) or 1)
		return true
	elseif name == "setwaves" then
		SetGlobalInt("numwaves", tonumber(args) or GAMEMODE.NumberOfWaves)
		return true
	elseif name == "startwave" then
		gamemode.Call("SetWaveStart", CurTime())
		return true
	elseif name == "setwavestart" then
		local time = tonumber(args) or 0
		gamemode.Call("SetWaveStart", time == -1 and time or (CurTime() + time))
		return true
	elseif name == "setwaveend" then
		local time = tonumber(args) or 0
		gamemode.Call("SetWaveEnd", time == -1 and time or (CurTime() + time))
		return true
	end
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if string.sub(key, 1, 2) == "on" then
		self:AddOnOutput(key, value)
	elseif key == "wave" then
		self.Wave = tonumber(value) or -1
	end
end
