local stat = require"posix".stat
local function show(t)
	for k,v in pairs(t) do
		print(k,v)
	end
end

show(stat("."))

