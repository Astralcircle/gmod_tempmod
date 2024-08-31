include("shared.lua")

local color_blueblack = Color(200, 200, 255)
local color_energyball = Color(0, 50, 255)
local color_bendibeam = Color(100, 100, 255)
local color_blue = Color(0, 0, 255)

local material_blueblack = Material("effects/blueblacklargebeam")
local material_ball = Material("effects/energyball")
local material_bendbeam = Material("particle/bendibeam")
local material_laser = Material("effects/laser1")
local material_glow = Material("sprites/glow04_noz")

function ENT:Draw()
    local selfpos = self:GetPos()
    local selfforward = self:GetForward()

    local startPos = selfpos + selfforward * 20 + self:GetRight() * -1.7
    local endPos = selfpos + selfforward * 1000

    local tr = util.TraceLine({
        start = startPos,
        endpos = endPos,
        filter = self
    })

    self:DrawModel()

    if self:GetNW2Bool("Effect") then
        local ang = self:GetAngles()
        local pos = selfpos + self:GetUp() * 3.5 + selfforward * 1
        
        ang:RotateAroundAxis(ang:Right(), 00)
        ang:RotateAroundAxis(ang:Up(), 90)

        local hit = tr.HitPos

        render.SetMaterial(material_blueblack)
        render.DrawBeam(startPos, hit, 1, 1, 5, color_blueblack)

        render.SetMaterial(material_ball)
        render.DrawBeam(startPos, hit, 5, 1, 2, color_energyball)

        render.SetMaterial(material_laser)
        render.DrawBeam(startPos, hit, 5, 1, 1, color_blue)

        render.SetMaterial(material_glow)
        render.DrawSprite(startPos + selfforward * 7, 30, 30, color_bendibeam)
        render.DrawSprite(hit, math.Rand(1,10), math.Rand(1,10), color_bendibeam)
        render.DrawSprite(hit, math.Rand(5,20), math.Rand(5,20), color_bendibeam)
    end
end
