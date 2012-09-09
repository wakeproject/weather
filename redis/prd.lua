local cnfg = KEYS[1]
local src  = KEYS[2]
local trgt = KEYS[3]
local cnst = ARGV[1]
local part = ARGV[2]

local dim = redis.call('hget', cnfg, 'dim')
local key = cnfg .. ':partition:' .. part
local affixes = redis.call('lrange', key, 0, -1)

local len = #affixes
for idx = 1, len do
    local affix = affixes[idx]
    local key1 = src .. affix
    local key2 = trgt .. affix

    local opd = redis.call('lrange', key1, 0, -1)

    for ind = dim, 1, -1 do
        local result = opd[ind] * cnst
        redis.call('lpush', key2, result)
    end
end

return len
