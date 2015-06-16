OPS = {"xairos"}

mode = 0
-- 0 for ranged
-- 1 for aim
-- 2 for lock on
target = nil
--this object will store our GetAimTarget()
validtarget = nil

IKChathook = function(args)
	text = args.text
	if text:lower() == "/ik mode" or text:lower() == "/ik mode " then
  		if mode == 0 then
			Chat:Print("Instakill is currently in ranged mode.", Color(0,255,215))
		elseif mode == 1 then
			Chat:Print("Instakill is currently in target mode.", Color(0,255,215))
		elseif mode == 2 then
			Chat:Print("Instakill is currently in lock-on mode.", Color(0,255,215))
		else
    		Chat:Print("Please report bug: Mode out of alignment.", Color(255,0,0))
  		end
  	elseif text:lower() == "/ik help" or text:lower() == "/ik" or text:lower() == "/ik " then
  		Chat:Print("XXXXXXXXXXXXXXXXXXXX  INSTAKILL  XXXXXXXXXXXXXXXXXXXXX", Color(0,255,215))
  		Chat:Print("", Color(0,255,215))
  		Chat:Print(" /ik mode [mode] - Displays currently selected mode if no operator given. Mode 0 is ranged, Mode 1 is targeted, and Mode 2 is lock-on.", Color(0,255,215))
  		Chat:Print(" /ik help - Displays this help page.", Color(0,255,215))
  		Chat:Print("", Color(0,255,215))
  		Chat:Print("XXXXXXXXXXXXXXXXXXXX  INSTAKILL  XXXXXXXXXXXXXXXXXXXXX", Color(0,255,215))
	elseif string.sub(text:lower(),1,4) == "/ik " then
		if string.sub(text:lower(),5,9) == "mode " then
			if string.sub(text:lower(),10) == "0" then
				mode = 0
				Chat:Print("Instakill set to ranged mode.", Color(0,255,215))
			elseif string.sub(text:lower(),10) == "1" then
				mode = 1
				Chat:Print("Instakill set to target mode.", Color(0,255,215))
			elseif string.sub(text:lower(),10) == "2" then
				mode = 2
				Chat:Print("Instakill set to lock-on mode.", Color(0,255,215))
			else
				Chat:Print("Mode not found, type '/ik help' for commands.", Color(255,0,0))
			end
		else
			Chat:Print("Instakill command not found, type '/ik help' for commands.", Color(255,0,0))
		end
	end
end

Events:Subscribe("LocalPlayerChat", IKChathook)

function IKKeyhook(args)
	if args.key == string.byte('M') then
		local found = false
		for index, value in pairs(OPS) do
			if value == LocalPlayer:GetName():lower() then
				data = {args, target, mode}
				Network:Send("Instakill", data)
				found = true
				break
			end
		end
		if not found then
			Chat:Print("You do not have permission to use this command.", Color(255,0,0))
		end
	elseif args.key == string.byte('N') then
		local found = false
		for index, value in pairs(OPS) do
			if value == LocalPlayer:GetName():lower() then
				found = true
				if mode ~= 2 then
					mode = 2
					Chat:Print("Mode switched to lock-on.", Color(0,255,215))
				end
				if not LocalPlayer:InVehicle() then
					validtarget = LocalPlayer:GetAimTarget()
					target = LocalPlayer:GetAimTarget().vehicle
					if target ~= nil then
						if target:GetHealth() ~= 0 then
							Chat:Print("Target locked on " .. target:GetName() .. ".", Color(0,255,215))
						else
							Chat:Print("Target has 0 health, no target selected.", Color(255,0,0))
						end
					else
						Chat:Print("No target selected.", Color(255,0,0))
					end
				else
					Chat:Print("Target cannot be selected while in a vehicle.", Color(255,0,0))
				end
				break
			end
		end
		if not found then
			Chat:Print("You do not have permission to use this command.", Color(255,0,0))
		end
	end
end

Events:Subscribe("KeyUp", IKKeyhook)