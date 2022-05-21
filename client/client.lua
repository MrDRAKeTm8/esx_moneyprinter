--[[
   ____    ____    U _____ u    _       _____  U _____ u ____          ____   __   __      __  __     ____     ____    ____        _       _  __  U _____ u  _____   __  __    ___     
U /"___|U |  _"\ u \| ___"|/U  /"\  u  |_ " _| \| ___"|/|  _"\      U | __")u \ \ / /    U|' \/ '|uU |  _"\ u |  _"\U |  _"\ u U  /"\  u  |"|/ /  \| ___"|/ |_ " _|U|' \/ '|uU( " ) u  
\| | u   \| |_) |/  |  _|"   \/ _ \/     | |    |  _|" /| | | |      \|  _ \/  \ V /     \| |\/| |/ \| |_) |//| | | |\| |_) |/  \/ _ \/   | ' /    |  _|"     | |  \| |\/| |/\/   \/   
 | |/__   |  _ <    | |___   / ___ \    /| |\   | |___ U| |_| |\      | |_) | U_|"|_u     | |  | |   |  _ <  U| |_| |\|  _ <    / ___ \ U/| . \\u  | |___    /| |\  | |  | | | ( ) |   
  \____|  |_| \_\   |_____| /_/   \_\  u |_|U   |_____| |____/ u      |____/    |_|       |_|  |_|   |_| \_\  |____/ u|_| \_\  /_/   \_\  |_|\_\   |_____|  u |_|U  |_|  |_|  \___/>>  
 _// \\   //   \\_  <<   >>  \\    >>  _// \\_  <<   >>  |||_        _|| \\_.-,//|(_     <<,-,,-.    //   \\_  |||_   //   \\_  \\    >>,-,>> \\,-.<<   >>  _// \\_<<,-,,-.    )( (__) 
(__)(__) (__)  (__)(__) (__)(__)  (__)(__) (__)(__) (__)(__)_)      (__) (__)\_) (__)     (./  \.)  (__)  (__)(__)_) (__)  (__)(__)  (__)\.)   (_/(__) (__)(__) (__)(./  \.)  (__)     

--]]



ESX 						= nil
local PlayerData            = {}
local AbleToStart = false
local ZoneOccupied = false
local StashSpawnTimer = Config.StashTimer * 60
local StashAvailable = false


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx_moneyprinter:reset')
AddEventHandler('esx_moneyprinter:reset', function()
	ZoneOccupied = false
    local StashSpawnTimer = Config.StashTimer * 60
end)

RegisterNetEvent('esx_moneyprinter:setzone')
AddEventHandler('esx_moneyprinter:setzone', function()
	ZoneOccupied = true
end)

--ServerEvent('esx_moneyprinter:resetstash')
RegisterNetEvent('esx_moneyprinter:stash')
AddEventHandler('esx_moneyprinter:stash', function()
    SpawnMoneyStash()
end)


if Config.GangRequire == false then
    AbleToStart = true
end

-- job check
if Config.GangRequire == true then

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(10000)
            jobname = ESX.PlayerData.job.name
            if ESX.PlayerData.job then
                
                for _, y in pairs(Config.GangNames) do
                    if jobname == y then
                        AbleToStart = true
                    end
                end


            end
    end)

end


-- Zone and Marker Create

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped,true)
			if ZoneOccupied == false then
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, Config.Printer[1], Config.Printer[2], Config.Printer[3], true) <= 5.5 then
					if AbleToStart then
						DrawText3Ds(Config.Printer[1], Config.Printer[2], Config.Printer[3], "Press ~g~[E]~s~ to ~y~Hack~s~")
					end
				end
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, Config.Printer[1], Config.Printer[2], Config.Printer[3], true) <= 5.5 then
					if IsControlJustPressed(0,38) and AbleToStart then
                        exports['mythic_notify']:SendAlert('inform', 'Dont Exit The Red Circle Zone', 5000, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
						TriggerServerEvent("esx_moneyprinter:start", ZoneOccupied, StashSpawnTimer, coords)
						break;
					end
				end
			end
    end
end)

-- Stash Pickup

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
            if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, Config.MoneySpawnZone[1], Config.MoneySpawnZone[2], Config.MoneySpawnZone[3], true) <= 5.5 and StashAvailable == true then
                DrawText3Ds(Config.Printer[1], Config.Printer[2], Config.Printer[3], "Press ~g~[E]~s~ to ~y~Pickup~s~")
            end
            if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, Config.MoneySpawnZone[1], Config.MoneySpawnZone[2], Config.MoneySpawnZone[3], true) <= 2.5 and StashAvailable == true then
                if IsControlJustPressed(0,38) then
                    exports['mythic_notify']:SendAlert('inform', 'Picking up', 5000, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
                    AnimatePickupStash()
                    TriggerServerEvent('esx_moneyprinter:resetstash')
                    break;
                end
            end

    end
end)



-- Occuipied Blip
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        if ZoneOccupied and Blip==nil then
            local Blip = AddBlipForRadius(Config.Printer[1], Config.Printer[2], Config.Printer[3], 100.0)

            SetBlipRoute(Blip, true)

            Citizen.CreateThread(function()
                while Blip do
                    SetBlipRouteColour(Blip, 1)
                    Citizen.Wait(150)
                    SetBlipRouteColour(Blip, 6)
                    Citizen.Wait(150)
                    SetBlipRouteColour(Blip, 35)
                    Citizen.Wait(150)
                    SetBlipRouteColour(Blip, 6)
                end
            end)

            SetBlipAlpha(Blip, 60)
            SetBlipColour(Blip, 1)
            SetBlipFlashes(Blip, true)
            SetBlipFlashInterval(Blip, 200)
        end

        --Citizen.Wait(Config.StashTimer * 10000)
        if ZoneOccupied == false then
        RemoveBlip(Blip)
        Blip = nil
        end
    end
end)


-- Start the timer reduce (progress bar)
Citizen.CreateThread(function()
    while ZoneOccupied do
        Citizen.Wait(1000)
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped,true)
        if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, Config.Printer[1], Config.Printer[2], Config.Printer[3], true) <= 5.5 and StashSpawnTimer ~= 0 then
            StashSpawnTimer = StashSpawnTimer - 1
            SendNUIMessage({
				update = true,
				time = StashSpawnTimer
			})

        end
        if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, Config.Printer[1], Config.Printer[2], Config.Printer[3], true) > 5.5 and StashSpawnTimer > 0 then
            TriggerEvent("esx_moneyprinter:reset")
            TriggerServerEvent('esx_moneyprinter:stop')
            exports['mythic_notify']:SendAlert('inform', 'You have exited the proccess, reseting!', 5000, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
        end
    end
end)


-- Start Animation
function AnimatePickupStash()
    local ped = GetPlayerPed(-1)
    TaskStartScenarioInPlace(ped, "MP_SNOWBALL", 0, true)
    Citizen.Wait(1500)
    TaskStartScenarioInPlace(ped, "MP_SNOWBALL", 0, true)
    Citizen.Wait(1500)
    TaskStartScenarioInPlace(ped, "MP_SNOWBALL", 0, true)
    ClearPedTasksImmediately(ped)
end


-- Spawn Function for printer
function SpawnPrinter()
	local printer = GetHashKey(Config.EntityName)
	RequestModel(printer)
	while not HasModelLoaded(printer) do
		Citizen.Wait(100)
	end
	local printerObject = CreateObject(printer, Config.Printer[1], Config.Printer[2], Config.Printer[3], true)
	SetEntityRotation(printerObject, 0.0, 0.0,  Config.Printer[4]+180.0)
	PlaceObjectOnGroundProperly(printerObject)
	SetEntityAsMissionEntity(printerObject, true, true)
	printerNetObj = ObjToNet(printerObject)
	SetModelAsNoLongerNeeded(printer)
end

-- Spawn Function for stash
function SpawnMoneyStash()
	local moneystash = GetHashKey(Config.EntityName)
	RequestModel(moneystash)
	while not HasModelLoaded(moneystash) do
		Citizen.Wait(100)
	end
	local printerObject = CreateObject(moneystash, Config.MoneySpawnZone[1], Config.MoneySpawnZone[2], Config.MoneySpawnZone[3], true)
	SetEntityRotation(printerObject, 0.0, 0.0,  Config.MoneySpawnZone[4]+180.0)
	PlaceObjectOnGroundProperly(printerObject)
	SetEntityAsMissionEntity(printerObject, true, true)
	printerNetObj = ObjToNet(printerObject)
	SetModelAsNoLongerNeeded(moneystash)
end


-- Function for 3D text:
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end