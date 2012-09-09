local cnfg = KEYS[1]
local src1 = KEYS[2]
local src2 = KEYS[3]
local trgt = KEYS[4]

local dim  = redis.call('hget', cnfg, 'dim')
local lyt  = {}
local all  = 1
for idx = 1, dim do
    lyt[idx] = redis.call('hget', cnfg, 'lyt:' .. idx)
    all = all * lyt[idx]
end

local ret = all

while all ~= 0 do
    local affix = ''
    local base = 1
    local total = all
    for idx = dim, 1, -1 do
        local lmt  = lyt[idx]
        local reminder = total % lmt
        total = (total - reminder) / lmt
        if reminder == 0 then
            reminder = lmt
        end
        affix = ':' .. reminder .. affix
    end

    local key1 = src1 .. affix
    local key2 = src2 .. affix
    local key3 = trgt .. affix

    local opd1 = redis.call('lrange', key1, 0, -1)
    local opd2 = redis.call('lrange', key2, 0, -1)

    for ind = dim, 1, -1 do
            local result = opd1[ind] + opd2[ind]
            redis.call('lpush', key3, result)
    end

    all = all - 1
end

return ret
