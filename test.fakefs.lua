local internal = require "fakefs.internal"

internal.init() -- create the rootdir

for _, modname in ipairs{ "io", "fakefs.internal" } do
	local io = require(modname)
	print("- try with "..modname..":")

	local fd = io.open("a", "w")
	fd:write("hello world\n")
	fd:close()

	local fd = io.open("a", "r")
	io.stdout:write( fd:read("*all") )
	fd:close()
end



