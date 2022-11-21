local Joined, Started, bucket, newBucket, winners = {}, false, 0, 0, {}

RegisterCommand('resetEvents', function(source)
    if ServerConfig.Perms(source) and not Started then 
        Joined = {}
        Started = false
    end
end)

RegisterCommand('startEvent', function(source)
    if ServerConfig.Perms(source) and not Started then 
        if #Joined >= 3 then
            local bucket = GetPlayerRoutingBucket(source)
            local newBucket = math.random(99999999)
            for i=1, #Joined do
                TriggerClientEvent('d-event:start', Joined[i])
                SetPlayerRoutingBucket(Joined[i], newBucket)
            end
        else
            TriggerClientEvent("chatMessage", -1, 'Event can be started if there is 3 or more joined players')
        end
    end
end)

RegisterCommand('joinEvent', function(source)
    if GetPlayer(source) then
        if not Started then
            SetEntityCoords(GetPlayerPed(source), Config.Join.x, Config.Join.y, Config.Join.z, true, false, false, false)
            table.insert(Joined, source)
        else
            if Config.JoinAfterStart then
                SetEntityCoords(GetPlayerPed(source), Config.Join.x, Config.Join.y, Config.Join.z, true, false, false, false)
                table.insert(Joined, source)
                TriggerClientEvent('d-event:start', source)
            end
        end
    end
end)

RegisterCommand('endEvent', function(source)
    if ServerConfig.Perms(source) and Started then 
        for i=1, #Joined do
            DeleteEntity(GetVehiclePedIsIn(GetPlayerPed(Joined[i]), false))
            SetEntityCoords(GetPlayerPed(Joined[i]), Config.Join.x, Config.Join.y, Config.Join.z, true, false, false, false)
            SetPlayerRoutingBucket(Joined[i], bucket)
            table.remove(Joined, i)
        end
    end
end)

RegisterCommand('leaveEvent', function(source)
    if GetPlayer(source) then
        DeleteEntity(GetVehiclePedIsIn(GetPlayerPed(source), false))
        SetEntityCoords(GetPlayerPed(source), Config.Join.x, Config.Join.y, Config.Join.z, true, false, false, false)
        SetPlayerRoutingBucket(source, bucket)
        RemovePlayer(source)
    end
end)

RegisterNetEvent('d-event:sendPlaces', function()
    if #winners < 3 then
        winners[#winners+1] = source
        if (#winners+1) == 3 then
            TriggerClientEvent("chatMessage", -1, string.format(Config.Locale[Config.Language]['first_places'], GetPlayerName(winners[1]), GetPlayerName(winners[2]), GetPlayerName(winners[3])))
        end
    else
        if Config.EndRace then
            for i=1, #Joined do
                DeleteEntity(GetVehiclePedIsIn(GetPlayerPed(source), false))
                SetEntityCoords(GetPlayerPed(source), Config.Join.x, Config.Join.y, Config.Join.z, true, false, false, false)
                SetPlayerRoutingBucket(source, bucket)
            end
        end
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

function RemovePlayer(id)
    for i=1, #Joined do
        if Joined[i] == id then
            table.remove(Joined, i)
        end
    end
end