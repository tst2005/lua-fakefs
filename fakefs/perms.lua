local M = {}


local math = require "math"
local floor = math.floor

local function num2str(n)
	n = floor(n)
	if n < 0 or n > 512 then
		return nil
	end
	local a = floor(n/64) % 8
	local b = floor(n/8) % 8
	local c = floor(n) % 8
	if a % 8 ~= a or b % 8 ~= b or c % 8 ~= c then
		return nil
	end
	local conv = {
		[0] = "---",
		[1] = "--x",
		[2] = "-w-",
		[3] = "-wx",
		[4] = "r--",
		[5] = "r-x",
		[6] = "rw-",
		[7] = "rwx",
	}
	return conv[a]..conv[b]..conv[c]
end
--for i = -1,512,1 do print( i, num2str(i) ) end
local fast = {}
for i = 0,tonumber(777, 8),1 do
	local str = num2str(i)
	fast[str] = i
	fast[i] = str
end

local function conv(perm)
	if type(perm) == "string" and perm:gsub("[rwx-]","") == "" or type(perm) == "number" then
		return fast[perm]
	end
	return nil
end

--[[
for i = 0,tonumber(777, 8)+1 ,1 do
	print( i, conv(i), conv(conv(i)) )
end
]]--

local dec2oct = function(d)
	return ("%o"):format(d)
end

local function newmode(n)
	return setmetatable({}, {
		__tonumber = function() return dec2oct(n) end,
		__tostring = function() return conv(n) end,
	})
end


local function tonumber2(o, base)
	local mt = getmetatable(o)
	if mt and mt.__tonumber then
		return mt.__tonumber(o, base)
	end
	return tonumber(o, base)
end

-- see http://lua-users.org/lists/lua-l/2009-02/msg00072.html
local a = newmode( tonumber(777, 8) )
print( type(a), tonumber2 and tonumber2(a), tostring(a) )

return M
