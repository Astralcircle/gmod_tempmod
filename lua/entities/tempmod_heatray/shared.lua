ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "#tempmod_heatray"
ENT.Author = "Ty4a"
ENT.Category = "Temperature Mod"
ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "Effect")
end