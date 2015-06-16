colour = Color(100,255,0)

IKactive = function(args,player)
	local found = 0
	local target = args[2]
	local mode = args[3]
	if mode == 0 then
		for vehicle in Server:GetVehicles() do
			if vehicle:GetPosition():Distance(player:GetPosition()) < 25 then
				if vehicle ~= player:GetVehicle() then --if they are not in the vehicle
					if vehicle:GetHealth() ~= 0 then
						vehicle:SetHealth(0)
						found = found + 1
					end
				end
			end
		end
		if found == 0 then
			player:SendChatMessage("No vehicles found!", Color(255,0,0))
		elseif found == 1 then
			player:SendChatMessage("Destroyed 1 vehicle!", colour)
		else
			player:SendChatMessage("Destroyed " .. found .. " vehicles!", colour)
		end
	elseif mode == 1 then
		if not player:InVehicle() then
			if player:GetAimTarget().vehicle ~= nil then
				if target:GetHealth() ~= 0 then
					player:GetAimTarget().vehicle:SetHealth(0)
					player:SendChatMessage("Target eliminated.", colour)
				else
					player:SendChatMessage("Target has 0 health, no target selected.", Color(255,0,0))
				end
			else
				player:SendChatMessage("No target selected.", Color(255,0,0))
			end
		else
			player:SendChatMessage("Target cannot be selected while in a vehicle.", Color(255,0,0))
		end
	elseif mode == 2 then
		if target ~= nil then
			if target:GetHealth() ~= 0 then
				target:SetHealth(0)
				player:SendChatMessage(target:GetName() .. " eliminated.", colour)
			else
				player:SendChatMessage("Target has 0 health, no target selected.", Color(255,0,0))
			end
		else
			player:SendChatMessage("No target selected.", Color(255,0,0))
		end
	else
		print("Critical: Mode out of alignment.")
	end
end
Network:Subscribe("Instakill", IKactive)