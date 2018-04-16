local contentFolder, contentFolderLength

function GM:AddResources()
	contentFolder = GAMEMODE.FolderName.. "/content/"
	contentFolderLength = string.len(contentFolder) + 1

	resource.AddWorkshop("1357352304")
	AddContentFiles(contentFolder)
end

function AddContentFiles(name)
	local files, dirs = file.Find(name .."*", "LUA")
  for _, dir in pairs(dirs) do
		local nextDir = name ..dir .."/"
		if nextDir ~= "zombiesurvival/content/data/" then
    	AddContentFiles(nextDir)
		end
  end
	for _, filename in pairs(files)do
		local fileDir = string.sub(name ..filename, contentFolderLength)
		resource.AddFile(fileDir)
  end
end
