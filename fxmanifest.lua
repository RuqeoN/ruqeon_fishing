fx_version 'cerulean'
game 'gta5'

description 'QB-Fishing'
version '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    'server/main.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/img/fish.png'
}

ui_page 'html/index.html'

exports {
    'useRod'
} 