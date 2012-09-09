local cnfg = KEYS[1]
local src1 = KEYS[2]
local src2 = KEYS[3]
local trgt = KEYS[4]
local part = ARGV[1]

local dim = redis.call('hget', cnfg, 'dim')
local key = cnfg .. ':partition:' .. part
local affixes = redis.call('lrange', key, 0, -1)

local len = #affixes
for idx = 1, len do
    local affix = affixes[idx]

    local key1 = src1 .. affix
    local key2 = src2 .. affix
    local key3 = trgt .. affix

    local opd1 = redis.call('lrange', key1, 0, -1)
    local opd2 = redis.call('lrange', key2, 0, -1)

    for ind = dim, 1, -1 do
            local result = opd1[ind] + opd2[ind]
            redis.call('lpush', key3, result)
    end
end

return len
