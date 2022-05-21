local ESX 				= nil
local EnougthCops = false
local sTimer = Config.StashTimer * 60
local fStart = false
local StopBool = false
local StashSpawned = false
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function GetCops()
	local Players = ESX.GetPlayers()
	policeOnline = 0
	for i = 1, #Players do
		local xPlayer = ESX.GetPlayerFromId(Players[i])
		if xPlayer["job"]["name"] == "police" then
			policeOnline = policeOnline + 1
		end
	end
	if policeOnline >= Config.MinimumPolice = 3 then
		EnougthCops = true
	else
		EnougthCops = false
	end
end


function StartStashing()
    Citizen.CreateThread(function()
        while StopBool == false do
            Citizen.Wait(StashTimer * 10000)
            if StopBool == false then
                StashSpawned = true
                waitingStash()
            end
        end
    end)
end

function waitingStash()
    Citizen.CreateThread(function()
        if StashSpawned == true then
              Citizen.Wait(2500)
                waitingStash()
                break;
        end
        if StashSpawned == false then
           TriggerEvent("esx_moneyprinter:stash")
            break;
        end
    end)
end



RegisterServerEvent('esx_moneyprinter:start')
AddEventHandler('esx_moneyprinter:start', function(ZoneOccupied, StashSpawnTimer, cords)
    local xPlayer = ESX.GetPlayerFromId(source)
    local coords = cords
    GetCops()
    if ZoneOccupied == false and StashSpawnTimer == sTimer and GetDistanceBetweenCoords(coords.x, coords.y, coords.z, Config.Printer[1], Config.Printer[2], Config.Printer[3], true) <= 5.5 and EnougthCops == true then
        StartStashing()
    end
end)


RegisterServerEvent('esx_moneyprinter:resetstash')
AddEventHandler('esx_moneyprinter:start', function()
    StashSpawned == false
end)

RegisterServerEvent('esx_moneyprinter:stop')
AddEventHandler('esx_moneyprinter:stop', function()
        StopBool = true
end)