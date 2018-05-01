ESCAPESTAGE_NONE = 0
ESCAPESTAGE_ESCAPE = 1
ESCAPESTAGE_BOSS = 2
ESCAPESTAGE_DEATH = 3

function GM:GetSigils()
	local sigils = {}

	for _, ent in pairs(ents.FindByClass("prop_obj_sigil")) do
		if ent:IsValid() and ent:GetSigilHealthBase() ~= 0 then
			sigils[#sigils + 1] = ent
		end
	end

	return sigils
end

function GM:GetUncorruptedSigils()
	local sigils = {}

	for _, ent in pairs(ents.FindByClass("prop_obj_sigil")) do
		if ent:GetSigilHealthBase() ~= 0 and not ent:GetSigilCorrupted() then
			sigils[#sigils + 1] = ent
		end
	end

	return sigils
end
GM.GetSigilsUncorrupted = GM.GetUncorruptedSigils

function GM:GetCorruptedSigils()
	local sigils = {}

	for _, ent in pairs(ents.FindByClass("prop_obj_sigil")) do
		if ent:GetSigilHealthBase() ~= 0 and ent:GetSigilCorrupted() then
			sigils[#sigils + 1] = ent
		end
	end

	return sigils
end
GM.GetSigilsCorrupted = GM.GetCorruptedSigils

function GM:NumSigils()
	local sigils = 0

	for _, ent in pairs(ents.FindByClass("prop_obj_sigil")) do
		if ent:GetSigilHealthBase() ~= 0 then
			sigils = sigils + 1
		end
	end

	return sigils
end

function GM:HasSigils()
	for _, ent in pairs(ents.FindByClass("prop_obj_sigil")) do
		if ent:GetSigilHealthBase() ~= 0 then
			return true
		end
	end

	return false
end

function GM:NumUncorruptedSigils()
	local sigils = 0

	for _, ent in pairs(ents.FindByClass("prop_obj_sigil")) do
		if ent:GetSigilHealthBase() ~= 0 and not ent:GetSigilCorrupted() then
			sigils = sigils + 1
		end
	end

	return sigils
end
GM.NumSigilsUncorrupted = GM.NumUncorruptedSigils

function GM:NumCorruptedSigils()
	local sigils = 0

	for _, ent in pairs(ents.FindByClass("prop_obj_sigil")) do
		if ent:GetSigilHealthBase() ~= 0 and ent:GetSigilCorrupted() then
			sigils = sigils + 1
		end
	end

	return sigils
end
GM.NumSigilsCorrupted = GM.NumCorruptedSigils

function GM:GetUseSigils()
	return GetGlobalBool("sigils", false)
end

function GM:IsEscapeDoorOpen()
	if not self:GetEscapeSequence() then return false end

	for _, ent in pairs(ents.FindByClass("prop_obj_exit")) do
		if ent:IsOpened() then
			return true
		end
	end

	return false
end

--[[function GM:SetAllSigilsDestroyed(destroyed)
	self:SetSigilsDestroyed(destroyed and self.MaxSigils or 0)
end

function GM:GetAllSigilsDestroyed()
	return self.MaxSigils > 0 and self:GetUseSigils() and self:GetSigilsDestroyed() >= self.MaxSigils
end

function GM:SetSigilsDestroyed(destroyed)
	--SetGlobalInt("destroyedsigils", destroyed)
end

function GM:GetSigilsDestroyed()
	return self:GetWave() > 0 and (self.MaxSigils - self:NumSigils()) or 0
	--return GetGlobalInt("destroyedsigils", 0)
end]]

function GM:GetEscapeSequence()
	return self:GetUseSigils() and self:GetEscapeStage() ~= ESCAPESTAGE_NONE
end
GM.IsEscapeSequence = GM.GetEscapeSequence

function GM:SetEscapeStage(stage)
	SetGlobalInt("esstg", stage)
end

function GM:GetEscapeStage()
	return GetGlobalInt("esstg", ESCAPESTAGE_NONE)
end
