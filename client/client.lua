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
local AbleToStartCops = false
local ZoneOccupied = false
--local StashSpawnTimer = Config.StashTimer * 60
local StashSpawnTimer = 25
local StashAvailable = false
local ObjectG = nil
local Blip = nil
-- exec bools
local exec = false


local screenPosX = 0.165                    -- X coordinate (top left corner of HUD)
local screenPosY = 0.882                    -- Y coordinate (top left corner of HUD)
local locationColorText = {255, 255, 255}   -- Color used to display location and time

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
    clearobj()
     AbleToStart = false
     AbleToStartCops = false
     ZoneOccupied = false
   --  StashSpawnTimer = Config.StashTimer * 60
     StashSpawnTimer = 25
   
     StashAvailable = false
     ObjectG = nil
     RemoveBlip(Blip)
     Blip = nil
    -- exec bools
     exec = false
end)

RegisterNetEvent('esx_moneyprinter:setzone')
AddEventHandler('esx_moneyprinter:setzone', function()
    print("setting zone")
        ZoneOccupied = true   
        pickkk()
        CopsNotify()
end)

RegisterNetEvent('esx_moneyprinter:playerhud')
AddEventHandler('esx_moneyprinter:playerhud', function()
    Timer()
    jjhud()
end)

--ServerEvent('esx_moneyprinter:resetstash')
RegisterNetEvent('esx_moneyprinter:stash')
AddEventHandler('esx_moneyprinter:stash', function()
    Citizen.CreateThread(function()
        Citizen.Wait(StashSpawnTimer * 1000)
        if ZoneOccupied then
            SpawnMoneyStash()
        end
    end)

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
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, 761.12, -3193.95, 6.07, true) <= 5.5 then
					if AbleToStart then
						DrawText3Ds(761.13, -3193.19, 6.03, "Press ~g~[E]~s~ to ~y~Start~s~")
					end
				end
				if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, 761.13, -3193.19, 6.83, true) <= 2.5 then
					if IsControlJustPressed(0,38) and AbleToStart then
                        StashSpawnTimer = 25 -- temp fix i guess for 24 reduce problem
                       exports['mythic_notify']:DoHudText('inform', 'Dont Exit The Red Circle Zone', 5000, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
						--print("dont exit")
                        TriggerServerEvent("esx_moneyprinter:start", ZoneOccupied, StashSpawnTimer, coords, GetPlayerServerId(PlayerId()))
                        ZoneOccupied = true
					end
				end
			end
    end
end)

-- Stash Pickup
function pickkk()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            local ped = GetPlayerPed(-1)
            local coords = GetEntityCoords(ped,true)
            if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, 762.48, -3193.54, 6.07, true) <= 5.5 and StashSpawnTimer == 0 then
                DrawText3Ds(762.48, -3193.54, 6.07, "Press ~g~[E]~s~ to ~y~Pickup~s~")
            end
                if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, 762.48, -3193.54, 6.07, true) <= 1.5 and StashSpawnTimer == 0 then
                    if IsControlJustPressed(0,38) then
                   exports['progressBars']:startUI(10000, "Picking up")
                   -- print("picking up")
                   
                         AnimatePickupStash()
                        TriggerServerEvent('esx_moneyprinter:done', ZoneOccupied, StashSpawnTimer, GetPlayerServerId(PlayerId()))
                        TriggerServerEvent('esx_moneyprinter:stop')
                        break;
                    end
                end

        end
    end)
end

-- Occuipied Blip
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        if ZoneOccupied and Blip==nil then
             Blip = AddBlipForRadius(761.12, -3193.95, 6.07, 100.0)

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

-- Notify Cops
function CopsNotify()
    if ESX.GetPlayerData().job == "police" then

        ESX.ShowNotification("Somebody started fake money printing operation")  
    
        Citizen.CreateThread(function(...)
    
          local blipA = AddBlipForRadius(246.78, 218.70, 106.30, 100.0)
    
          SetBlipHighDetail(blipA, true)
    
          SetBlipColour(blipA, 1)
    
          SetBlipAlpha (blipA, 128)
    
    
    
          local blipB = AddBlipForCoord(246.78, 218.70, 106.30)
    
          SetBlipSprite               (blipB, 458)
    
          SetBlipDisplay              (blipB, 4)
    
          SetBlipScale                (blipB, 1.0)
    
          SetBlipColour               (blipB, 1)
    
          SetBlipAsShortRange         (blipB, true)
    
          SetBlipHighDetail           (blipB, true)
    
          BeginTextCommandSetBlipName ("STRING")
    
          AddTextComponentString      ("Printing In Progress")
    
          EndTextCommandSetBlipName   (blipB)
    
    
    
          local timer = GetGameTimer()
    
          while GetGameTimer() - timer < 30000 do
    
            Citizen.Wait(0)
    
          end
    
    
    
          RemoveBlip(blipA)
    
          RemoveBlip(blipB)
    
        end)
    
      end

end



-- Start the timer reduce (progress bar)
function Timer()
    Citizen.CreateThread(function()
        while ZoneOccupied do
            Citizen.Wait(1000)
            local ped = GetPlayerPed(-1)
            local coords = GetEntityCoords(ped,true)
            local dist = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, 761.12, -3193.95, 6.07, true)
            if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, 761.12, -3193.95, 6.07, true) < 160.5 and StashSpawnTimer ~= 0 then
                StashSpawnTimer = StashSpawnTimer - 1
               -- print("timer" ..StashSpawnTimer) 
               -- drawTxthud(dist, 4, locationColorText, 0.5, screenPosX, screenPosY + 0.075)
            end
            
            if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, 761.12, -3193.95, 6.07, true) > 160.5 and StashSpawnTimer > 0 then
                TriggerServerEvent('esx_moneyprinter:stop')
                exports['mythic_notify']:DoHudText('inform', 'You have exited the proccess, reseting!', 5000, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
                print("exited")
            end



        end
    end)

    Citizen.CreateThread(function()
            Citizen.Wait(StashSpawnTimer * 1000)
            if ZoneOccupied then
                exports['mythic_notify']:DoHudText('inform', 'Stash Is Ready', 5000, { ['background-color'] = '#ffffff', ['color'] = '#000000' })
            end
    end)

end

-- hud
function jjhud()
    print("jjhud exec")
    Citizen.CreateThread(function()
        while ZoneOccupied do
            Citizen.Wait(0)
            local ped = GetPlayerPed(-1)
            local coords = GetEntityCoords(ped,true)
            local dist = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, 761.12, -3193.95, 6.07, true)
            local distcel = math.ceil(dist)
            drawTxthud("Distance: " ..distcel, 4, locationColorText, 0.5, screenPosX, screenPosY + 0.075)
            drawTxthud("Time Left: " ..StashSpawnTimer, 4, locationColorText, 0.5, screenPosX, screenPosY + 0.055)
        end
    end)
end


-- Start Animation
function AnimatePickupStash()
    --print("animating")
    local plySkin
    TriggerEvent('skinchanger:getSkin', function(skin) plySkin = skin; end)
    local plyPed = GetPlayerPed(-1)

    SetEntityHeading(plyPed, ObjectG)
    if (plySkin["bags_1"] == 0 or plySkin["bags_2"] == 0) then
       -- TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
       TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerEvent('skinchanger:loadClothes', skin, {
            bags_1      = 44
        })
	    end)
    end

    ESX.Streaming.RequestAnimDict('mp_take_money_mg', function(...)

        TaskPlayAnim( plyPed, "mp_take_money_mg", "stand_cash_in_bag_loop", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )     

    end)
    Citizen.Wait(10000)
    ClearPedTasksImmediately(plyPed)
end


-- Spawn Function for stash
function SpawnMoneyStash()
	local moneystash = GetHashKey(Config.EntityName)
	RequestModel(moneystash)
	while not HasModelLoaded(moneystash) do
		Citizen.Wait(100)
	end
	local printerObject = CreateObject(moneystash, 762.48, -3193.54, 6.07, true)
    ObjectG = printerObject
	--SetEntityRotation(printerObject, 0.0, 0.0,  Config.MoneySpawnZone[4]+180.0)
    SetEntityRotation(printerObject, 0.0, 0.0, 180.0)
	PlaceObjectOnGroundProperly(printerObject)
	SetEntityAsMissionEntity(printerObject, true, true)
	printerNetObj = ObjToNet(printerObject)
	SetModelAsNoLongerNeeded(moneystash)
    StashAvailable = true
end


AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    if GetCurrentResourceName() == resourceName then
        clearobj()
    end
end)
  
function clearobj()
    if ObjectG ~= nil then
        DeleteObject(ObjectG)
    end
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

function drawTxthud(content, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(colour[1],colour[2],colour[3], 255)
    SetTextEntry("STRING")
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end