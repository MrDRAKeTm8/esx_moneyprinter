local ESX 				= nil
local EnougthCops = false
local sTimer = Config.StashTimer * 60
local fStart = false
local StopBool = false
local StashSpawned = false
local starterID = 0
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)




function GetCops()
    if ActivePolice then
            local Players = ESX.GetPlayers()
            policeOnline = 0
            for i = 1, #Players do
                local xPlayer = ESX.GetPlayerFromId(Players[i])
                if xPlayer["job"]["name"] == "police" then
                    policeOnline = policeOnline + 1
                end
            end
            if policeOnline >= Config.MinimumPolice then
                EnougthCops = true
            else
                EnougthCops = false
            end
        else
            EnougthCops = true
            print("no need police")
    end
end


function StartStashing()
    Citizen.CreateThread(function()
        while StopBool == false do
            Citizen.Wait(Config.StashTimer * 1000)
            if StopBool == false then
                waitingStash()
            end
        end
    end)
end

function waitingStash()
    Citizen.CreateThread(function()
        if StashSpawned == true then
              Citizen.Wait(2500)
              print("there is a stash spawned")
                waitingStash()
        end
        if StashSpawned == false then
            print("spawning money")
            local player = ESX.GetPlayerFromId(starterID)
            TriggerClientEvent("esx_moneyprinter:stash", player)
            StashSpawned = true
        end
    end)
end





RegisterServerEvent('esx_moneyprinter:start')
AddEventHandler('esx_moneyprinter:start', function(ZoneOccupied, StashSpawnTimer, cords, sid)
    local xPlayer = ESX.GetPlayerFromId(source)
    local coords = cords
    GetCops()
    if ZoneOccupied == false and StashSpawnTimer == sTimer and EnougthCops then
        starterID = sid
        StartStashing()
    else
        print("cant/cops")
    end
end)


RegisterServerEvent('esx_moneyprinter:resetstash')
AddEventHandler('esx_moneyprinter:resetstash', function()
    StashSpawned = false
end)

RegisterServerEvent('esx_moneyprinter:stop')
AddEventHandler('esx_moneyprinter:stop', function()
        StopBool = true
end)