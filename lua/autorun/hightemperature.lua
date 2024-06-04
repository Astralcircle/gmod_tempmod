local ent = FindMetaTable("Entity")

CreateConVar("tempmod_normal_temperature", "20", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Normal temperature for objects")
CreateConVar("tempmod_damageprops", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Damage props by temperature")
CreateConVar("tempmod_tempfordamage", "100", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "If the temperature is equal to this number then the prop will break")
CreateConVar("tempmod_tempspread", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Temperature spread")
CreateConVar("tempmod_tempspread_value", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Temperature spread value")
CreateConVar("tempmod_tempdecrease_value", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Temperature decrease value")
CreateConVar("tempmod_tempincrease_value", "5", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Temperature increase value")

function ent:GetEntityTemperature()
    self:GetNW2Int("Temperature", 20)
    return self.Temperature or GetConVarNumber("tempmod_normal_temperature")
end

function ent:UpdateEntityColor(ent)
    if !IsValid(ent) or !ent then return end

    if ent and ent:GetEntityTemperature() >= GetConVarNumber("tempmod_tempfordamage") and GetConVarNumber("tempmod_damageprops") == 1 or ent:GetEntityTemperature() <= -100 and GetConVarNumber("tempmod_damageprops") then
        ent:SetHealth(ent:Health()-1)

        if ent:Health() and ent:Health() == 1 then
            ent:Fire("Break") 
        end
    end

    if CLIENT then return end

    if self:GetEntityTemperature() >= 100 and self:GetEntityTemperature() < 999 then
        if self:GetMaterialType() and self:GetMaterialType() == MAT_METAL then
            if self:GetEntityTemperature() >= 50 then
                local color = math.Clamp((self:GetEntityTemperature() - 100) / 1000, 0, 1) * 255
                self:SetColor(Color(255, 255 - color, 255 - color))
            else
                self:SetColor(Color(255, 255, 255))
            end
        else
            if self:GetEntityTemperature() >= 100 then
                local color = math.Clamp((self:GetEntityTemperature() - 100) / 300, 0, 1) * 255
                self:SetColor(Color(255 - color, 255 - color, 255 - color))
            else
                self:SetColor(Color(0, 0, 0))
            end
        end
    elseif self:GetEntityTemperature() >= 999 and self:GetMaterialType() == MAT_METAL then
        self:SetColor(Color(255, 255, 255))
    elseif self:GetEntityTemperature() >= 999 and self:GetMaterialType() != MAT_METAL then
        self:SetColor(Color(0, 0, 0))
    elseif self:GetEntityTemperature() < 100 then
        self:SetColor(Color(255, 255, 255))
    end

    if self:GetEntityTemperature() < -100 and self:GetMaterialType() == MAT_METAL then
        if self:GetEntityTemperature() < 0 then
            local color = math.Clamp((self:GetEntityTemperature() - 100) / 300, 0, 1) * 255
            self:SetColor(Color(255 - color, 255 - color, 255 - color))
        else
            self:SetColor(Color(255, 255, 255))
        end
    end
end

function ent:UpdateMaterialProperties(ent)

    if not SERVER then return end

    if ent:GetMaterialType() == MAT_METAL then
        if ent:GetEntityTemperature() > 999 and not ent:GetNWBool("OnFire") then
            ent:SetNWBool("OnFire", true)
            ent:SetMaterial("temperaturemod/metal/metalwhite")
            if CLIENT and GetConVarNumber("tempmod_effects_enabled") >= 1 then
                if ent:GetMaterialType() == MAT_METAL and ent:GetEntityTemperature() > 150 then
                    local effectdata = EffectData()
                    effectdata:SetOrigin(ent:GetPos()+ent:OBBCenter())
                    effectdata:SetNormal(ent:GetUp())
                    util.Effect("hot_metal", effectdata)
                end

                if ent:GetMaterialType() == MAT_METAL and ent:GetEntityTemperature() <= -100 then
                    local effectdata = EffectData()
                    effectdata:SetOrigin(ent:GetPos()+ent:OBBCenter())
                    effectdata:SetNormal(ent:GetUp())
                    util.Effect("cold_metal", effectdata)
                end
            end
        elseif ent and ent:GetEntityTemperature() <= 999 and ent:GetNWBool("OnFire") then
            ent:SetNWBool("OnFire", false)
            ent:SetMaterial("")
        end
    end
end
    
function ent:SetEntityTemperature(ent, temp)
    ent.Temperature = temp
    ent:UpdateEntityColor(ent)
    ent:UpdateMaterialProperties(ent)

    if SERVER and ent:GetMaterialType() == MAT_WOOD and ent:GetEntityTemperature() >= 300 and ent:WaterLevel() < 2 then
        ent:Ignite(60*temp)
    end

    if SERVER then
        ent:SetNW2Float("Temperature", temp)
    end
end

if SERVER then
    AddCSLuaFile()

    hook.Add("OnEntityCreated", "InitializeEntityTemperature", function(ent)
        if ent:IsValid() and ent:GetClass() == "prop_physics" then
            timer.Simple(0, function()
                if IsValid(ent) then
                    ent:SetEntityTemperature(ent, GetConVarNumber("tempmod_normal_temperature"))

                    ent.SetTemperature = ent.SetEntityTemperature
                    ent.GetTemperature = ent.GetEntityTemperature

                    ent:SetNWBool("OnFire", false)
                end

                if IsValid(ent) and ent:GetMaterialType() == MAT_METAL then
                    ent:SetNWFloat("Temp_IsMetal", 1)
                elseif IsValid(ent) and ent:GetMaterialType() != MAT_METAL then
                    ent:SetNWFloat("Temp_IsMetal", 0)
                end
            end)
        end
    end)

    timer.Create("Temperature", 0.5, 0, function()
        for _, ply in ipairs(player.GetAll()) do
            if not IsValid(ply) then return end

            local entities = ents.FindInSphere(ply:GetPos(), 50)
            for _, ent in ipairs(entities) do
                if IsValid(ent) and ent.GetTemperature and ent:GetEntityTemperature() >= 50 and ply:Health() > 0 then
                    local dmg = DamageInfo()
                    dmg:SetDamage((ent:GetEntityTemperature() - 100) / 10)
                    dmg:SetAttacker(ent)
                    dmg:SetInflictor(ent)
                    dmg:SetDamageType(DMG_BURN)
                    ply:TakeDamageInfo(dmg)
                    if GetConVarNumber("tempmod_effects_enabled") >= 1 then
                        local effectdata = EffectData()
                        effectdata:SetOrigin(ply:GetPos()+ply:OBBCenter())
                        effectdata:SetNormal(ply:GetUp())
                        util.Effect("hot_metal", effectdata)
                    end
                    break
                elseif IsValid(ent) and ent.GetTemperature and ent:GetEntityTemperature() < -20 and ply:Health() > 0 then
                    local dmg = DamageInfo()
                    dmg:SetDamage((-ent:GetEntityTemperature() - 100) / 100)
                    dmg:SetAttacker(ent)
                    dmg:SetInflictor(ent)
                    dmg:SetDamageType(DMG_CLUB)
                    ply:TakeDamageInfo(dmg)
                    if GetConVarNumber("tempmod_effects_enabled") >= 1 then
                        local effectdata = EffectData()
                        effectdata:SetOrigin(ply:GetPos()+ply:OBBCenter())
                        effectdata:SetNormal(ply:GetUp())
                        util.Effect("cold_metal", effectdata)
                    end
                    break
                end
            end
        end

        for _, npc in ipairs(ents.FindByClass("npc_*")) do
            if not IsValid(npc) then return end

            local entities = ents.FindInSphere(npc:GetPos(), 10)
            for _, ent in ipairs(entities) do
                if IsValid(ent) and ent.GetTemperature and ent:GetEntityTemperature() > 50 and npc:Health() > 0 then
                    local dmg = DamageInfo()
                    dmg:SetDamage((ent:GetEntityTemperature() - 100) / 10)
                    dmg:SetAttacker(ent)
                    dmg:SetInflictor(ent)
                    dmg:SetDamageType(DMG_BURN)
                    npc:TakeDamageInfo(dmg)
                    if GetConVarNumber("tempmod_effects_enabled") >= 1 then
                        local effectdata = EffectData()
                        effectdata:SetOrigin(npc:GetPos()+npc:OBBCenter())
                        effectdata:SetNormal(npc:GetUp())
                        util.Effect("hot_metal", effectdata)
                    end
                    break
                elseif IsValid(ent) and ent.GetTemperature and ent:GetEntityTemperature() < -1 and ply:Health() > 0 then
                    local dmg = DamageInfo()
                    dmg:SetDamage((-ent:GetEntityTemperature() - 100) / 100)
                    dmg:SetAttacker(ent)
                    dmg:SetInflictor(ent)
                    dmg:SetDamageType(DMG_CLUB)
                    npc:TakeDamageInfo(dmg)
                    local effectdata = EffectData()
                    effectdata:SetOrigin(npc:GetPos()+npc:OBBCenter())
                    effectdata:SetNormal(npc:GetUp())
                    util.Effect("cold_metal", effectdata)
                    break
                end
            end
        end
    end)

    timer.Create("DecreaseTemperature", 1, 0, function()
        for _, ent in ipairs(ents.GetAll()) do
            if IsValid(ent) and ent.GetTemperature then
                local temp = ent:GetEntityTemperature()
                if temp then
                    if temp > GetConVarNumber("tempmod_normal_temperature") then
                        if ent:WaterLevel() >= 2 then
                            temp = temp - 5
                            if temp > 100 and GetConVarNumber("tempmod_effects") >= 1 then
                            local effectdata = EffectData()
                            effectdata:SetOrigin(ent:GetPos()+ent:OBBCenter())
                            effectdata:SetNormal(ent:GetPos())
                            effectdata:SetOrigin(ent:GetPos())
                            util.Effect("hot_metal", effectdata)
                            end
                        else
                            temp = temp - GetConVarNumber("tempmod_tempdecrease_value")
                        end
                        
                        temp = math.max(temp, GetConVarNumber("tempmod_normal_temperature"))

                        ent:SetEntityTemperature(ent, temp)
                        ent:UpdateMaterialProperties(ent)
                    end
                end
            end
        end
    end)

    timer.Create("PlayHotSound", 5, 0, function()
        for _, ent in ipairs(ents.GetAll()) do
            if IsValid(ent) and ent.GetTemperature then
                local temperature = ent:GetTemperature() or 20
                if ent:GetMaterialType() == MAT_METAL then
                    if temperature > 100 then
                    local volume = math.Clamp((temperature - 100) / 1000, 0, 1)
                    sound.Play("hl1/ambience/steamburst1.wav", ent:GetPos(), 65, 100, volume)
                    ent.HotMetalSound = sound
                end
                end
            end
        end
    end)

    timer.Create("IncreaseTemperature", 1, 0, function()
        for _, ent in ipairs(ents.GetAll()) do
            if IsValid(ent) and ent.GetTemperature then
                local temp = ent:GetEntityTemperature()
                if ent:IsOnFire() then
                    temp = temp + GetConVarNumber("tempmod_tempincrease_value")
                    ent:SetEntityTemperature(ent, temp+1)
                end
            end
        end
    end)

    timer.Create("SpreadTemperature", 2 ,0 ,function()
        if GetConVarNumber("tempmod_tempspread") == 0 then return end
        for _, ent in ipairs(ents.GetAll()) do
            if IsValid(ent) and ent:GetMaterialType() == MAT_METAL and ent.GetTemperature and (ent:GetEntityTemperature() * 0.05) > GetConVarNumber("tempmod_normal_temperature") then
                local nearbyEntities = ents.FindInSphere(ent:GetPos(), 70)
                for _, nearbyEnt in ipairs(nearbyEntities) do
                    if IsValid(nearbyEnt) and nearbyEnt:GetClass() == "prop_physics" and nearbyEnt != ent and ent:GetMaterialType() == MAT_METAL and ent:GetEntityTemperature()*GetConVarNumber("tempmod_tempspread_value") > nearbyEnt:GetEntityTemperature() then
                        nearbyEnt:SetEntityTemperature(nearbyEnt,math.Round((ent:GetEntityTemperature()*GetConVarNumber("tempmod_tempspread_value"))))
                    end
                end
            end
        end
    end)

    concommand.Add("set_temp", function(ply, cmd, args)
        local tr = ply:GetEyeTrace()
        if not tr.Hit then return end

        local ent = tr.Entity
        if IsValid(ent) and ent:GetClass() == "prop_physics" then
            local temp = tonumber(args[1])
            if temp then
                ent:SetEntityTemperature(ent, temp)
            end
        end
    end)

    concommand.Add("get_temp", function(ply, cmd, args)
        local tr = ply:GetEyeTrace()
        if not tr.Hit then return end

        local ent = tr.Entity
        if IsValid(ent) and ent:GetClass() == "prop_physics" then
            ply:ChatPrint(ent:GetClass().." Temperature")
            ply:ChatPrint("- "..ent:GetEntityTemperature().." Celsius")
            ply:ChatPrint("- "..tostring(ent:GetEntityTemperature()*9/5+32).." Fahrenheit")
        end
    end)

end

if CLIENT then
    CreateClientConVar("tempmod_effects_enabled", "1", true, true, "Enable or disable effects for the temperature mod")

    CreateClientConVar("tempmod_glow_enabled", "1", true, true, "Enable or disable glow for the temperature mod")

    CreateClientConVar("tempmod_glow_max", "5", true, true, "How many objects can be glow")
end