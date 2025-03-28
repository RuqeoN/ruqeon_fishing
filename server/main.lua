local QBCore = exports['qb-core']:GetCoreObject()

-- Balık seçme fonksiyonu
local function SelectFish()
    local chance = math.random(1, 100)
    local currentChance = 0
    
    for _, fish in pairs(Config.Fishes) do
        currentChance = currentChance + fish.chance
        if chance <= currentChance then
            return fish.name -- Direkt balık ismini döndürüyoruz
        end
    end
    
    return Config.Fishes[1].name -- Varsayılan olarak ilk balığın ismini döndür
end

-- Balık tutma fonksiyonu (Event ismini catchFish olarak değiştirdik!)
RegisterNetEvent('qb-fishing:server:catchFish', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    -- Balık yemi kontrolü
    local hasItem = exports.ox_inventory:GetItem(src, 'fishbait', nil, true)
    
    if hasItem >= 1 then
        -- Yemi kaldır
        exports.ox_inventory:RemoveItem(src, 'fishbait', 1)
        
        -- Balık seç (direkt isim olarak geliyor)
        local fishName = SelectFish()
        print("Seçilen balık:", fishName) -- Debug için
        
        -- Balığı ekle
        if exports.ox_inventory:AddItem(src, fishName, 1) then
            -- Item box gösterimi (direkt balık ismini kullanıyoruz)
            TriggerClientEvent('inventory:client:ItemBox', src, exports.ox_inventory:Items()[fishName], 'add')
            
            -- Config'den balık etiketini bul
            local fishLabel = "Balık"
            for _, fish in pairs(Config.Fishes) do
                if fish.name == fishName then
                    fishLabel = fish.label
                    break
                end
            end
            
            -- Başarılı bildirim
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Balık Tutuldu',
                description = fishLabel .. ' yakaladın!',
                type = 'success'
            })
        else
            -- Başarısız durumda yemi geri ver
            exports.ox_inventory:AddItem(src, 'fishbait', 1)
            
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Hata',
                description = 'Envantere balık eklenemedi!',
                type = 'error'
            })
        end
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Hata',
            description = 'Yeterli balık yemin yok!',
            type = 'error'
        })
    end
end)

-- Balık satış eventi
RegisterNetEvent('qb-fishing:server:sellFish', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local totalPrice = 0
    local fishSold = false
    
    for _, fishData in pairs(Config.Fishes) do
        local fishItem = Player.Functions.GetItemByName(fishData.name)
        if fishItem then
            local amount = fishItem.amount
            local price = math.random(fishData.price.min, fishData.price.max)
            local fishPrice = price * amount
            
            Player.Functions.RemoveItem(fishData.name, amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[fishData.name], "remove")
            
            totalPrice = totalPrice + fishPrice
            fishSold = true
        end
    end
    
    if fishSold then
        Player.Functions.AddMoney('cash', totalPrice)
        TriggerClientEvent('QBCore:Notify', src, 'Balıkları $' .. totalPrice .. ' karşılığında sattın!', 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Satılacak balığın yok!', 'error')
    end
end)

-- Item tanımlamaları
QBCore.Functions.CreateUseableItem('fishingrod1', function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if not Player.Functions.GetItemByName('fishingrod1') then return end
    TriggerClientEvent('qb-fishing:client:FishingRod', src)
end) 