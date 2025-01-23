AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_lab/reciever01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self.temperature = 0
    self.soundPlayed = false

    local sprite = ents.Create("env_sprite")
    sprite:SetKeyValue("model", "sprites/glow03.vmt")
    sprite:SetKeyValue("rendermode", "9")
    sprite:SetPos(self:GetPos() + self:GetUp() * 2 + self:GetForward() * 1)
    sprite:SetKeyValue("scale", "0.25")
    sprite:SetKeyValue("rendercolor", "150 150 150")
    sprite:SetKeyValue("spawnflags", "0")
    sprite:SetKeyValue("renderamt", "255")
    sprite:SetParent(self)
    sprite:Spawn()
    sprite:Activate()

    if WireLib then
        self.Outputs = WireLib.CreateOutputs(self, {"Celsius"})
    end

    self:PhysWake()
end

function ENT:Think(activator, caller)
    self:StartMeasureTemperature()

    if WireLib then
        WireLib.TriggerOutput(self, "Celsius", self.temperature)
    end
end

function ENT:Use(activator)
    if activator:IsPlayer() then
        if self:GetCelsius() then
            self:SetCelsius(false)
        else
            self:SetCelsius(true)
        end

        self:EmitSound("buttons/button14.wav", 75, 255, 100, CHAN_AUTO)
    end
end

function ENT:StartMeasureTemperature()
    local startPos = self:GetPos()
    local endPos = startPos + self:GetForward() * 1000

    local ent = util.TraceLine({
        start = startPos,
        endpos = endPos,
        filter = self
    }).Entity

    if IsValid(ent) then
        self.temperature = ent:IsPlayer() and 36.6 or math.min(ent:GetTemperature(), 999999)

        if not self.soundPlayed then
            self:EmitSound("buttons/button10.wav",75, 255, 100, CHAN_AUTO)
            self.soundPlayed = true
        end
    else
        self.temperature = 0
        self.soundPlayed = false
    end

    if self:GetCelsius() then
        self:SetDisplayTemp(self.temperature)
    else
        self:SetDisplayTemp(self.temperature * 9 / 5 + 32)
    end
end
