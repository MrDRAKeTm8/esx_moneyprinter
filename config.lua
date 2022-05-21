Config = {}

Config.Resource = GetCurrentResourceName()

-- Compare the version of this resource to the latest
Config.CheckVersion = true

-- The Printer Entity
Config.EntityName = ""

-- Gangs That Are able to print
Config.GangNames = {
	"test",
	"gangi"
}

-- Require To be a Gang Member
Config.GangRequire = true

-- Require Online Police
Config.ActivePolice = true
Config.MinimumPolice = 3

-- Money Type(s) and Amounts to get each time
Config.BlackMoney = true
Config.BlackMoneyAmount = 3000
Config.WhiteMoney = false
Config.WhiteMoneyAmount = 3000

-- Time for each stash spawn in minutes
Config.StashTimer = 5

-- Printer Coords
Config.Printer = {
	{-2070.0031738281,-1019.9599804688,5.8841547966003, 1.00}
}
-- Money Spawn Coords
Config.MoneySpawnZone = {
	{-2070.0031738281,-1019.9599804688,5.8841547966003, 1.00}
}

--[[ usage
	if x then
		Citizen.CreateThread(function()
			for _, y in pairs(Config.Printers) do
				CreateBlip(y)
			end
		end)
	end

--]]