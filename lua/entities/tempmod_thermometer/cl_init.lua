include("shared.lua")

if CLIENT then
    surface.CreateFont("vcrosdfont", {
        font = "VCR OSD Mono [RUS by Daymarius]",
        size = 25,
        blursize = 0,
        exteded = false,
        underline = true,
        italic = false,
        additive = true
    })
end

function ENT:Draw()
    if SERVER then return end
    
    local startPos = self:GetPos()
    local endPos = self:GetPos() + self:GetForward() * 1000
    local tr = util.TraceLine({
        start = startPos,
        endpos = endPos,
        filter = self
    })

    self:DrawModel()
    
    local ang = self:GetAngles()
    local pos = self:GetPos() + self:GetUp() * 3.5 + self:GetForward() * 1
    
    ang:RotateAroundAxis(ang:Right(), 00)
    ang:RotateAroundAxis(ang:Up(), 90)
    
    cam.Start3D2D(pos, ang, 0.1)
        draw.RoundedBox(6, -85, -25, 170, 50, Color(20,20,20))

        draw.SimpleText(
            self:GetNWString("DisplayText", "No data"),
            "vcrosdfont",
            0, 0,
            Color(255, 255, 255, 255),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER,
            1,
            Color(0, 0, 0, 255)
        )
    cam.End3D2D()

    render.SetMaterial(Material("particle/smokestack"))
    render.DrawBeam(self:GetPos(), tr.HitPos, 0.2, 1, 6, Color(255,255,255))

    render.SetMaterial(Material("sprites/glow04_noz"))
    render.DrawSprite(self:GetPos()+self:GetForward()*7, 8, 8, Color(255,255,255))

    render.SetMaterial(Material("sprites/glow04_noz"))
    render.DrawSprite(tr.HitPos, 25, 25, Color(255,255,255))
end
