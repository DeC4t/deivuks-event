Config = {}

Config.Join = vec3(498.7974, 5593.8193, 795.4568) -- This is used for /joinEvent in this location all users used command will be teleported

Config.Locations = {
    -- {coords = vec3(x, y, z), vehicle = `spawn_code`, name = 'name of vehicle in your language', blip = 'from Config.Blips', delete = false}, (for checkpoint)
    -- {coords = vec3(x, y, z), delete = true, blip = 'from Config.Blips'} (ends race)
    {coords = vec3(498.7974, 5593.8193, 795.4568), vehicle = `snowboard`, name = 'Snieglentę', blip = 'car', delete = false},
    {coords = vec3(2543.4578, 5131.1553, 47.9855), vehicle = `monster`, name = 'Monster Truck', blip = 'monster', delete = false},
    {coords = vec3(2730.7258, 4570.5547, 45.5683), delete = true, blip = 'end'}
}

Config.Types = { -- Marker types
    ['switch'] = 24,
    ['finish'] = 4,
}

Config.Blips = { -- Blip types used in Config.Locations as a blip
    ['car'] = 227,
    ['boat'] = 427,
    ['formula'] = 726,
    ['monster'] = 659,
    ['board'] = 126,
    ['end'] = 38,
}

Config.helpNotify = 'deivuks-ui' -- esx/deivuks-ui

Config.Language = 'lt'

Config.Locale = {
    ['lt'] = {
        ['go_start'] = 'Bėkite iki pradžios taško, kad pradėtumėte event.',
        ['press_change'] = 'Spauskite ~INPUT_CONTEXT~ ,kad pasikeistumėte automobilį į ',
        ['end_race'] = 'Spauskite ~INPUT_CONTEXT~ ,kad užbaigtumėte lenktynes.',
        ['go_next'] = 'Važiuokite iki kito taško.',
        ['go_back']  = 'Apsisukite, jūs važiuojate ne į tą pusę.',
        ['first_places'] = 'Pirmosios trys vietos atitenka: #1 %s, #2 %s, #3 %.',
    },
    ['en'] = {
        ['go_start'] = 'Run to the starting point to start the event.',
        ['press_change'] = 'Press ~INPUT_CONTEXT~ to change the vehicle to ',
        ['end_race'] = 'Press ~INPUT_CONTEXT~ to complete the race.',
        ['go_next'] = 'Drive to the next point.',
        ['go_back']  = 'Turn around, you`re driving the wrong way.',
        ['first_places'] = 'First three places goes to: #1 %s, #2 %s, #3 %.',
    },
}

Config.TimeBeforeTeleport = 15 -- Time in seconds before teleporting back to location of correct(after driving incorrect route) route while racing

Config.EndRace = false -- End race after first 3 players done racing

Config.JoinAfterStart = false -- Let players join event when it is started

Config.ShowHelpNotify = function(text)
    ESX.ShowHelpNotification(text)
end

Config.SpawnVehicle = function(vehicle, coords, heading)
    ESX.Game.SpawnVehicle(vehicle, coords, heading, function(car)
        SetPedIntoVehicle(PlayerPedId(), car, -1)
        NetworkFadeInEntity(car, true, true) 
    end)

    --[[
        local car = CreateVehicle(vehicle, coords.x, coords.y, coords.z, heading, true, true)
        SetPedIntoVehicle(PlayerPedId(), car, -1)
        NetworkFadeInEntity(car, true, true) 
    ]]
end

Config.DeleteVehicle = function(vehicle)
    ESX.Game.DeleteVehicle(vehicle)

    --[[
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
        while DoesEntityExist(vehicle) do
            SetEntityAsMissionEntity(vehicle, true, true)
            DeleteVehicle(vehicle)
            Wait(100)
        end
    ]]
end