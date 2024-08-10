if vFireInstalled then
    local TimeUpdate = CurTime()
    hook.Add("Think", "vFireTemperatureSupport", function()
        local curTime = CurTime()
        for burningEnt, sameEnt in pairs (vFireGetBurningEntities()) do
            if sameEnt:IsTemperatureAvaiable() then
                if not TimeUpdate or curTime - TimeUpdate > 1 then
                    local temp = sameEnt:GetTemperature()
                    sameEnt:SetTemperature(temp+7)

                    TimeUpdate = curTime + 1
                end
            end
        end
    end)
end