Config = {}

Config.Resource = GetCurrentResourceName()

-- Compare the version of this resource to the latest
Config.CheckVersion = true

-- The Printer Entity
Config.EntityName = "hei_prop_hei_cash_trolly_01"

-- Gangs That Are able to print
Config.GangNames = {
	"cardealer",
	"gangi"
}

-- Require To be a Gang Member
Config.GangRequire = true

-- Require Online Police
Config.ActivePolice = false
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
	{745.15,-926.02,25.02, 185.5}
}
-- Money Spawn Coords
Config.MoneySpawnZone = {
	{745.15,-926.02,25.02, 185.5}
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