Bridge = {}
local c = Config.Global

local function GetGroup(src)
    if c.FrameWork == 'ESX' then
        local player = ESX.GetPlayerFromId(src)
        local ESXgroup = player.getGroup()
        return ESXgroup
    end

    if c.FrameWork == 'QBCore' then
        local QBgroup = QBCore.Functions.GetPermission(src)
        return QBgroup
    end
end

local GetPlayer
if c.FrameWork == 'ESX' then
    ESX = exports['es_extended']:getSharedObject()
    GetPlayer = ESX.GetPlayerFromId
elseif c.FrameWork == 'QBCore' then
    QBCore = exports['qb-core']:GetCoreObject()
    GetPlayer = QBCore.Functions.GetPlayer
end

Bridge['GetPlayer'] = GetPlayer
Bridge['GetGroup'] = GetGroup
