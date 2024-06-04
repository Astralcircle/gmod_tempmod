include("hightemperature.lua")

local function SetEntityTemperature(ent, temp)
    if ent and ent.SetTemperature then
        ent:SetTemperature(temp)
        if SERVER then
            ent:SetNWFloat("Temperature", temp)
        end
    end
end

local function IncreaseTemperatureNearBurningProps()
    for _, burningProp in ipairs(ents.FindByClass("prop_physics")) do
        if burningProp:IsOnFire() then
            local nearbyEntities = ents.FindInSphere(burningProp:GetPos(), 100)

            for _, ent in ipairs(nearbyEntities) do
                if IsValid(ent) and ent != burningProp then
                    local currentTemp = ent:GetNW2Float("Temperature", GetConVar("tempmod_normal_temperature"):GetFloat())
                    local newTemp = currentTemp + 2

                    ent:SetNW2Float("Temperature", math.Round(newTemp))
                    burningProp:SetEntityTemperature(ent,math.Round(newTemp))
                end
            end
        end
    end
end

timer.Create("IncreaseTempNearBurningPropsTimer", 1, 0, IncreaseTemperatureNearBurningProps)
