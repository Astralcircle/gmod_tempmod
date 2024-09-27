include("shared.lua")

surface.CreateFont("vcrosdfont", {
    font = "VCR OSD Mono [RUS by Daymarius]",
    size = 25,
    blursize = 0,
    exteded = false,
    underline = true,
    italic = false,
    additive = true
})

local color_box = Color(20, 20, 20)

local material_smokestack = Material("particle/smokestack")
local material_glow04_noz = Material("sprites/glow04_noz")

function ENT:Draw()
    local startPos = self:GetPos()
    local selfForward = self:GetForward()

    local endPos = startPos + selfForward * 1000

    local tr = util.TraceLine({
        start = startPos,
        endpos = endPos,
        filter = self
    })

    self:DrawModel()
    
    local ang = self:GetAngles()
    local pos = startPos + self:GetUp() * 3.5 + selfForward * 1
    
    ang:RotateAroundAxis(ang:Right(), 00)
    ang:RotateAroundAxis(ang:Up(), 90)
    
    cam.Start3D2D(pos, ang, 0.1)
        draw.RoundedBox(6, -85, -25, 170, 50, color_box)

        draw.SimpleText(
            self:GetDisplayTemp() .. (self:GetCelsius() and "°C" or "°F"),
            "vcrosdfont",
            0, 0,
            color_white,
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER,
            1,
            color_black
        )
    cam.End3D2D()

    render.SetMaterial(material_smokestack)
    render.DrawBeam(startPos, tr.HitPos, 0.25, 2, 6, color_white)

    render.SetMaterial(material_glow04_noz)
    render.DrawSprite(startPos + selfForward * 7, 8, 8, color_white)

    render.SetMaterial(material_glow04_noz)
    render.DrawSprite(tr.HitPos, 5, 5, color_white)
end