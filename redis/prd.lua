local cnfg = KEYS[1]
local src  = KEYS[2]
local trgt = KEYS[3]
local cnst = ARGV[1]

local base = redis.call('hget', cnfg, 'base')
local dim  = redis.call('hget', cnfg, 'dim')
local ord  = redis.call('hget', cnfg, 'ord')

local lyt  = {}
local all  = 1
for idx = 1, dim do
    lyt[idx] = redis.call('hget', cnfg, 'lyt:' .. idx)
    all = all * lyt[idx]
end

while all != 0 do
    total = all
    affix = ''
    for idx = dim, 1, -1 do
        reminder = total % lyt[idx]
        total = total - reminder - lyt[idx]
        if reminder == 0
            reminder = lyt[idx]
        end
        affix = ':' .. reminder .. affix

        key1 = src1 .. affix
        key2 = trgt .. affix

        opd1 = redis.call('lrange', key1, 0, -1)

        for ind = dim, 1, -1 do
            result = opd1[ind] * cnst
            redis.call('lpush', key2, result)
        end
    end
    all = all - 1
end
