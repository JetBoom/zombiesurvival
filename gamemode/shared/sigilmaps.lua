-- Override default sigil count for some maps (Omit version suffix at the end, to match all versions).
function GM:GetSigilsPerMap(mapName) for k, v in pairs(self.SigilsPerMap) do if string.find(mapName, "^"..k) then return v end end return nil end

-- Default sigil fallback in case there is no map in the sigil table (don't go over 26 or you'll lose support for any sigil issues).
GM.SigilFallBack = 3

-- Edit below with the map name and how many sigils to spawn (the map needs at least the number of sigil placements or they won't spawn!)
GM.SigilsPerMap = {
	gm_construct = 26,
	zs_abandoned_mall = 4,
	zs_abandonedmallhd = 4,
	zs_mallofthedead = 4,
	zs_ravine = 4,
	zs_zedders_mall = 4,
	zs_amsterville = 4,
	zs_pathogen = 4,
	zs_christmas_town = 4,
	zs_krusty_krab_large = 4,
	zs_lambdacore = 4,
	zs_snowy_castle = 4,
	zs_stanley_parable = 4,
	zs_asylum = 4,
	zs_gauntlet_reborn = 0 -- leave as 0 due to built-in sigils.
}