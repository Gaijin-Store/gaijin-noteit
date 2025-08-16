fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'gaijin-noteit'
author 'Gaijin Store'
description 'NoteIt - Sticky notes for FiveM'
version '1.1.2'

ui_page 'web/index.html'

files {
  'web/index.html',
  'web/main.css',
  'web/script.js'
}

shared_scripts {
  '@ox_lib/init.lua',
  'config.lua'
}

client_scripts {
  'client/main.lua'
}

server_scripts {
  'server/main.lua'
}

dependencies {
  'ox_lib',
  'ox_inventory',
  'ox_target'
}

escrow_ignore {
    'config.lua'
}