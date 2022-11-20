fx_version 'cerulean'
game 'gta5'

author '`Dec4t#8641'
description 'Deivuks Event'
version 'v1.0'

lua54 'yes'

shared_scripts {
	'@es_extended/imports.lua',
	'config.lua',
}

client_script 'client/main.lua'

server_scripts {
	'serverconfig.lua',
	'server/main.lua',
}