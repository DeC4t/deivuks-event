local Joined = {}

RegisterCommand('startEvent', function(source)
    if ServerConfig.Perms(source) then 
        for i=1, #Joined do
            TriggerClientEvent('d-event:start', Joined[i])
        end
    end
end)

RegisterCommand('joinEvent', function(source)
    if GetPlayer(source) then
        SetEntityCoords(GetPlayerPed(source), Config.Join.x, Config.Join.y, Config.Join.z, true, false, false, false)
        table.insert(Joined, source)
    end
end)

function GetPlayer(id)
    for i=1, #Joined do
        if Joined[i] == source then
            return false
        end
    end
    return true
end