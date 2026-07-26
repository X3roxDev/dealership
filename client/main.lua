local isOpen = false
local shopPeds = {}
local displayVehicles = {}
local activeTestDrive = nil

local function notify(message, notifyType)
    if type(lib) == 'table' and type(lib.notify) == 'function' then
        lib.notify({
            title = Config.ShopTitle or 'Vehicle Shop',
            description = message,
            type = notifyType or 'inform'
        })
    elseif X3roxDev.FrameworkName == 'qb' and GetResourceState('qb-core') == 'started' then
        TriggerEvent('QBCore:Notify', message, notifyType or 'primary')
    elseif X3roxDev.FrameworkName == 'esx' then
        TriggerEvent('esx:showNotification', message)
    else
        BeginTextCommandThefeedPost('STRING')
        AddTextComponentSubstringPlayerName(message)
        EndTextCommandThefeedPostTicker(false, false)
    end
end

RegisterNetEvent('X3roxDev_vehicleshop:client:notify', notify)

local function loadModel(model, modelType)
    local hash = X3roxDev.HashModel(model)

    if not IsModelInCdimage(hash) then
        return nil
    end

    if modelType == 'vehicle' and not IsModelAVehicle(hash) then
        return nil
    end

    RequestModel(hash)

    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(hash) and GetGameTimer() < timeout do
        Wait(0)
    end

    if not HasModelLoaded(hash) then
        return nil
    end

    return hash
end

local function isSpawnClear(coords)
    if not Config.CheckSpawnClear then
        return true
    end

    return not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0)
end

local function setVehicleColor(vehicle, color)
    color = tonumber(color) or 0
    SetVehicleColours(vehicle, color, color)
    SetVehicleExtraColours(vehicle, color, color)
end

local function giveVehicleKeys(vehicle, plate)
    if GetResourceState('qb-vehiclekeys') == 'started' then
        TriggerEvent('vehiclekeys:client:SetOwner', plate)
    elseif GetResourceState('qbx_vehiclekeys') == 'started' then
        TriggerServerEvent('qbx_vehiclekeys:server:giveKeys', VehToNet(vehicle))
    end
end

local function spawnVehicle(model, coords, color, plate)
    local hash = loadModel(model, 'vehicle')

    if not hash then
        notify(('Invalid vehicle model: %s'):format(tostring(model)), 'error')
        return nil
    end

    if not isSpawnClear(coords) then
        notify(X3roxDev.Locale('spawn_blocked'), 'error')
        return nil
    end

    local vehicle = CreateVehicle(hash, coords.x, coords.y, coords.z, coords.w or 0.0, true, false)

    if not DoesEntityExist(vehicle) then
        return nil
    end

    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleOnGroundProperly(vehicle)
    SetVehicleDirtLevel(vehicle, 0.0)
    setVehicleColor(vehicle, color)

    if plate then
        SetVehicleNumberPlateText(vehicle, plate)
    end

    SetModelAsNoLongerNeeded(hash)
    return vehicle
end

local function closeShop()
    isOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

local function openShop()
    if isOpen then
        return
    end

    isOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open',
        vehicles = X3roxDev.BuildVehicleList(),
        currency = Config.Currency or '$',
        shopTitle = Config.ShopTitle or 'Dealership',
        shopSubtitle = Config.ShopSubtitle or '',
        locales = Lang and (Lang[Config.Locale] or Lang.en) or {},
        categoryLabels = Config.CategoryLabels or {}
    })
end

RegisterNetEvent('X3roxDev_vehicleshop:client:openShop', openShop)

RegisterNUICallback('close', function(_, cb)
    closeShop()
    cb({ success = true })
end)

RegisterNUICallback('buy', function(data, cb)
    if not data or not data.model then
        cb({ success = false })
        return
    end

    X3roxDev.TriggerServerCallback('X3roxDev_vehicleshop:buyVehicle', function(success, message, plate)
        if not success then
            notify(message or X3roxDev.Locale('not_enough_money'), 'error')
            cb({ success = false })
            return
        end

        closeShop()

        local dealership = Config.Dealerships and Config.Dealerships[1]
        local spawnPoint = dealership and dealership.spawnPoint or GetEntityCoords(PlayerPedId())
        local vehicle = spawnVehicle(data.model, spawnPoint, data.color, plate)

        if vehicle then
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            giveVehicleKeys(vehicle, plate)
        end

        notify(message or X3roxDev.Locale('vehicle_purchased'), 'success')
        cb({ success = true })
    end, data.model, data.paymentMethod or 'cash')
end)

RegisterNUICallback('testDrive', function(data, cb)
    if not Config.TestDrive or not Config.TestDrive.Enabled or not data or not data.model then
        cb({ success = false })
        return
    end

    X3roxDev.TriggerServerCallback('X3roxDev_vehicleshop:startTestDrive', function(success, message)
        if not success then
            notify(message or X3roxDev.Locale('not_enough_money'), 'error')
            cb({ success = false })
            return
        end

        closeShop()

        if activeTestDrive and DoesEntityExist(activeTestDrive.vehicle) then
            DeleteEntity(activeTestDrive.vehicle)
        end

        local vehicle = spawnVehicle(data.model, Config.TestDrive.SpawnPoint, 0, 'TESTDRV')

        if not vehicle then
            cb({ success = false })
            return
        end

        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        activeTestDrive = { vehicle = vehicle }
        notify(message or X3roxDev.Locale('test_drive_started', Config.TestDrive.Time or 60), 'inform')

        CreateThread(function()
            Wait((Config.TestDrive.Time or 60) * 1000)

            if activeTestDrive and DoesEntityExist(activeTestDrive.vehicle) then
                DeleteEntity(activeTestDrive.vehicle)
            end

            activeTestDrive = nil

            if Config.TestDrive.ReturnLocation then
                SetEntityCoords(PlayerPedId(), Config.TestDrive.ReturnLocation.x, Config.TestDrive.ReturnLocation.y, Config.TestDrive.ReturnLocation.z, false, false, false, false)
                SetEntityHeading(PlayerPedId(), Config.TestDrive.ReturnLocation.w or 0.0)
            end

            notify(X3roxDev.Locale('test_drive_over'), 'inform')
        end)

        cb({ success = true })
    end, data.model)
end)

local function createBlips()
    if not Config.Blip or not Config.Blip.Enabled or not Config.Dealerships then
        return
    end

    for _, dealership in ipairs(Config.Dealerships) do
        if dealership.showBlip ~= false then
            local blip = AddBlipForCoord(dealership.coords.x, dealership.coords.y, dealership.coords.z)
            SetBlipSprite(blip, Config.Blip.Sprite or 225)
            SetBlipDisplay(blip, Config.Blip.Display or 4)
            SetBlipScale(blip, Config.Blip.Scale or 0.8)
            SetBlipColour(blip, Config.Blip.Colour or 27)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(Config.Blip.Name or 'Vehicle Shop')
            EndTextCommandSetBlipName(blip)
        end
    end
end

local function createNpc()
    if not Config.Npc or not Config.Npc.Enabled then
        return
    end

    local hash = loadModel(Config.Npc.Model)
    if not hash then
        return
    end

    local coords = Config.Npc.Coords
    local ped = CreatePed(4, hash, coords.x, coords.y, coords.z - 1.0, coords.w or 0.0, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    shopPeds[#shopPeds + 1] = ped
    SetModelAsNoLongerNeeded(hash)
end

local function createDisplayVehicles()
    if not Config.DisplayVehicles then
        return
    end

    for _, display in ipairs(Config.DisplayVehicles) do
        local hash = loadModel(display.model, 'vehicle')

        if hash then
            local coords = display.coords
            local vehicle = CreateVehicle(hash, coords.x, coords.y, coords.z, coords.w or 0.0, false, false)
            SetEntityAsMissionEntity(vehicle, true, true)
            FreezeEntityPosition(vehicle, true)
            SetEntityInvincible(vehicle, true)
            SetVehicleDoorsLocked(vehicle, 2)
            SetVehicleDirtLevel(vehicle, 0.0)

            if display.bodyColor then
                SetVehicleCustomPrimaryColour(vehicle, display.bodyColor.r or 255, display.bodyColor.g or 255, display.bodyColor.b or 255)
                SetVehicleCustomSecondaryColour(vehicle, display.bodyColor.r or 255, display.bodyColor.g or 255, display.bodyColor.b or 255)
            end

            if display.neonColor then
                for index = 0, 3 do
                    SetVehicleNeonLightEnabled(vehicle, index, true)
                end

                SetVehicleNeonLightsColour(vehicle, display.neonColor.r or 255, display.neonColor.g or 255, display.neonColor.b or 255)
            end

            displayVehicles[#displayVehicles + 1] = vehicle
            SetModelAsNoLongerNeeded(hash)
        end
    end
end

local function createTargets()
    if not Config.Dealerships then
        return false
    end

    if Config.Target == 'ox_target' and GetResourceState('ox_target') == 'started' then
        for index, dealership in ipairs(Config.Dealerships) do
            exports.ox_target:addBoxZone({
                coords = dealership.coords,
                size = vec3(2.0, 2.0, 2.0),
                rotation = 0.0,
                options = {
                    {
                        name = ('X3roxDev_vehicleshop_shop_%s'):format(index),
                        icon = 'fa-solid fa-car',
                        label = X3roxDev.Locale('target_open'),
                        onSelect = openShop
                    }
                }
            })
        end

        return true
    end

    if Config.Target == 'qb-target' and GetResourceState('qb-target') == 'started' then
        for index, dealership in ipairs(Config.Dealerships) do
            exports['qb-target']:AddBoxZone(
                ('X3roxDev_vehicleshop_shop_%s'):format(index),
                dealership.coords,
                2.0,
                2.0,
                {
                    name = ('X3roxDev_vehicleshop_shop_%s'):format(index),
                    heading = 0.0,
                    minZ = dealership.coords.z - 1.0,
                    maxZ = dealership.coords.z + 1.5
                },
                {
                    options = {
                        {
                            type = 'client',
                            event = 'X3roxDev_vehicleshop:client:openShop',
                            icon = 'fa-solid fa-car',
                            label = X3roxDev.Locale('target_open')
                        }
                    },
                    distance = 2.0
                }
            )
        end

        return true
    end

    return false
end

CreateThread(function()
    createBlips()
    createNpc()
    createDisplayVehicles()

    local usingTarget = createTargets()

    if not usingTarget and Config.FallbackMarker and Config.Dealerships then
        while true do
            local sleep = 1000
            local playerCoords = GetEntityCoords(PlayerPedId())

            for _, dealership in ipairs(Config.Dealerships) do
                local distance = #(playerCoords - dealership.coords)

                if distance < 12.0 then
                    sleep = 0
                    DrawMarker(2, dealership.coords.x, dealership.coords.y, dealership.coords.z + 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.35, 0.35, 0.35, 142, 68, 255, 180, false, true, 2, false, nil, nil, false)

                    if distance < 2.0 then
                        BeginTextCommandDisplayHelp('STRING')
                        AddTextComponentSubstringPlayerName(X3roxDev.Locale('open_shop'))
                        EndTextCommandDisplayHelp(0, false, true, -1)

                        if IsControlJustPressed(0, 38) then
                            openShop()
                        end
                    end
                end
            end

            Wait(sleep)
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    for _, ped in ipairs(shopPeds) do
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end

    for _, vehicle in ipairs(displayVehicles) do
        if DoesEntityExist(vehicle) then
            DeleteEntity(vehicle)
        end
    end

    if activeTestDrive and DoesEntityExist(activeTestDrive.vehicle) then
        DeleteEntity(activeTestDrive.vehicle)
    end
end)
