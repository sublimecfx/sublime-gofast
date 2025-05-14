local c = Config.Global

if c == 'ESX' then
    ESX = exports['es_extended']:getSharedObject()
elseif c == 'QBCore' then
    QBCore = exports['qb-core']:GetCoreObject()
end

function Notify(msg)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(false, false)
end

RegisterNetEvent('sublime-gofast:insuffisantPermissions', function(errorCode)
    Notify(Config.Errors[errorCode])
end)
