hook.Add("PreDrawHalos", "AddHotMetalHalos", function()
    if CLIENT then
        if GetConVarNumber("tempmod_glow_enabled") == 0 then return end
        local hotEntities = {}
        local count = -1
        local ply = LocalPlayer()

        for _, ent in ipairs(ents.FindByClass("prop_physics")) do
            if ent:GetNW2Bool("IsMetalObject") == true then
            local temperature = ent:GetTemperature()
            if temperature >= 999 then
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
        end
    end
end)