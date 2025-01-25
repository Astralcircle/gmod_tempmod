ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "#tempmod_thermometer"
ENT.Author = "Ty4a"
ENT.Category = "Temperature Mod"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "Celsius")
    self:NetworkVar("Int", "DisplayTemp")
end