local c = Config.Global

if c == 'ESX' then
    ESX = exports['es_extended']:getSharedObject()
elseif c == 'QBCore' then
    QBCore = exports['qb-core']:GetCoreObject()
end

CreateThread(function()
    print('sublime-gofast:FrameWork Loaded: ', c.FrameWork)
end)

local GetGroup = Bridge['GetGroup']
RegisterCommand('gofast_start', function(src, args)
    local group = GetGroup(src)
    if group == 'user' then
        TriggerClientEvent('sublime-gofast:insuffisantPermissions', src, 1)
        return
    end

    local currentEvent = goFast.New()
    currentEvent:__debug()
end)
