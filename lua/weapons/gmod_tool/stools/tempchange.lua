if CLIENT then
    language.Add("tool.tempchange.name", "Temp Change")
    language.Add("tool.tempchange.desc", "Change the temperature of an object.")
    language.Add("tool.tempchange.left", "Set choosed temperature")
    language.Add("tool.tempchange.reload", "Set normal temperature")
end

TOOL.Category = "Temperature Mod"
TOOL.Name = "#tempmod.tempmod_tempchangertool"

TOOL.ClientConVar[ "temp" ] = "200"

TOOL.Information = {
	{ name = "left" },
	{ name = "reload" }
}

local function SetTemperature(ply, ent, temp)
    if IsValid(ent) then
        if SERVER then
            ply:SetEntityTemperature(ent,self:GetClientNumber( "temp" ))
        end
        return true
    end
    return false
end

function TOOL:LeftClick(trace)
    local ent = trace.Entity
    if IsValid(ent) and ent:GetClass() == "prop_physics" then
        if SERVER then
            self.Owner:SetEntityTemperature(ent,self:GetClientNumber( "temp" ))
            if GetConVarNumber("tempmod_effects_enabled") == 1 then
                if self:GetClientNumber( "temp" ) and self:GetClientNumber( "temp" ) > 100 then
                    local effectdata = EffectData()
                    effectdata:SetOrigin(ent:GetPos()+ent:OBBCenter())
                    effectdata:SetNormal(ent:GetUp())
                    util.Effect("hot_metal", effectdata)
                elseif self:GetClientNumber( "temp" ) and self:GetClientNumber( "temp" ) < -100 then
                    local effectdata = EffectData()
                    effectdata:SetOrigin(ent:GetPos()+ent:OBBCenter())
                    effectdata:SetNormal(ent:GetUp())
                    util.Effect("cold_metal", effectdata)
                end
            end
        end
        return true
    end
    return false
end

function TOOL:RightClick(trace)
    return false
end

function TOOL:Reload(trace)
    local ent = trace.Entity
    if IsValid(ent) then
        return SetTemperature(self:GetOwner(), ent, GetConVarNumber("tempmod_normal_temperature"))
    end
    return false
end

function TOOL.BuildCPanel(CPanel)
    CPanel:AddControl("Header", { Description = "#tempmod.tempmod_tempchangertooldesc" })
    CPanel:AddControl( "Slider", { Label = "#tempmod.tempmod_temperature2", Command = "tempchange_temp", Type = "Float", Min = -5000, Max = 5000 } )
end
