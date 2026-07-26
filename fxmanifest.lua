fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'dealership'
author 'X3roxDev'
description 'Custom FiveM vehicle shop with ESX/QBCore support, interactive NUI, catalog images, and localization.'
version '1.0.1'
repository 'https://github.com/X3roxDev/dealership'

shared_scripts {
    'config.lua',
    'locales/en.lua',
    'locales/pt.lua',
    'shared/framework.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/img/*.png',
    'html/img/*.svg'
}

