Config = {}

-- Balık tutma bölgeleri
Config.FishingZones = {
    {x = -1841.47, y = -1249.99, z = 8.62}, -- Santa Monica Pier
    {x = 1311.5, y = 4228.5, z = 33.92},    -- Alamo Denizi
    {x = -3428.27, y = 967.54, z = 8.35},   -- Chumash Pier
    {x = 3855.66, y = 4463.67, z = 1.85},   -- Kuzey Doğu Sahili
    {x = -1612.18, y = 5262.04, z = 3.97},  -- Kuzey Sahili
}

-- Balık satış noktaları
Config.SellLocations = {
    {x = -1816.406, y = -1193.334, z = 13.305}, -- Balıkçı Dükkanı 1
    {x = -1592.971, y = 5202.647, z = 4.314},   -- Balıkçı Dükkanı 2
}

-- Balık türleri ve fiyatları
Config.FishTypes = {
    {name = "Hamsi", price = {min = 10, max = 25}},
    {name = "Levrek", price = {min = 30, max = 50}},
    {name = "cipura", price = {min = 40, max = 60}},
    {name = "Kefal", price = {min = 20, max = 35}},
    {name = "Palamut", price = {min = 45, max = 70}},
}

Config.FishingItems = {
    rod = 'ruqeon_olta', -- Olta item ismi
    bait = 'fishbait' -- Yem item ismi
}

Config.Fishes = {
    [1] = {
        name = "hamsi",
        label = "Hamsi",
        price = {min = 10, max = 25},
        chance = 40
    },
    [2] = {
        name = "istavrit",
        label = "İstavrit",
        price = {min = 20, max = 35},
        chance = 30
    },
    [3] = {
        name = "lufer",
        label = "Lüfer",
        price = {min = 40, max = 60},
        chance = 20
    },
    [4] = {
        name = "palamut",
        label = "Palamut",
        price = {min = 50, max = 80},
        chance = 10
    }
}

Config.SellLocation = vector3(-1816.406, -1193.334, 13.305) -- Balık satış noktası 