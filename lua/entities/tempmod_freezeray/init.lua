AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/gibs/airboat_broken_engine.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self.temperature = 0
    self.soundPlayed = false
    self.enabled = 0
    self.strength = 1

    self:SetAngles(self:GetAngles() + Angle(0,180,0))

    if WireAddon then
	    self.Inputs = WireLib.CreateSpecialInputs(self, {"Enable"}, {"NORMAL"})
    end   

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:Think()
    self:StartMeasureTemperature()
end

function ENT:Use(activator)
    if activator:IsPlayer() then
        if self.enabled == 1 then
            self.enabled = 0
            self:SetEffect(false)
            self:EmitSound("vehicles/apc/apc_shutdown.wav",75,200,100,CHAN_AUTO)
        else
            self.enabled = 1
            self:SetEffect(true)
            self:EmitSound("beams/beamstart5.wav",75,255,100,CHAN_AUTO)
        end
    end
end

function ENT:GetEntityTemperature(ent)
    if ent then
        return ent:GetTemperature()
    else
        return nil
    end
end

function ENT:SetEntityTemperature(ent, temp)
    if ent then
        ent:SetTemperature(temp)
        if SERVER then
            ent:SetNW2Float("Temperature", temp)
        end
    end
end

function ENT:StartMeasureTemperature()
    local startPos = self:GetPos()
    local endPos = self:GetPos() + self:GetForward() * 1000

    local tr = util.TraceLine({
        start = startPos,
        endpos = endPos,
        filter = self
    })

    if tr.Hit and tr.Entity and !tr.HitWorld and self.enabled == 1 then
        local temp = tr.Entity:GetTemperature()

        if tr.Entity:GetClass() == "tempmod_heatray" and self.enabled == 1 then
            local effectdata = EffectData()
            effectdata:SetOrigin(tr.Entity:GetPos()+tr.Entity:OBBCenter())
            effectdata:SetNormal(tr.Entity:GetUp())
            util.Effect("cold_metal", effectdata)
            tr.Entity:Remove()
        end

        if tr.Entity:IsPlayer() or tr.Entity:IsNPC() then
            local dmg = DamageInfo()
            dmg:SetDamage(70)
            dmg:SetAttacker(self)
            dmg:SetInflictor(self)
            dmg:SetDamageType(DMG_CLUB)
            tr.Entity:TakeDamageInfo(dmg)
            if GetConVarNumber("tempmod_effects_enabled") >= 1 then
            local effectdata = EffectData()
                effectdata:SetOrigin(tr.Entity:GetPos()+tr.Entity:OBBCenter())
                effectdata:SetNormal(tr.Entity:GetUp())
                util.Effect("cold_metal", effectdata)
            end
        elseif tr.Entity:GetClass() == "prop_physics" then
            tr.Entity:SetTemperature(temp - math.Rand(1,2)*self.strength)
        end

    end
end

function ENT:TriggerInput(iname, value)
    if iname == "Enable" then
	self.enabled = math.Clamp(value, 0, 1)

        if value == 1 then
            self:SetEffect(true)
        else
            self:SetEffect(false)
        end
    end
end