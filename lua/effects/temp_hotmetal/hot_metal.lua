function EFFECT:Init( data )
	
	self.StartPos = data:GetOrigin()
	
	self.Dir = data:GetNormal()
	
	self.LifeTime 	= 1
	
	self.DieTime 	= CurTime() + self.LifeTime
	
	self.Mult = 0.2
	
	self.Gravity 	= Vector(0, 0, -GetConVarNumber("sv_gravity",800))
	
	self.FleckLife = 3
	
	local emitter = ParticleEmitter(self.StartPos)

	for i = 1, 10 do
	
		local particle = emitter:Add("particles/smokey", self.StartPos)
		
		particle:SetVelocity((self.Dir + VectorRand(-255,255) * 0.5) * math.Rand(0, 1)*i)
		particle:SetDieTime(math.Rand(0.25, 5))
		particle:SetStartAlpha(math.random(0,10))
		particle:SetStartSize(math.Rand(5, 10))
		particle:SetEndSize(math.Rand(5,30))
		particle:SetRoll(math.random(-1,1))
        particle:SetRollDelta(math.random(0,1))
		particle:SetGravity(-self.Gravity)
		particle:SetCollide(true)
		particle:SetAirResistance(600)
		particle:SetVelocityScale(true)
		particle:SetCollide(true)
	end

    local particle = emitter:Add("sprites/heatwave", self.StartPos)
		
		particle:SetVelocity((self.Dir + VectorRand() * 0.5) * 10)
		particle:SetDieTime(math.Rand(0.25, 0.5))
		particle:SetStartAlpha(math.random(10,50))
		particle:SetStartSize(math.Rand(5, 10))
		particle:SetEndSize(50)
		particle:SetAirResistance(1)
		particle:SetVelocityScale(true)
		particle:SetCollide(true)
				
	emitter:Finish()
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()
	return false
end