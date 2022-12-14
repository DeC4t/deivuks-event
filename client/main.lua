local blip, started, newWay
local inMarker, sleep, type, lastcoord, distance, incorrect = false, 1000, 24, vec3(0,0,0), 0, false

RegisterNetEvent('d-event:start', function()
    local location = Config.Locations[1]
    blip = AddBlipForCoord(location.coords)
    SetBlipSprite(blip, Config.Blips[location.blip])
    SetBlipRoute(blip,  true)
    SetBlipColour(blip, 26)
    SetBlipRouteColour(blip, 26)
    newWay = Config.Locations[1]
    distance = #(newWay.coords - GetEntityCoords(PlayerPedId()))
    started = true
    if Config.helpNotify == 'esx' then
        Config.ShowHelpNotify(Config.Locale[Config.Language]['go_start'])
    elseif Config.helpNotify == 'deivuks-ui' then
        exports['deivuks-ui']:topText(true, 'Važiuokite iki kito <a class="text-sky-500">taško</a>.')
    end
end)

RegisterCommand('getWaypoint', function()
    local coords = GetEntityCoords(PlayerPedId())
    if started then 
        for i=1, #Config.Locations do
            if #(Config.Locations[i].coords - coords) < 2.5 then 
                if not Config.Locations[i].delete then
                    if IsPedSittingInAnyVehicle(PlayerPedId()) then
                        Config.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
                    end
                    Wait(100)
                    Config.SpawnVehicle(Config.Locations[i].vehicle, GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()))
                    RemoveBlip(blip)
                    newWay = Config.Locations[i+1]
                    distance = #(newWay.coords - GetEntityCoords(PlayerPedId()))
                    blip = AddBlipForCoord(newWay.coords)
                    SetBlipSprite(blip, Config.Blips[newWay.blip])
                    SetBlipRoute(blip, true)
                    SetBlipColour(blip, 26)
                    SetBlipRouteColour(blip, 26)
                    table.remove(Config.Locations, i)
                    if Config.helpNotify == 'deivuks-ui' then
                        exports['deivuks-ui']:topText(true, 'Važiuokite iki kito <a class="text-sky-500">taško</a>.')
                    end
                    if not newWay.delete then
                        type = Config.Types['switch']
                    else
                        type = Config.Types['finish']
                    end
                else 
                    RemoveBlip(blip)
                    started = false
                    inMarker = false
                    incorrect = false
                    sleep = 1000
                    if Config.helpNotify == 'deivuks-ui' then
                        exports['deivuks-ui']:keybingMenu(false)
                        exports['deivuks-ui']:topText(false)
                    end
                    Config.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
                    TriggerServerEvent('d-event:sendPlaces')
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if started then
            local coords = GetEntityCoords(PlayerPedId())
            if #(newWay.coords - coords) < 20.0 then 
                inMarker = true
                if #(newWay.coords - coords) < 5.0 then
                    if not newWay.delete then
                        if Config.helpNotify == 'esx' then
                            Config.ShowHelpNotify(Config.Locale[Config.Language]['press_change'])
                        elseif Config.helpNotify == 'deivuks-ui' then
                            exports['deivuks-ui']:keybingMenu(true, {
                                {text = 'Spauskite -', key = 'E', text2 = ' ,kad pasikeistumėte automobilį į <a class="text-sky-500">'..newWay.name..'</a>'}
                            })
                            exports['deivuks-ui']:topText(true, 'Pasiekėte naują kelionės <a class="text-sky-500">tašką</a>.')
                        end
                    else
                        if Config.helpNotify == 'esx' then
                            Config.ShowHelpNotify(Config.Locale[Config.Language]['end_race'])
                        elseif Config.helpNotify == 'deivuks-ui' then
                            exports['deivuks-ui']:keybingMenu(true, {
                                {text = 'Spauskite -', key = 'E', text2 = ' ,kad užbaigtumėte <a class="text-sky-500">lenktynes</a>.'}
                            })
                            exports['deivuks-ui']:topText(true, 'Pasiekėte kelionės <a class="text-sky-500">tikslą</a>.')
                        end
                    end
                end
            else
                inMarker = false
                sleep = 1000
                if not incorrect then
                    if Config.helpNotify == 'esx' then
                        Config.ShowHelpNotify(Config.Locale[Config.Language]['go_next'])
                    elseif Config.helpNotify == 'deivuks-ui' then
                        exports['deivuks-ui']:keybingMenu(false)
                        exports['deivuks-ui']:topText(true, 'Važiuokite iki kito <a class="text-sky-500">taško</a>.')
                    end
                end
            end
        end
        Wait(1000)
    end
end)


Citizen.CreateThread(function()
    while true do 
        if inMarker then 
            sleep = 6
            DrawMarker(type, newWay.coords.x, newWay.coords.y, newWay.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 66, 151, 241, 50, true, false, false, nil, nil, false)
            DrawMarker(1, newWay.coords.x, newWay.coords.y, newWay.coords.z -1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 2.0, 66, 151, 241, 40, false, false, false, nil, nil, false)
        end
        Wait(sleep)
    end
end)

local time, savedCoords = Config.TimeBeforeTeleport * 1000, vec3(0,0,0)

Citizen.CreateThread(function()
    while true do
        if started then
            if time > 0 then
                local coords = GetEntityCoords(PlayerPedId())
                if #(newWay.coords - coords) >= distance + 15 then 
                    if Config.helpNotify == 'esx' then
                        Config.ShowHelpNotify(Config.Locale[Config.Language]['go_back'])
                    elseif Config.helpNotify == 'deivuks-ui' then
                        exports['deivuks-ui']:topText(true, '<a class="text-sky-500">Apsisukite</a>, jūs važiuojate ne į tą pusę.')
                    end
                    time -= 500
                    incorrect = true
                end
                if #(newWay.coords - coords) <= distance then 
                    distance = #(newWay.coords - coords)
                    time = Config.TimeBeforeTeleport * 1000
                    savedCoords = coords
                    incorrect = false
                end
            else
                SetPedCoordsKeepVehicle(PlayerPedId(), savedCoords)
                time = Config.TimeBeforeTeleport * 1000
                incorrect = false
            end
        end
        Wait(500)
    end
end)

RegisterKeyMapping('getWaypoint', 'Gauti automobili', 'keyboard', 'e')