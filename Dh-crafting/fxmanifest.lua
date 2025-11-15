fx_version 'cerulean'
game 'gta5'

author 'Dahm IS ON TOP'
description 'Dahm Crafting'
version '1.0.0'

escrow_ignore 'Config.lua'


client_script {'Client/*.lua' , '@ox_lib/init.lua'}
server_script {'Server/*.lua', '@oxmysql/lib/MySQL.lua',}
shared_script 'Config.lua'
ui_page 'UI/index.html'
files {'UI/index.html' , 'UI/*.css' , 'UI/*.js' }
lua54 'yes'