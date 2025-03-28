-- Balık seçme fonksiyonu
local function SelectFish()
    local chance = math.random(1, 100)
    local currentChance = 0
    
    for _, fish in pairs(Config.Fishes) do
        currentChance = currentChance + fish.chance
        if chance <= currentChance then
            return fish
        end
    end
    
    return Config.Fishes[1] -- Eğer bir şey seçilemezse varsayılan olarak ilk balık
end

-- Balık yemi kontrolü
local function TryFishing(source)
    local hasItem = exports.ox_inventory:GetItem(source, 'fishbait', nil, true)
    
    if hasItem >= 1 then
        -- Önce yemi kaldır
        if exports.ox_inventory:RemoveItem(source, 'fishbait', 1) then
            -- Şans sistemine göre balık seç
            local caughtFish = SelectFish()
            
            -- Metadata ile birlikte balık ekle
            local metadata = {
                description = 'Taze yakalanmış ' .. caughtFish.label,
                -- Eğer başka metadata eklemek isterseniz buraya ekleyebilirsiniz
            }
            
            -- Balığı envantere eklemeyi dene
            local success = exports.ox_inventory:AddItem(source, caughtFish.name, 1, metadata)
            
            if success then
                -- Balık ekleme animasyonu
                TriggerClientEvent('inventory:client:ItemBox', source, exports.ox_inventory:Items()[caughtFish.name], 'add')
                
                -- Başarılı bildirim
                TriggerClientEvent('ox_lib:notify', source, {
                    title = 'Balık Tutuldu',
                    description = caughtFish.label .. ' yakaladın!',
                    type = 'success'
                })
                return true
            else
                -- Başarısız olursa yemi geri ver
                exports.ox_inventory:AddItem(source, 'fishbait', 1)
                
                TriggerClientEvent('ox_lib:notify', source, {
                    title = 'Hata',
                    description = 'Envantere balık eklenemedi!',
                    type = 'error'
                })
                return false
            end
        end
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Hata',
            description = 'Yeterli balık yemin yok!',
            type = 'error'
        })
        return false
    end
end

-- Event handler
RegisterNetEvent('qb-fishing:server:tryFishing', function()
    local source = source
    print("Debug - Balık tutma denemesi başladı, Oyuncu ID:", source) -- Debug için
    TryFishing(source)
end) 