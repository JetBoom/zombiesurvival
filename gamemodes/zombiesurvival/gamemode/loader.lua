-- Give it a folder with server/client/shared subfolders and it'll load it up.

function include_library(folder)
	local GM = GM or GAMEMODE

	-- Assume files in the base directory are included merely for existing.
	local files, _ = file.Find(GM.FolderName.."/gamemode/"..folder.."/*.lua", "LUA")
	table.sort(files)
	for _, filename in ipairs(files) do
		include(folder.."/"..filename)
	end

	if SERVER then
		local server_files, _ = file.Find(GM.FolderName.."/gamemode/"..folder.."/server/*.lua", "LUA")
		table.sort(server_files)

		for _, filename in ipairs(server_files) do
			include(folder.."/server/"..filename)
		end
	end

	local client_files, _ = file.Find(GM.FolderName.."/gamemode/"..folder.."/client/*.lua", "LUA")
	table.sort(client_files)
	local clientmethod = CLIENT and include or AddCSLuaFile
	for _, filename in ipairs(client_files) do
		clientmethod(folder.."/client/"..filename)
	end

	local shared_files, _ = file.Find(GM.FolderName.."/gamemode/"..folder.."/shared/*.lua", "LUA")
	table.sort(shared_files)
	for _, filename in ipairs(shared_files) do
		include(folder.."/shared/"..filename)
		if SERVER then
			AddCSLuaFile(folder.."/shared/"..filename)
		end
	end
end
include_folder = include_library
load_folder = include_library
load_library = include_library
