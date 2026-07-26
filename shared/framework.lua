X3roxDev = X3roxDev or {}
X3roxDev.ResourceName = GetCurrentResourceName()

local function resourceStarted(name)
    return GetResourceState(name) == 'started'
end

local function detectFramework()
    if resourceStarted('es_extended') then
        return 'esx'
    end

    if resourceStarted('qb-core') then
        return 'qb'
    end

    return 'standalone'
end

X3roxDev.FrameworkName = detectFramework()

function X3roxDev.HashModel(model)
    if type(model) == 'number' then
        return model
    end

    return GetHashKey(tostring(model))
end

function X3roxDev.Locale(key, ...)
    local locale = Config and Config.Locale or 'en'
    local lang = Lang and (Lang[locale] or Lang.en) or {}
    local value = lang[key] or key

    if select('#', ...) > 0 then
        return value:format(...)
    end

    return value
end

function X3roxDev.GetVehicleConfig(model)
    if not model or not Config or not Config.Vehicles then
        return nil
    end

    local needle = tostring(model):lower()

    for _, vehicle in ipairs(Config.Vehicles) do
        if tostring(vehicle.model):lower() == needle then
            return vehicle
        end
    end

    return nil
end

function X3roxDev.BuildVehicleList()
    local list = {}

    if not Config or not Config.Vehicles then
        return list
    end

    for _, vehicle in ipairs(Config.Vehicles) do
        local model = tostring(vehicle.model or ''):lower()
        local category = tostring(vehicle.category or '')

        if model ~= ''
            and (not Config.BlacklistedModels or not Config.BlacklistedModels[model])
            and (not Config.AllowedCategories or Config.AllowedCategories[category]) then
            list[#list + 1] = {
                model = model,
                label = vehicle.label or model,
                brand = vehicle.brand or '',
                price = tonumber(vehicle.price) or tonumber(Config.FallbackPrice) or 0,
                category = category,
                categoryLabel = Config.CategoryLabels and Config.CategoryLabels[category] or category,
                image = vehicle.image or (model .. '.png')
            }
        end
    end

    return list
end

function X3roxDev.GeneratePlate()
    local letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    local plate = ''

    for _ = 1, 3 do
        local index = math.random(1, #letters)
        plate = plate .. letters:sub(index, index)
    end

    return plate .. tostring(math.random(100, 999))
end

if IsDuplicityVersion() then
    X3roxDev.ServerCallbacks = {}

    RegisterNetEvent('X3roxDev_vehicleshop:server:triggerCallback', function(name, requestId, ...)
        local src = source
        local callback = X3roxDev.ServerCallbacks[name]

        if not callback then
            TriggerClientEvent('X3roxDev_vehicleshop:client:callback', src, requestId, false, 'missing_callback')
            return
        end

        callback(src, function(...)
            TriggerClientEvent('X3roxDev_vehicleshop:client:callback', src, requestId, ...)
        end, ...)
    end)

    function X3roxDev.RegisterServerCallback(name, callback)
        X3roxDev.ServerCallbacks[name] = callback
    end
else
    X3roxDev.ClientCallbacks = {}
    X3roxDev.ClientCallbackId = 0

    RegisterNetEvent('X3roxDev_vehicleshop:client:callback', function(requestId, ...)
        local callback = X3roxDev.ClientCallbacks[requestId]

        if callback then
            X3roxDev.ClientCallbacks[requestId] = nil
            callback(...)
        end
    end)

    function X3roxDev.TriggerServerCallback(name, callback, ...)
        X3roxDev.ClientCallbackId = X3roxDev.ClientCallbackId + 1
        X3roxDev.ClientCallbacks[X3roxDev.ClientCallbackId] = callback
        TriggerServerEvent('X3roxDev_vehicleshop:server:triggerCallback', name, X3roxDev.ClientCallbackId, ...)
    end
end
