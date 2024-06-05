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
    self.type = 1
    self.wire_disable = 0

    if WireAddon then
	self.Inputs = WireLib.CreateSpecialInputs(self, {"Disable", "Type"}, {"NORMAL", "NORMAL"})
	self.Outputs = WireLib.CreateSpecialOutputs(self, {"Temperature"}, {"NORMAL"})
    end

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:Think(activator, caller)
    if WireAddon then
	if self.wire_disable == 1 then return end
	self:StartMeasureTemperature()
	if self.type == 1 then
	    WireLib.TriggerOutput(self, "Temperature", self.temperature)
	else
	    WireLib.TriggerOutput(self, "Temperature", math.Round(self.temperature*9/5+32, 1))
	end
    else
	self:StartMeasureTemperature()
    end
end

function ENT:Use(activator)
    if activator:IsPlayer() then
        if self.type == 1 then
            self.type = 2
        else
            self.type = 1
        end
        self:EmitSound("buttons/button14.wav",75,255,100,CHAN_AUTO)
    end
end

function ENT:GetEntityTemperature(ent)
    if ent and ent.GetTemperature then
	return ent:GetTemperature()
    else
        return nil
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

    if tr.Hit and tr.Entity and !tr.HitWorld then
        local temp = tr.Entity:GetEntityTemperature()

        if tr.Entity:IsPlayer() then
            temp = 36.6
        end

        if temp > 999999 then
            temp = 999999
        end

        if temp then
            if tr.Entity:GetModel() == "models/props_junk/gnome.mdl" then
                self.temperature = 36.6 
            end
            
            if tr.Entity:GetModel() != "models/props_junk/gnome.mdl" then
                if tr.Entity:WaterLevel() > 0 then
                    self.temperature = temp / tr.Entity:WaterLevel()
                else
                    self.temperature = temp
                end
            end

            if not self.soundPlayed then
                self:EmitSound("buttons/button10.wav",75,255,100,CHAN_AUTO)
                self.soundPlayed = true
            end
        else
            self.temperature = 0
            self.soundPlayed = false
        end
    else
        self.temperature = 0
    end

        if self.type == 1 then
            self:SetNWString("DisplayText", tostring(math.Round(self.temperature,1)).."°C")
        else
            self:SetNWString("DisplayText", tostring(math.Round(self.temperature*9/5+32,1)).."°F")
        end

    
end

function ENT:TriggerInput(iname, value)
    if iname == "Disable" then
	self.wire_disable = value
	self:SetNWInt("Disable", value)
    elseif iname == "Type" then
	self.type = math.Clamp(value, 1, 2)
    end
end
