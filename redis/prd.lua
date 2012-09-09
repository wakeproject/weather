local cnfg = KEYS[1]
local src  = KEYS[2]
local trgt = KEYS[3]
local cnst = ARGV[1]

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

    local key1 = src .. affix
    local key2 = trgt .. affix

    local opd = redis.call('lrange', key1, 0, -1)

    for ind = dim, 1, -1 do
        local result = opd[ind] * cnst
        redis.call('lpush', key2, result)
    end
    all = all - 1
end

return ret
