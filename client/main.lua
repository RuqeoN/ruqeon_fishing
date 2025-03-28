local QBCore = exports['qb-core']:GetCoreObject()
local isFishing = false

-- Olta prop'unu silme fonksiyonu
function DeleteFishingRod()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local radius = 50.0
    local fishingRod = GetClosestObjectOfType(coords.x, coords.y, coords.z, radius, `prop_fishing_rod_01`, false, false, false)
    if fishingRod ~= 0 then
        DeleteObject(fishingRod)
    end
end

-- Balık tutma fonksiyonu
function StartFishing()
    if isFishing then return false end
    
    local ped = PlayerPedId()
    isFishing = true
    
    -- Olta prop'unu sil
    DeleteFishingRod()
    
    -- Animasyon
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_FISHING", 0, true)
    
    -- UI'ı hemen göster
    SetNuiFocus(true, false)
    SendNUIMessage({
        type = "ui",
        status = true
    })
    
    -- Balık gelme süresi (5-10 saniye arası)
    CreateThread(function()
        Wait(math.random(5000, 10000))
        if isFishing then
            SendNUIMessage({
                type = "showFish",
                status = true
            })
        end
    end)
    
    return true
end

-- Olta kullanımı için event
RegisterNetEvent('qb-fishing:client:FishingRod', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local inFishingZone = false
    
    -- Balık tutma bölgesinde mi kontrol et
    for _, zone in pairs(Config.FishingZones) do
        local zoneCoords = vector3(zone.x, zone.y, zone.z)
        local distance = #(coords - zoneCoords)
        if distance <= 50.0 then
            inFishingZone = true
            break
        end
    end

    if not inFishingZone then
        QBCore.Functions.Notify('Burada balık tutamazsın!', 'error')
        return
    end

    if isFishing then 
        QBCore.Functions.Notify('Zaten balık tutuyorsun!', 'error')
        return
    end

    -- Yem kontrolü
    local hasBait = QBCore.Functions.HasItem('fishbait')
    
    if not hasBait then
        QBCore.Functions.Notify('Balık tutmak için yeme ihtiyacın var!', 'error')
        return
    end

    StartFishing()
end)

-- NUI Callback'leri
RegisterNUICallback('minigameCompleted', function(data, cb)
    if data.success then
        TriggerServerEvent('qb-fishing:server:catchFish')
        QBCore.Functions.Notify('Balık yakaladın!', 'success')
    else
        QBCore.Functions.Notify('Balık kaçtı!', 'error')
    end
    StopFishing()
    cb('ok')
end)

RegisterNUICallback('exit', function(data, cb)
    StopFishing()
    cb('ok')
end)

-- Balık tutmayı durdur
function StopFishing()
    local ped = PlayerPedId()
    isFishing = false
    ClearPedTasks(ped)
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "ui",
        status = false
    })
    -- Olta prop'unu sil
    DeleteFishingRod()
end

-- Balık satış noktası
CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false
        
        for k, v in pairs(Config.SellLocations) do
            local sellCoords = vector3(v.x, v.y, v.z)
            local dist = #(pos - sellCoords)
            if dist < 10 then
                inRange = true
                DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 255, 255, 255, 255, 0, 0, 0, 1, 0, 0, 0)
                if dist < 1.5 then
                    DrawText3D(v.x, v.y, v.z + 0.3, '[E] Balık Sat')
                    if IsControlJustPressed(0, 38) then
                        TriggerServerEvent('qb-fishing:server:SellFish')
                    end
                end
            end
        end
        
        if not inRange then
            Wait(1500)
        end
    end
end)

-- 3D Text çizme fonksiyonu
function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end