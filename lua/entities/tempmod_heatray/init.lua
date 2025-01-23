AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/gibs/airboat_broken_engine.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    self:SetAngles(Angle(0, 180, 0))

    if WireLib then
        self.Inputs = WireLib.CreateSpecialInputs(self, {"Enable"}, {"NORMAL"})
    end

    self:PhysWake()
end

function ENT:SpawnFunction(ply, tr, class)
	if not tr.Hit then return end

	local ent = ents.Create(class)
	ent:SetPos(tr.HitPos)
    ent:SetPlayer(ply)
	ent:Spawn()

	return ent
end

function ENT:Think()
    if self.enabled then
        self:StartMeasureTemperature()
    end
end

function ENT:Use(activator)
    if activator:IsPlayer() then
        if self.enabled then
            self.enabled = false
            self:SetEffect(false)
            self:EmitSound("vehicles/apc/apc_shutdown.wav", 75, 200, 100, CHAN_AUTO)
        else
            self.enabled = true
            self:SetEffect(true)
            self:EmitSound("beams/beamstart5.wav", 75, 255, 100, CHAN_AUTO)
        end
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

    if not IsValid(ent) then return end

    if ent:GetClass() == "tempmod_freezeray" then
        local effectdata = EffectData()
        effectdata:SetOrigin(ent:GetPos() + ent:OBBCenter())
        effectdata:SetNormal(ent:GetUp())
        util.Effect("hot_metal", effectdata)

        sound.Play("ambient/fire/ignite.wav", ent:GetPos(), 75, 255, 100)
        ent:Remove()

        return
    end

    if ent:IsPlayer() or ent:IsNPC() then
        local dmg = DamageInfo()
        local ply = self:GetPlayer()

        dmg:SetDamage(70)
        dmg:SetAttacker(IsValid(ply) and ply or self)
        dmg:SetInflictor(self)
        dmg:SetDamageType(DMG_BURN)
        ent:TakeDamageInfo(dmg)
    elseif ent:IsTemperatureAvaiable() then
        ent:SetTemperature(ent:GetTemperature() + math.Rand(1, 2))
    end
end

function ENT:TriggerInput(iname, value)
    if iname == "Enable" then
        self.enabled = tobool(value)

        if self.enabled then
            self:SetEffect(true)
        else
            self:SetEffect(false)
        end
    end
end