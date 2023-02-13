local MOD_VERSION = 1.0

function generator.roll_perks( self, tier )
	local data
	if self.data and self.data.perk then
		data = self.data.perk
	end
	if not data then
		nova.warning( "generator.roll_perks - no perk data present in \""..world:get_id( self ).."\"!" )
		return
	end
	local reserved = data.reserve or 0
	local custom   = data.custom
	local exotic   = false
	if data.exotic then
		self.data.exotic = true
		exotic           = true
		custom           = custom or data.exotic
		reserved         = data.reserve or 1
	else
		self.data.adv = true
	end

	tier = tier or 1
	if not exotic then
		self.text.prefix = "AV"..tostring(tier)
	end
	local mod     = table.copy( data.mod or {} )
	if type( custom ) == "string" then
		generator.add_perk( self, custom )
		mod[custom] = 0
	end
	if tier - reserved <= 0 then return end
	if tier < 2 then
		if math.random_pick({false, true}) then
			generator.roll_perk( self, 1, mod )
		end
		generator.roll_perk( self, 1, mod )
	elseif tier == 2 then
		if math.random_pick({false, true}) then
			generator.roll_perk( self, 1, mod )
		end	
		generator.roll_perk( self, 1, mod )
		if reserved <= 0 then
			if math.random_pick({false, true}) then
				generator.roll_perk( self, 1, mod )
			end	
			generator.roll_perk( self, 1, mod )
		end
	else
		if math.random_pick({false, true}) then
			generator.roll_perk( self, 2, mod )
		end		
		generator.roll_perk( self, 2, mod )
		if reserved <= 0 then
			if math.random_pick({false, true}) then
				generator.roll_perk( self, 1, mod )
			end	
			generator.roll_perk( self, 1, mod )
		end
	end

	if not exotic then
		if self.attributes then
			local capacity = self.attributes.mod_capacity
			if capacity then
				if tier > 1 then
					capacity = capacity - 2
				else
					capacity = capacity - 1
				end
				self.attributes.mod_capacity = capacity
			end
		end
	end
end

nova.log("PERKMADNESS "..tostring(MOD_VERSION).." loaded")
