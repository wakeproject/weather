local cnfg = KEYS[1]
local src1 = KEYS[2]
local src2 = KEYS[3]
local trgt = KEYS[4]

local base = redis.call('hget', cnfg, 'base')
local dim  = redis.call('hget', cnfg, 'dim')
local ord  = redis.call('hget', cnfg, 'ord')

local lyt  = {}
local all  = 1
for idx = 1, dim do
    lyt[idx] = redis.call('hget', cnfg, 'lyt:' .. idx)
    all = all * lyt[idx]
end

while all do
    all = all - 1

end
