fx_version 'cerulean'
game 'gta5'
author 'Linden'
--description ''
--versioncheck ''
version '1.0'
ui_page 'h.html'

dependencies {
	'es_extended'
}

shared_scripts {
	'config.lua',
	'strings.lua'
}

client_scripts {
	'client/*.lua',
	'pbar/pbar.lua'
}

files {
    'h.html'
}

server_scripts {
	'server/*.lua'
}

