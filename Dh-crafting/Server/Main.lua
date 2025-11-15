local QBCore = exports[Config.Core]:GetCoreObject()
local PickUpsTable = {}





-- Stash Items
local function GetStashItems(stashId)
    local items = {}
    local result = MySQL.scalar.await('SELECT items FROM stashitems WHERE stash = ?', { stashId })
    if not result then return items end

    local stashItems = json.decode(result)
    if not stashItems then return items end

    for _, item in pairs(stashItems) do
        local itemInfo = QBCore.Shared.Items[item.name:lower()]
        if itemInfo then
            items[item.slot] = {
                name = itemInfo["name"],
                amount = tonumber(item.amount),
                info = item.info or "",
                label = itemInfo["label"],
                description = itemInfo["description"] or "",
                weight = itemInfo["weight"],
                type = itemInfo["type"],
                unique = itemInfo["unique"],
                useable = itemInfo["useable"],
                image = itemInfo["image"],
                created = item.created,
                slot = item.slot,
            }
        end
    end
    return items
end

local function SaveStashItems(stashId, items)
    for _, item in pairs(items) do
        item.description = nil
    end

    MySQL.insert('INSERT INTO stashitems (stash, items) VALUES (:stash, :items) ON DUPLICATE KEY UPDATE items = :items',
        {
            ['stash'] = stashId,
            ['items'] = json.encode(items)
        })
end



QBCore.Functions.CreateCallback('Dahm:Craft:CheckItems', function(source, cb, Reqitems, Item, InvStash , Levelk)



    local src = source
    local hasItems = false
    local idk = 0
    local Table = {}
    local player = QBCore.Functions.GetPlayer(source)
    for k, v in pairs(GetStashItems(InvStash)) do
        if Config.ItemsCrafting.items[Item].NeedItems[v.name] ~= nil and  v.amount >= Config.ItemsCrafting.items[Item].NeedItems[v.name] then
            idk = idk + 1
            Table[v.slot] = {
                slot = v.slot,
                amount = v.amount,
                name = v.name
            }
        end
    end
    if idk == #Reqitems then
        print("dahm")
        cb(true , Table , InvStash , Levelk)
    end
end)




RegisterNetEvent('Dahm:Craft:Start', function(Item, LevelUP, SlotRemove, InvStash, LevelK)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local stashItems = GetStashItems(InvStash)
    Player.Functions.AddItem(Item, Config.ItemsCrafting.items[Item].amount)
    TriggerClientEvent('inventory:client:ItemBox', QBCore.Shared.Items[Item], 'add',
        Config.ItemsCrafting.items[Item].amount)
    print(LevelK)
    MySQL.query('SELECT * FROM `dahm_craft` WHERE Id = ?', {LevelK}, function(response)
        if response then
            -- cb(response)
            MySQL.update('UPDATE `dahm_craft` SET level = ? WHERE Id = ?', {
                response[1].level + LevelUP, LevelK
            }, function(affectedRows)
                print(affectedRows)
            end)
            -- print(response[1].level)
        end
    end)


    -- Player.Functions.SetMetaData("craftinglevel", Player.PlayerData.metadata["craftinglevel"] + LevelUP)
    for k,v in pairs(SlotRemove) do
        if stashItems[v.slot] then
            stashItems[v.slot].amount -= Config.ItemsCrafting.items[Item].NeedItems[v.name]
            SaveStashItems(InvStash, stashItems)
        end
    end

    print(SlotRemove)
end)



-- Json Code
-- RegisterNetEvent('Dahm:Server:CraftPostion', function(postion , ID)
--     local JsonCode = json.decode(LoadResourceFile(GetCurrentResourceName(), "CraftPostions.json"))
--     local src = source
--     local playerData = QBCore.Functions.GetPlayer(src)
--     JsonCode[#JsonCode+1] = {
--         coords = postion,
--         Inv = "Craft_".. ID  .."",
--         Cid = ID
--     }
--     SaveResourceFile(GetCurrentResourceName(), "CraftPostions.json", json.encode(JsonCode), -1)
--     TriggerClientEvent('Dahm:Client:Craft:Spawn', -1)
-- end)




-- MySQL Code Test
RegisterNetEvent('Dahm:Server:CraftPostion', function(postion, Id, Inv)
   
    if Id and Inv then
        MySQL.update('UPDATE `dahm_craft` SET x = ? , y = ? , z = ? WHERE Id = ?', {
            postion.x, postion.y, postion.z, Id
        }, function(affectedRows)
            print(affectedRows)
        end)
    else
        MySQL.Async.insert(
            'INSERT INTO `dahm_craft` (x , y , z, pickup , level) VALUES (@x , @y , @z , @pickup , @level)', {
                ['@x'] = postion.x,
                ['@y'] = postion.y,
                ['@z'] = postion.z,
                ['@pickup'] = 0,
                ['@level'] = 0
            })
    end

    TriggerClientEvent('Dahm:Client:Craft:Spawn', -1)
end)



QBCore.Functions.CreateCallback('Dahm:Get:Json:Code', function(source, cb, args)
    -- local JsonCode = json.decode(LoadResourceFile(GetCurrentResourceName(), "CraftPostions.json"))
    -- cb(JsonCode)
    MySQL.query('SELECT * FROM `dahm_craft`', {}, function(response)
        if response then
            for k,v in pairs(response) do
                PickUpsTable[v.id] = {
                    pickup = false
                }
            end
            cb(response)
        end
    end)
end)


RegisterNetEvent('Dahm:Craft:PickUp', function(Inv, ID)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
   print(PickUpsTable[ID].pickup)
    MySQL.update('UPDATE `dahm_craft` SET x = 0 , y = 0 , z = 0 WHERE id = ?', {
        ID
    }, function(affectedRows)
        print(affectedRows)
    end)
    Player.Functions.AddItem('crafttable', 1, false, {
        Id = ID,
        Inv = Inv
    })
    TriggerClientEvent('Dahm:Client:Craft:Spawn', -1)
end)
RegisterNetEvent('Dahm:Remove:Interact:ID', function(ID)
    TriggerClientEvent('Dahm:Remove:interact:clieent', -1 , ID)
   
end)


QBCore.Functions.CreateUseableItem('crafttable', function(source, Item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent('Dahm:Craft:Spawn:Item', source, Item.info.Id, Item.info.Inv)
    Player.Functions.RemoveItem('crafttable', 1)
end)
QBCore.Functions.CreateCallback('Dahm:Craft:Get:Level',function(source,cb,args) 
    MySQL.query('SELECT * FROM `dahm_craft` WHERE id = ?', {args}, function(response)
        if response then
            cb(response[1].level)
        end
    end)
end)



QBCore.Commands.Add('giveleveltable', 'Give Level', {}, false, function(source, args)
    MySQL.update('UPDATE `dahm_craft` SET level = ? WHERE id = ?', {
        args[1], args[2]
    }, function(affectedRows)
        print(affectedRows)
    end)
end, 'god')