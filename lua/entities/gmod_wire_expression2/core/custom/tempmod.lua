local isOwner = E2Lib.isOwner

e2function number entity:isTemperatureAvaiable()
    if not IsValid(this) then return self:throw("Invalid entity!", 0) end

    return this:IsTemperatureAvaiable() and 1 or 0
end

e2function number entity:getTemperature()
    if not IsValid(this) then return self:throw("Invalid entity!", 0) end

    return this:GetTemperature()
end

e2function void entity:setTemperature(number temperature)
    if not IsValid(this) then return self:throw("Invalid entity!", nil) end
    if not isOwner(self, this) then return self:throw("You do not own this entity!", nil) end
    if not this:IsTemperatureAvaiable() then return self:throw("Temperature is not available on this entity!", nil) end

    this:SetTemperature(temperature)
end