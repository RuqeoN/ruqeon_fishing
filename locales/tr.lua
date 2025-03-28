local Translations = {
    error = {
        no_rod = 'Balık tutmak için oltaya ihtiyacın var!',
        no_bait = 'Balık tutmak için yeme ihtiyacın var!',
        wrong_location = 'Burada balık tutamazsın!',
        fish_escaped = 'Balık kaçtı!',
        no_fish = 'Satılacak balığın yok!'
    },
    success = {
        fish_caught = '%{fish} yakaladın!',
        fish_sold = 'Balıkları $%{price} karşılığında sattın!'
    },
    info = {
        fishing_started = 'Balık tutmaya başladın...',
        sell_fish = '[E] Balık Sat'
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
}) 