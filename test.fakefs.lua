local internal = require "fakefs.internal"

internal.init() -- create the rootdir

for _, modname in ipairs{ "io", "fakefs.internal" } do
	local io = require(modname)
	print("- try with "..modname..":")

	local fd = io.open("a", "w")
	fd:write("hello")
	fd:write(" world")
	fd:close()

	local fd = io.open("a", "r")
	if fd:read("*all") == "hello world" then
		print("ok")
	else
		print("fail")
	end
	fd:close()
end

os.execute("rm -- a")

