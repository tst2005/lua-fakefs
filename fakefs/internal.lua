local M = {}

-- the catalog
local tree = {}
local fdata = {}
local PWD

local inodecnt = 0
local function newinode()
	inodecnt = inodecnt +1
	return inodecnt
end

function M.init()
	inodecnt = 1
	local one = {
		name = "",
		type = "d",
		uid = 0, gid = 0,
		ino = newinode(),
	}
	tree["/"] = one
	PWD = "" -- cd /
end

local function cleanpath(path)
	local full = path:sub(1,1) == "/"
	local target = path:gsub("[/]+$", ""):gsub("[/]+", "/"):gsub("/./", "/")
	-- do stuff about a/z/../b/c -> a/b/c
	if full and target == "" then
		return "/"
	end
	return target
end

local function abspath(path)
	if path:sub(1,1) == "/" then
		return path
	end
	return PWD .. "/" .. path
end

local function stat(path, aname)
	local target = cleanpath(path)
	local found = tree[target]
	if aname then
		return found[aname]
	end
	return found
end

local fileclass = {}
function fileclass:read()
	assert(self.opened)
	assert(self.readable)
	local data = fdata[self.obj]
	return data
end
function fileclass:write(data)
	assert(self.opened)
	assert(self.writable)
	local obj = self.obj
	fdata[obj] = (fdata[obj] or "") .. data

	return self
end
function fileclass:seek(...)
	assert(self.opened)
	error("not implemented yet", 2)
end

function fileclass:close()
	if not self.opened then return false end
	-- sync ?
	self.opened = nil
	return true
end


function M.open(path, mode)
	mode = mode or "r"
	path = cleanpath(path)
	local found = tree[path]

	local fd = setmetatable({}, {__index = fileclass})
	fd.readable = false
	fd.writable = false
	fd.opened = true

	if not found then
		if case == "r" then
			return nil, "no such file"
		end

		found = {
			type = "f",
			uid = 0, gid = 0,
			ino = newinode(),
		}
		tree[path] = found
	end
	fd.obj = found
	if mode == "r" then
		fd.readable = true
	elseif mode == "w" then
		fd.writable = true
	end
	return fd
end


function M.mkdir(path, mode)
	mode = mode or 511 -- 777
end

function M.mkfifo(path, mode)
	mode = mode or 511 -- 777
end

function M.touch(path, mode, mtime) -- mkfile
end


function M.link(...) -- create hardlink/symlink
end

function M.chmod(path, mode)
end

function M.umask(mode) -- for file creation
end

--[[
 access (path[, mode="f"])
    Check real user's permissions for a file.
    Parameters:

        path string file to act on
        mode string can contain 'r','w','x' and 'f' (default "f")

    Returns:
        int 0, if successful 
]]--


function M.chdir(subpath)
	PWD = subpath
end

-- chown (path, uid, gid) 
-- open ?
-- close(fd)
-- fdatasync
-- fsync

function M.pwd(path)
	return PWD and PWD == "" and "/" or PWD or "/"
end

function M.stat(path) -- info about file/dir (follow the symlink target)
end

function M.lstat(path) -- info about file/dir or the symlink it-self
end

function M.readlink(path) -- return the symlink target
end

function M.realpath(path)
end

M.stdout = require"io".stdout
M.stdin  = require"io".stdin
M.stderr = require"io".stderr

return M
