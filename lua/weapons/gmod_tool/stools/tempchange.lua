if CLIENT then
    language.Add("tool.tempchange.name", "Temp Change")
    language.Add("tool.tempchange.desc", "Change the temperature of an object.")
    language.Add("tool.tempchange.left", "Set choosed temperature")
    language.Add("tool.tempchange.reload", "Set normal temperature")
end

TOOL.Category = "Temperature Mod"
TOOL.Name = "Temp Changer"
TOOL.ClientConVar["temp"] = "200"
TOOL.Information = {
    {
        name = "left"
    },
    {
        name = "reload"
    }
}

local effect_enabled = GetConVar("tempmod_effects_enabled")
local normal_temp = GetConVar("tempmod_normal_temperature")

function TOOL:LeftClick(trace)
    local ent = trace.Entity

    if IsValid(ent) and ent:GetClass() == "prop_physics" then
        if SERVER then
            ent:SetTemperature(self:GetClientNumber("temp"))

            if effect_enabled:GetBool() then
                if self:GetClientNumber("temp") > 100 then
                    local effectdata = EffectData()

                    effectdata:SetOrigin(ent:GetPos() + ent:OBBCenter())
                    effectdata:SetNormal(ent:GetUp())

                    util.Effect("hot_metal", effectdata)
                elseif self:GetClientNumber("temp") < -100 then
                    local effectdata = EffectData()

                    effectdata:SetOrigin(ent:GetPos() + ent:OBBCenter())
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
        ent:SetTemperature(normal_temp:GetInt())
    end

    return true
end

local color_box = Color(40, 40, 40, 200)

function TOOL:DrawHUD()
    local tr = LocalPlayer():GetEyeTrace()

    if IsValid(tr.Entity) and tr.Entity:GetClass() == "prop_physics" then
        local temp = tr.Entity:GetTemperature()
        local scrW, scrH = ScrW(), ScrH()

        draw.RoundedBox(2, scrW / 2 - 80, scrH / 2 + 30, scrW / 2 - 800, scrH / 2 - 475, color_box)
        draw.SimpleText(temp .. "°C", "Trebuchet24", scrW / 2, scrH / 2 + 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(tostring(temp * 9 / 5 + 32) .. "°F", "Trebuchet18", scrW / 2 - 70, scrH / 2 + 70, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(tostring(temp + 273) .. "°K", "Trebuchet18", scrW / 2 - 70, scrH / 2 + 85, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end

function TOOL.BuildCPanel(CPanel)
    CPanel:AddControl("Header", {Description = "Change the temperature of an object."})
    CPanel:AddControl("Slider", {Label = "Temperature", Command = "tempchange_temp", Type = "Float", Min = -50000, Max = 50000})
end