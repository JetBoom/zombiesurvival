ENT.Type = "point"

function ENT:AcceptInput(name, activator, caller, args)
  name = string.lower(name)
  if name == "spawnrandomprop" then
    self:SpawnRandomProp()
  end
end

function ENT:SpawnRandomProp()
  local randommodel = {
    "models/props_junk/wood_crate001a.mdl",
    "models/props_junk/wood_crate002a.mdl",
    "models/props_c17/oildrum001.mdl",
    "models/props_wasteland/kitchen_shelf002a.mdl"
  }

  local prop = ents.Create("prop_physics")
  prop:SetModel(randommodel[math.random(#randommodel)])

  prop:SetPos(self:GetPos())
  prop:Spawn()
end
