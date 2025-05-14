local _data = {}
local StartGameTimer = 0
local c = Config.Global

if c == 'ESX' then
    ESX = exports['es_extended']:getSharedObject()
elseif c == 'QBCore' then
    QBCore = exports['qb-core']:GetCoreObject()
end

local function Notify(msg)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(false, false)
end

local function ShowHelpNotification(msg)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

CreateThread(function()
    local pedModels = Config.Global.PedModel
    local modelName = pedModels[math.random(#pedModels)]
    local modelHash = GetHashKey(modelName)

    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(10)
    end

    local spawnCoords = c.PedCoords
    local pedHeading = c.PedHeading

    local ped = CreatePed(4, modelHash, spawnCoords.x, spawnCoords.y, spawnCoords.z, pedHeading, false, true)
    print('[sublime-gofast:debug] Ped Spawned!')

    FreezeEntityPosition(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped, true)

    local w = 1000
    while true do
        Wait(w)

        local myCoords = GetEntityCoords(PlayerPedId())
        local dst = #(myCoords - spawnCoords)

        if dst < 2.0 then
            w = 0
            DrawMarker(
                1,
                spawnCoords.x, spawnCoords.y, spawnCoords.z,
                0.0, 0.0, 0.0,
                0.0, 0.0, 0.0,
                1.0, 1.0, 0.1,
                255, 255, 255, 150,
                false, true, 2, false, nil, nil, false
            )

            ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour prendre une mission.")
        else
            w = 500
        end
    end
end)


RegisterNetEvent('sublime-gofast:insuffisantPermissions', function(errorCode)
    Notify(Config.Errors[errorCode])
end)

local function StopGoFast()
    _data.state = false
end

local function StartCarGoFast()
end

local function StartAirGoFast()
end

local function StartMarinGoFast()
end

local function InitGoFastCoolDown()
    CreateThread(function()
        while _data.state == true do
            Wait(1000)

            local elapsed = GetGameTimer() - StartGameTimer
            if elapsed >= Config.Global.GlobalTime then
                StopGoFast()
                break
            end
        end
    end)
end

RegisterNetEvent('sublime-gofast:start', function(eventData)
    _data = eventData
    _data.state = true
    StartGameTimer = GetGameTimer()

    if eventData.carType == 'car' then
        StartCarGoFast()
    elseif eventData.carType == 'air' then
        StartAirGoFast()
    elseif eventData.carType == 'marin' then
        StartMarinGoFast()
    end

    InitGoFastCoolDown()
end)
