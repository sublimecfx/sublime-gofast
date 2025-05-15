goFast = {};

local __instance = {
    __index = goFast,
};

local goFastRunning = {};

local goFast_globalCount = 0;

local ValidCarMod = {
    ['car'] = { 'blista', 'sultan' },
    ['marin'] = { 'dinghy', 'tug' },
    ['air'] = { 'havok' }
}

local function GenCarMod()
    local categories = {}
    for category in pairs(ValidCarMod) do
        table.insert(categories, category)
    end

    local randomCategory = categories[math.random(1, #categories)]
    return randomCategory
end

local function GenCarModel(category)
    local vehicles = ValidCarMod[category]
    if not vehicles or #vehicles == 0 then
        print("[ERREUR] Aucun véhicule trouvé pour la catégorie : " .. tostring(category))
        return nil
    end

    local randomIndex = math.random(1, #vehicles)
    return vehicles[randomIndex]
end

function goFast.New()
    local self = setmetatable({}, __instance);

    goFast_globalCount = goFast_globalCount + 1;
    self.eventId = goFast_globalCount;
    self.carType = GenCarMod();
    self.carModel = GenCarModel(self.carType);
    self.timeCreated = os.time();
    self.state = true

    goFastRunning[goFast_globalCount] = self

    TriggerClientEvent('sublime-gofast:start', -1, self)
    return self;
end

function goFast:stop()
    self.state = false
    goFastRunning[self.eventId] = nil
end

if Config.Global.DevMod then
    function goFast:__debug()
        print('sublime-gofast:debug', json.encode(self, { indent = true }))
    end
end
