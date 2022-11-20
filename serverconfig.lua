ServerConfig = {}

ServerConfig.Perms = function(id)
    local xPlayer = ESX.GetPlayerFromId(id)
    return xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin'
end