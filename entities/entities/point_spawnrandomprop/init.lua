ENT.Type = "point"

function ENT:AcceptInput(name, activator, caller, args)
  name = string.lower(name)
  if name == "spawnrandomprop" then
    self:SpawnRandomProp()
  end
end

function ENT:SpawnRandomProp()
  --TODO: Allow the server owner to define what props to use in the mapping entity.
  local randommodel = GAMEMODE.RandomProps

  local prop = ents.Create("prop_physics")
  prop:SetModel(randommodel[math.random(#randommodel)])

  prop:SetPos(self:GetPos())
  prop:Spawn()
end
