include("shared.lua")

function ENT:Draw()
    if SERVER then return end
        
        local startPos = self:GetPos() + self:GetForward() * 20 + self:GetRight()*-1.7
        local endPos = self:GetPos() + self:GetForward() * 1000
        local tr = util.TraceLine({
            start = startPos,
            endpos = endPos,
            filter = self
        })

        self:DrawModel()

        if self:GetNW2Bool("Effect") then
        
        local ang = self:GetAngles()
        local pos = self:GetPos() + self:GetUp() * 3.5 + self:GetForward() * 1
        
        ang:RotateAroundAxis(ang:Right(), 00)
        ang:RotateAroundAxis(ang:Up(), 90)

        render.SetMaterial(Material("effects/blueblacklargebeam"))
        render.DrawBeam(startPos, tr.HitPos, 10, 1, 5, Color(255,0,0))

        render.SetMaterial(Material("effects/energyball"))
        render.DrawBeam(startPos, tr.HitPos, 7, 1, 5, Color(255,100,0))

        render.SetMaterial(Material("particle/bendibeam"))
        render.DrawBeam(tr.HitPos - self:GetForward() * math.min(100, (tr.HitPos - self:GetPos()):Length() - 1), tr.HitPos, 7, math.random(1,5), 1, Color(255,255,0))

        render.SetMaterial(Material("cable/new_cable_lit"))
        render.DrawBeam(startPos, tr.HitPos, 0.5, 1, 1, Color(255,255,0))

        render.SetMaterial(Material("sprites/glow04_noz"))
        render.DrawSprite(startPos+self:GetForward()*7, 30, 30, Color(255,150,0))

        render.SetMaterial(Material("sprites/glow04_noz"))
        render.DrawSprite(tr.HitPos, math.Rand(1,10), math.Rand(1,10), Color(255,100,0))

        render.SetMaterial(Material("sprites/glow04_noz"))
        render.DrawSprite(tr.HitPos, math.Rand(5,20), math.Rand(5,20), Color(255,100,0))
    end
end
