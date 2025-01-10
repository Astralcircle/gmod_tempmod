if not vFireInstalled then return end

local delay = 0

hook.Add("Think", "vFireTemperatureSupport", function()
    if CurTime() < delay then return end

    for _, ent in pairs(vFireGetBurningEntities()) do
        if not IsValid(ent) or not ent:IsTemperatureAvaiable() then continue end

        ent:SetTemperature(ent:GetTemperature() + 7)
    end

    delay = CurTime() + 1
end)
