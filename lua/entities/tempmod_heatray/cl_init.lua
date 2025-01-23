include("shared.lua")

local color_red = Color(255, 0, 0)
local color_orange = Color(255, 100, 0)
local color_orange2 = Color(255, 150, 0)
local color_yellow = Color(255, 255, 0)

local material_bluebeam = Material("effects/blueblacklargebeam")
local material_ball = Material("effects/energyball")
local material_cablenew = Material("cable/new_cable_lit")
local material_glow = Material("sprites/glow04_noz")

function ENT:Draw()
    self:DrawModel()

    if self:GetEffect() then
        local selfpos = self:GetPos()
        local selfforward = self:GetForward()

        local startPos = selfpos + selfforward * 20 + self:GetRight() * -1.7
        local endPos = selfpos + selfforward * 1000

        local hit = util.TraceLine({
            start = startPos,
            endpos = endPos,
            filter = self
        }).HitPos

        local ang = self:GetAngles()
        ang:RotateAroundAxis(ang:Right(), 00)
        ang:RotateAroundAxis(ang:Up(), 90)

        render.SetMaterial(material_bluebeam)
        render.DrawBeam(startPos, hit, 10, 1, 5, color_red)

        render.SetMaterial(material_ball)
        render.DrawBeam(startPos, hit, 7, 1, 5, color_orange)

        render.SetMaterial(material_cablenew)
        render.DrawBeam(startPos, hit, 0.5, 1, 1, color_yellow)

        render.SetMaterial(material_glow)
        render.DrawSprite(startPos + selfforward * 7, 30, 30, color_orange2)
        render.DrawSprite(hit, math.Rand(1, 10), math.Rand(1, 10), color_orange)
        render.DrawSprite(hit, math.Rand(5, 20), math.Rand(5, 20), color_orange)
    end
end

function ENT:Think()

end
