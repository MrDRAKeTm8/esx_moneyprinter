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

-- require item "ink"
Config.ItemRequire = false


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

-- Time for each stash spawn in seconds
Config.StashTimer = 100
