ENT.Type = "point"

function ENT:KeyValue(key, value)
  key = string.lower(key)
  if key == "spawnsigilprops" then
    value = tonumber(value)
    if value == 1 then
      GAMEMODE.SpawnSigilProps = true
    else
      GAMEMODE.SpawnSigilProps = false
    end
  end
  if key == "sigilamount" then
    GAMEMODE.MaxSigils = tonumber(value)
  end
end
