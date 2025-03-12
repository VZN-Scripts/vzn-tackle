fx_version 'cerulean'
game 'gta5'
lua54 'yes'

version '1.0.0'

author 'VZN Scripts'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/utils.lua',
}

server_scripts {
    'version_check.lua',
    'server/main.lua',
    'server/utils.lua'
}

dependencies {
    'ox_lib'
}
