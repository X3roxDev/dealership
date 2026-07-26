local ESX = nil
local QBCore = nil

CreateThread(function()
    if X3roxDev.FrameworkName == 'esx' and GetResourceState('es_extended') == 'started' then
        ESX = exports['es_extended']:getSharedObject()
    elseif X3roxDev.FrameworkName == 'qb' and GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
    end
end)

local function getPlayer(src)
    if X3roxDev.FrameworkName == 'esx' and ESX then
        return ESX.GetPlayerFromId(src)
    end

    if X3roxDev.FrameworkName == 'qb' and QBCore then
        return QBCore.Functions.GetPlayer(src)
    end

    return nil
end

local function normalizePaymentMethod(paymentMethod)
    paymentMethod = tostring(paymentMethod or 'cash'):lower()

    if paymentMethod == 'bank' then
        return 'bank'
    end

    return 'cash'
end

local function removeMoney(src, amount, paymentMethod)
    amount = tonumber(amount) or 0
    paymentMethod = normalizePaymentMethod(paymentMethod)

    if amount <= 0 then
        return true
    end

    local player = getPlayer(src)

    if X3roxDev.FrameworkName == 'esx' and player then
        if paymentMethod == 'bank' then
            local account = player.getAccount and player.getAccount('bank')

            if not account or (tonumber(account.money) or 0) < amount then
                return false
            end

            if player.removeAccountMoney then
                player.removeAccountMoney('bank', amount)
                return true
            end

            return false
        end

        if player.getMoney() < amount then
            return false
        end

        player.removeMoney(amount)
        return true
    end

    if X3roxDev.FrameworkName == 'qb' and player then
        if player.Functions.GetMoney(paymentMethod) < amount then
            return false
        end

        player.Functions.RemoveMoney(paymentMethod, amount, 'vehicle-shop')
        return true
    end

    return false
end

local function dbInsert(query, params)
    if GetResourceState('oxmysql') == 'started' then
        exports.oxmysql:insert(query, params)
        return true
    end

    if MySQL and MySQL.insert then
        MySQL.insert(query, params)
        return true
    end

    if MySQL and MySQL.Async and MySQL.Async.execute then
        MySQL.Async.execute(query, params)
        return true
    end

    return false
end

local function saveOwnedVehicle(src, model, plate)
    local player = getPlayer(src)
    local props = json.encode({
        model = X3roxDev.HashModel(model),
        plate = plate
    })

    if X3roxDev.FrameworkName == 'esx' and player then
        return dbInsert(
            'INSERT INTO owned_vehicles (owner, plate, vehicle, type, stored) VALUES (?, ?, ?, ?, ?)',
            { player.identifier, plate, props, 'car', 1 }
        )
    end

    if X3roxDev.FrameworkName == 'qb' and player then
        local data = player.PlayerData
        local license = data.license or data.citizenid

        return dbInsert(
            'INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
            { license, data.citizenid, model, X3roxDev.HashModel(model), props, plate, 'pillboxgarage', 0 }
        )
    end

    return false
end

X3roxDev.RegisterServerCallback('X3roxDev_vehicleshop:buyVehicle', function(src, cb, model, paymentMethod)
    local vehicle = X3roxDev.GetVehicleConfig(model)

    if not vehicle then
        cb(false, 'Invalid vehicle.')
        return
    end

    local price = tonumber(vehicle.price) or tonumber(Config.FallbackPrice) or 0

    if not removeMoney(src, price, paymentMethod) then
        cb(false, X3roxDev.Locale('not_enough_money'))
        return
    end

    local plate = X3roxDev.GeneratePlate()
    saveOwnedVehicle(src, vehicle.model, plate)

    cb(true, X3roxDev.Locale('vehicle_purchased'), plate)
end)

X3roxDev.RegisterServerCallback('X3roxDev_vehicleshop:startTestDrive', function(src, cb, model)
    local vehicle = X3roxDev.GetVehicleConfig(model)

    if not vehicle or not Config.TestDrive or not Config.TestDrive.Enabled then
        cb(false, 'Test drive unavailable.')
        return
    end

    local price = tonumber(Config.TestDrive.Price) or 0

    if not removeMoney(src, price) then
        cb(false, X3roxDev.Locale('not_enough_money'))
        return
    end

    cb(true, X3roxDev.Locale('test_drive_started', Config.TestDrive.Time or 60))
end)
