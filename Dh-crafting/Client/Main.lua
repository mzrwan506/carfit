local QBCore = exports[Config.Core]:GetCoreObject()




RegisterNetEvent('Dahm:Craft:Inspect', function(args, levelTEST, K)
    local PlayerData = QBCore.Functions.GetPlayerData()
    print(PlayerData.metadata.craftinglevel)
    QBCore.Functions.TriggerCallback('Dahm:Craft:Get:Level', function(Level)
        SendNUIMessage({
            Action = "OpenCraft",
            LevelPlayer = Level,
            ItemsCrafts = Config.ItemsCrafting.items,
            Inv = Config.Inv,
            args = args,
            K = K
        })
        SetNuiFocus(true, true)
    end, K)
end)
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerEvent('Dahm:Client:Craft:Spawn')
end)


RegisterNUICallback('GetReqItem', function(data, cb)
    local Table = {}
    for k, v in pairs(Config.ItemsCrafting.items[data.Item].NeedItems) do
        Table[#Table + 1] = {
            Item = k,
            Label = QBCore.Shared.Items[k].label,
            Amount = v
        }
    end
    cb(Table)
end)
function CloseCraft()
    SendNUIMessage({
        Action = "CloseCraft"
    })
    SetNuiFocus(false, false)
end

RegisterNUICallback('CloseCraft', function(data, cb)
    CloseCraft()
end)
RegisterNUICallback('StartCraft', function(data, cb)
    local playerData = QBCore.Functions.GetPlayerData()

    QBCore.Functions.TriggerCallback('Dahm:Craft:CheckItems', function(Success, Table, InvStash, Levelk)
        if Success then
            -- متغير لتتبع إذا اللاعب أوقف العملية
            local playerCancelled = false

            QBCore.Functions.Progressbar('dahm_craft_aboqhat', 'Craft ' .. data.SelectItem,
                Config.ItemsCrafting.items[data.SelectItem].Timer, false, true,
                {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = 'mini@repair',
                    anim = 'fixing_a_ped',
                }, {}, {}, function() -- Play When Done
                    CloseCraft()
                    TriggerServerEvent('Dahm:Craft:Start', data.SelectItem, Config.ItemsCrafting.items[data.SelectItem].levelUp, Table, InvStash, Levelk)
                    QBCore.Functions.Notify("You Craft " .. data.SelectItem, "primary")
                end, function(cancelled) -- Play When Cancel
                    CloseCraft()
                    playerCancelled = cancelled -- true إذا اللاعب أوقف العملية
                    if playerCancelled then
                        QBCore.Functions.Notify("You Cancel ....", "error")
                    end
                end
            )
        else
            CloseCraft()
            QBCore.Functions.Notify("You Don't Have Requirments", "error")
        end
    end, data.ReqItems, data.SelectItem, data.InvStash, data.K)
end)


-- RegisterCommand('commandName', function()
--     TriggerEvent('inventory:client:SetCurrentStash', 'dahm')
--     TriggerServerEvent('inventory:server:OpenInventory', 'stash', 'dahm')
-- end)

CraftObjects = {}
InvObjects = {}
InteractObjects = {}




function RemoveSpawnCraft()
    QBCore.Functions.TriggerCallback('Dahm:Get:Json:Code', function(Json)
        for k, v in pairs(Json) do
            DeleteEntity(CraftObjects[v.id])
            exports.interact:RemoveInteraction(InteractObjects[v.id])
            if CraftObjects[v.id] then
                CraftObjects[v.id] = nil
            end
            if InvObjects[v.id] then
                InvObjects[v.id] = nil
            end
            if InteractObjects[v.id] then
                InteractObjects[v.id] = nil
            end
  
        end
    end)
end

RegisterNetEvent('Dahm:Client:Craft:Spawn', function(args)
    RemoveSpawnCraft()
    Wait(200)
    local model = Config.Object
    local playerData = QBCore.Functions.GetPlayerData()
    QBCore.Functions.LoadModel(model)
    QBCore.Functions.TriggerCallback('Dahm:Get:Json:Code', function(Json)
        for k, v in pairs(Json) do
            CraftObjects[v.id] = CreateObject(model, tonumber(v.x), tonumber(v.y), tonumber(v.z), false, false, false)
            InvObjects[v.id] = "Craft_" .. v.id
            FreezeEntityPosition(CraftObjects[v.id], true)
            InteractObjects[v.id] = exports.interact:AddInteraction({
                coords = GetEntityCoords(CraftObjects[v.id]),
                distance = 5.0,
                interactDst = 4.0,
                options = {
                    {
                        label = 'Inspect',
                        action = function(entity, coords, args)
                            TriggerEvent('Dahm:Craft:Inspect', InvObjects[v.id], v.level, v.id)
                        end,
                    },
                    {
                        label = 'Open WorkBench Stash',
                        action = function()
                            -- if playerData.citizenid == v.Cid then
                            TriggerEvent('inventory:client:SetCurrentStash', InvObjects[v.id])
                            TriggerServerEvent('inventory:server:OpenInventory', 'stash', InvObjects[v.id])
                            -- else
                            -- QBCore.Functions.Notify("You don't Have Access This Table", "error", 5000)
                            -- end
                        end,
                    },
                    {
                        label = 'PickUp',
                        action = function(entity, coords, args)
                            -- exports.interact:RemoveInteraction(InteractObjects[v.id])
                            TriggerServerEvent('Dahm:Remove:Interact:ID', v.id)
                            -- Wait(2000)
                            QBCore.Functions.Progressbar('pickup_table', 'PickUp Craft Table', math.random(25000, 30000),
                                false, true,
                                {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = 'mini@repair',
                                    anim = 'fixing_a_ped',
                                }, {}, {}, function()
                                    -- DeleteEntity(CraftObjects[v.id])
                                    exports.interact:RemoveInteraction(InteractObjects[v.id])
                                    TriggerServerEvent('Dahm:Craft:PickUp', InvObjects[v.id], v.id)
                                end, function()
                                    QBCore.Functions.Notify('You Canceled .....', "error", 5000)
                                end)
                        end,
                    },
                }
            })
        end
    end)
end)


-- RegisterNetEvent('Dahm:Remove:interact:clieent', function(data)
--     exports.interact:RemoveInteraction(InteractObjects[data])
-- end)


-- RegisterCommand('dahmcraft', function()
--     local playerPed = PlayerPedId()
--     local model = Config.Object
--     RequestModel(model)
--     while not HasModelLoaded(model) do
--         Wait(0)
--     end
--     currentObject = CreateObject(model, GetEntityCoords(PlayerPedId()), true, false, false)
--     local objectPositionData = exports.object_gizmo:useGizmo(currentObject)
--     TriggerServerEvent('Dahm:Server:CraftPostion', objectPositionData.position)
--     DeleteObject(currentObject)
-- end)



RegisterNetEvent('Dahm:Craft:Spawn:Item', function(Id, Inv)
    local playerPed = PlayerPedId()
    if Id then
        -- local model = Config.Object
        -- QBCore.Functions.LoadModel(model)
        -- currentObject = CreateObject(model, GetEntityCoords(PlayerPedId()), true, false, false)
        -- local objectPositionData = exports.object_gizmo:useGizmo(currentObject)
        -- TriggerServerEvent('Dahm:Server:CraftPostion', objectPositionData.position , Id , Inv)
        -- DeleteObject(currentObject)


        local model = Config.Object
        local offset = GetEntityCoords(PlayerPedId()) + GetEntityForwardVector(PlayerPedId()) * 3
        QBCore.Functions.LoadModel(model)
        urrentObject = CreateObject(model, offset.x, offset.y, offset.z, false, false, false)
        local data = exports.object_gizmo:useGizmo(urrentObject)
        TriggerServerEvent('Dahm:Server:CraftPostion', data.position, Id, Inv)
        DeleteObject(urrentObject)
    else
        local offset = GetEntityCoords(PlayerPedId()) + GetEntityForwardVector(PlayerPedId()) * 3
        local model = Config.Object
        QBCore.Functions.LoadModel(model)

        -- local model = Config.Object
        urrentObject = CreateObject(model, offset.x, offset.y, offset.z, false, false, false)

        -- QBCore.Functions.LoadModel(model)
        -- currentObject = CreateObject(model, GetEntityCoords(PlayerPedId()), true, false, false)
        local objectPositionData = exports.object_gizmo:useGizmo(urrentObject)
        -- TriggerServerEvent('Dahm:Server:CraftPostion', objectPositionData.position )
        -- DeleteObject(currentObject)
        TriggerServerEvent('Dahm:Server:CraftPostion', objectPositionData.position)
        DeleteObject(urrentObject)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        TriggerEvent('Dahm:Client:Craft:Delete')
    end
end)
AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        TriggerEvent('Dahm:Client:Craft:Spawn')
    end
end)
-- TriggerEvent('Dahm:Client:Craft:Spawn')
