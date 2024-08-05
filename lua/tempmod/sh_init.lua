AddCSLuaFile()

local meta = FindMetaTable("Entity")

function meta:IsTemperatureAvaiable()
    return self:GetClass() == "prop_physics"
end

function meta:GetTemperature()
    return self:GetNW2Int("Temperature", 0)
end