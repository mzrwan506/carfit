Config = Config or {}

-- Inventory & Core
Config.Inv = "Rc2-inventory"
Config.Core = "qb-core"
Config.Object = 'prop_tool_bench02'

-- Items Crafting Configuration
Config.ItemsCrafting = {
    items = {
        ["lockpick"] = {
            itemName = "lockpick",
            label = "Lockpick",
            level = 0,
            levelUp = 100,
            Timer = 3000,
            price = 50,
            image = "lockpick.png",
            NeedItems = {
                ['refined_steel'] = 1,
                ['refined_aluminium'] = 1,
            },
        },
        ["breaker"] = {
            itemName = "breaker",
            label = "Breaker",
            level = 15,
            levelUp = 1,
            Timer = 3000,
            price = 50,
            NeedItems = {
                ['refined_steel'] = 1,
                ['refined_aluminium'] = 1,
            },
        },
        ["nylonrope"] = {
            itemName = "nylonrope",
            label = "Nylon Rope",
            level = 15,
            levelUp = 1,
            Timer = 3000,
            price = 50,
            NeedItems = {
                ['refined_plastic'] = 2,
                ['refined_aluminium'] = 1,
            },
        },
        ["repairkit"] = {
            itemName = "repairkit",
            label = "Repairkit",
            level = 25,
            levelUp = 1,
            Timer = 3000,
            price = 50,
            amount = 1,
            NeedItems = {
                ['refined_scrap'] = 1,
            },
        },
        ["ziptie"] = {
            itemName = "ziptie",
            label = "Ziptie",
            level = 10,
            levelUp = 1,
            Timer = 3000,
            price = 50,
            amount = 1,
            NeedItems = {
                ['refined_plastic'] = 1,
                ['refined_rubber'] = 1,
            },
        },
        ["hacking_device"] = {
            itemName = "hacking_device",
            label = "Software Device",
            level = 55,
            levelUp = 1,
            Timer = 3000,
            price = 200,
            NeedItems = {
                ['refined_plastic'] = 1,
                ['refined_aluminium'] = 1,
            },
        },
        ["electronickit"] = {
            itemName = "electronickit",
            label = "Electronickit",
            level = 55,
            levelUp = 1,
            Timer = 3000,
            price = 200,
            NeedItems = {
                ['refined_aluminium'] = 1,
                ['hacking_device'] = 1,
            },
        },
        ["armor"] = {
            itemName = "armor",
            label = "Body Armor",
            level = 75,
            levelUp = 3,
            Timer = 3000,
            price = 2500,
            NeedItems = {
                ['refined_plastic'] = 1,
                ['refined_rubber'] = 1,
            },
        },
        ["pistol_ammo"] = {
            itemName = "pistol_ammo",
            label = "Pistol Ammo",
            level = 120,
            levelUp = 2,
            Timer = 3000,
            price = 350,
            NeedItems = {
                ['refined_scrap'] = 1,
                ['refined_copper'] = 1,
            },
        },
        -- Weapons
        ["weapon_snspistol"] = {
            itemName = "weapon_snspistol",
            label = "SNS Pistol",
            level = 180,
            levelUp = 5,
            Timer = 3000,
            price = 0,
            NeedItems = {
                ['moneyroll'] = 3000,
                ['refined_scrap'] = 1,
                ['refined_copper'] = 1,
                ['refined_steel'] = 1,
                ['refined_aluminium'] = 1,
            },
        },
        ["weapon_vintagepistol"] = {
            itemName = "weapon_vintagepistol",
            label = "Vintage Pistol",
            level = 200,
            levelUp = 5,
            Timer = 3000,
            price = 0,
            NeedItems = {
                ['moneyroll'] = 3000,
                ['refined_scrap'] = 1,
                ['refined_copper'] = 1,
                ['refined_steel'] = 1,
                ['refined_aluminium'] = 1,
            },
        },
        ["weapon_pistol"] = {
            itemName = "weapon_pistol",
            label = "Pistol",
            level = 220,
            levelUp = 5,
            Timer = 3000,
            price = 0,
            NeedItems = {
                ['moneyroll'] = 7000,
                ['refined_scrap'] = 1,
                ['refined_copper'] = 1,
                ['refined_steel'] = 2,
                ['refined_aluminium'] = 2,
            },
        },
        ["weapon_pistol_mk2"] = {
            itemName = "weapon_pistol_mk2",
            label = "Mk2 Pistol",
            level = 300,
            levelUp = 5,
            Timer = 3000,
            price = 0,
            NeedItems = {
                ['moneyroll'] = 7000,
                ['refined_scrap'] = 1,
                ['refined_copper'] = 1,
                ['refined_steel'] = 2,
                ['refined_aluminium'] = 2,
            },
        },
        ["weapon_heavypistol"] = {
            itemName = "weapon_heavypistol",
            label = "Heavy Pistol",
            level = 375,
            levelUp = 3,
            Timer = 3000,
            price = 0,
            NeedItems = {
                ['moneyroll'] = 22000,
                ['refined_scrap'] = 3,
                ['refined_copper'] = 2,
                ['refined_steel'] = 3,
                ['refined_rubber'] = 4,
                ['refined_aluminium'] = 2,
            },
        },
    }
}
