local function safeAddCSLuaFile(filePath)
    if SERVER then
        AddCSLuaFile(filePath)
    end
end

local function includeFile(filePath)
    if SERVER then
        include(filePath)
    elseif CLIENT then
        include(filePath)
    end
end

local function loadFile(filePath)
    if string.find(filePath, "sh_") then
        safeAddCSLuaFile(filePath)
        includeFile(filePath)
        if SERVER then
            print("Temperature Mod: "..filePath.." Loaded")
        end
    elseif string.find(filePath, "cl_") then
        safeAddCSLuaFile(filePath)
        if CLIENT then
            includeFile(filePath)
        end

        if SERVER then
            print("Temperature Mod: "..filePath.." Loaded")
        end
    elseif string.find(filePath, "sv_") then
        includeFile(filePath)
        if SERVER then
            print("Temperature Mod: "..filePath.." Loaded")
        end
    end
end

local function loadModules(folder)
    local files, directories = file.Find(folder .. "/*", "LUA")
    for _, fileName in ipairs(files) do
        loadFile(folder .. "/" .. fileName)
    end
    for _, dirName in ipairs(directories) do
        loadModules(folder .. "/" .. dirName)
    end
end

include("tempmod/sh_init.lua")

if SERVER then
   include("tempmod/sv_init.lua")
else
   include("tempmod/cl_init.lua")
end

loadModules("tempmod/modules")
