hook.Add("PreDrawHalos", "AddHotMetalHalos", function()

    if GetConVarNumber("tempmod_glow_enabled") < 1 then
        return
    end

    local hotEntities = {}
    local count = -1

    for _, ent in ipairs(ents.FindByClass("prop_physics")) do
        local temperature = ent:GetNW2Float("Temperature", 20)
        if temperature >= 999 and ent:GetNWFloat("Temp_IsMetal") == 1 then
            table.insert(hotEntities, ent)
            count = count + 1
            
            if count > GetConVarNumber("tempmod_glow_max")-2 then
                break
            end

            if temperature < 3000 then
                halo.Add(hotEntities, Color(255, 0, 0), 0.0025*temperature, 0.0025*temperature, 5, true, false)
                halo.Add(hotEntities, Color(255, 250, 0), 2, 2, 4, true, false)
            else
                halo.Add(hotEntities, Color(255, 0, 0), 5, 5, 5, true, false)
                halo.Add(hotEntities, Color(255, 250, 0), 2, 2, 4, true, false)
            end
        end
    end
end)