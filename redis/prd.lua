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

while all do
    all = all - 1

end
