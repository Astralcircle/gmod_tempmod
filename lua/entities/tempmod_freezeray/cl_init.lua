include("shared.lua")

local color_blueblack = Color(200, 200, 255)
local color_energyball = Color(0, 50, 255)
local color_bendibeam = Color(100, 100, 255)
local color_blue = Color(0, 0, 255)

local material_blueblack = Material("effects/blueblacklargebeam")
local material_ball = Material("effects/energyball")
local material_laser = Material("effects/laser1")
local material_glow = Material("sprites/glow04_noz")

local oldeffect_state = false

function ENT:Draw()
    self:DrawModel()

    if self:GetEffect() then
        oldeffect_state = true

        local selfpos = self:GetPos()
        local selfforward = self:GetForward()

        local startPos = selfpos + selfforward * 20 + self:GetRight() * -1.7
        local endPos = selfpos + selfforward * 1000

        local hit = util.TraceLine({
            start = startPos,
            endpos = endPos,
            filter = self
        }).HitPos

        local mins, maxs = self:GetModelBounds()
        self:SetRenderBoundsWS(self:LocalToWorld(mins), self:LocalToWorld(maxs) + selfforward * hit:Distance(startPos))

        local ang = self:GetAngles()
        ang:RotateAroundAxis(ang:Right(), 00)
        ang:RotateAroundAxis(ang:Up(), 90)

        render.SetMaterial(material_blueblack)
        render.DrawBeam(startPos, hit, 1, 1, 5, color_blueblack)

        render.SetMaterial(material_ball)
        render.DrawBeam(startPos, hit, 5, 1, 2, color_energyball)

        render.SetMaterial(material_laser)
        render.DrawBeam(startPos, hit, 5, 1, 1, color_blue)

        render.SetMaterial(material_glow)
        render.DrawSprite(startPos + selfforward * 7, 30, 30, color_bendibeam)
        render.DrawSprite(hit, math.Rand(1, 10), math.Rand(1, 10), color_bendibeam)
        render.DrawSprite(hit, math.Rand(5, 20), math.Rand(5, 20), color_bendibeam)
    elseif oldeffect_state then
        self:SetRenderBounds(self:GetModelBounds())
        oldeffect_state = false
    end
end

function ENT:Think()

end
