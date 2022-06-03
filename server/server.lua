local ESX 				= nil
local EnougthCops = false
--local sTimer = Config.StashTimer * 60
local sTimer = 25
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
            TriggerClientEvent("esx_moneyprinter:setzone", -1)
            Citizen.Wait(Config.StashTimer * 1000)
            if StopBool == false then
            TriggerClientEvent("esx_moneyprinter:stash", -1)
            end
    end)
end

function RewardBcash(xplayerr)
    if Config.BlackMoney then
    xplayerr.addAccountMoney('black_money', Config.BlackMoneyAmount)
    end
    if Config.WhiteMoney then
        xplayerr.addAccountMoney('money', Config.WhiteMoneyAmount)
    end
end


RegisterServerEvent('esx_moneyprinter:done')
AddEventHandler('esx_moneyprinter:done', function(ZoneOccupied, StashSpawnTimer, sid)
    local xPlayer = ESX.GetPlayerFromId(source)
    --local coords = cords
    GetCops()
    if ZoneOccupied == true and StashSpawnTimer == 0 and sid==starterID then
        RewardBcash(xPlayer)
    else
        print("cant")
    end
end)


RegisterServerEvent('esx_moneyprinter:start')
AddEventHandler('esx_moneyprinter:start', function(ZoneOccupied, StashSpawnTimer, cords, sid)
    local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source
    local coords = cords
    GetCops()
    if ZoneOccupied == false and EnougthCops then
        starterID = sid
        print("starting")
        StopBool = false
        StartStashing(starterID)
        TriggerClientEvent("esx_moneyprinter:playerhud", _source)
    else
        print("cant/cops")
    end
end)

-- make another stash spawnable
RegisterServerEvent('esx_moneyprinter:resetstash')
AddEventHandler('esx_moneyprinter:resetstash', function()
    StashSpawned = false
end)

RegisterServerEvent('esx_moneyprinter:stop')
AddEventHandler('esx_moneyprinter:stop', function()
    print("stopping")
     sTimer = 25
     fStart = false
     StopBool = true
     StashSpawned = false
     starterID = 0
     TriggerClientEvent("esx_moneyprinter:reset", -1)
end)