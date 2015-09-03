local M = {}

--[[
local inodes = {
	[0] = {
		ino = 0,
		name = "", -- the rootfs directory
		type = "d",
		uid = 0, gid = 0,
	},
	{
		ino = 123,
		name = "var",
		type = "d",
		uid = 0, gid = 0,
	},
	{
		ino = 456,
		name = "log",
		type = "d",
		uid = 0, gid = 0,
	},
	{
		ino = 789,
		name = "file.log",
		type = "f",
		uid = 0, gid = 0,
		mod = "rw-rw-rw-",
	},
}

local tree = {
	["/"] = false,
	["/var"] = inodes[1],
	["/var/log"] = inodes[2],
	["/var/log/file"] = inodes[3],
}
local fdata = {
	inodes[3] = "hello world\n",
}
]]--

local fdata = {}

--local inodes
--local by_inodes = { [123] = inodes[1], }
--local function make_indexes()
--	for i, item in ipairs(inodes) do by_inodes[assert(item.ino)] = item end
--end


-- the catalog
local tree = {}

local inodecnt = 0
local function newinode()
	inodecnt = inodecnt +1
	return inodecnt
end

--local function insertpath(full_path, obj)
--	by_path[full_path] = obj
--end

local PWD

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

--[[
local function filepath2inode(filepath)
	local target = cleanpath(filepath)
	local found = tree[target]
	if not found then
		return nil
	end
	return found.inode
end
M.filepath2inode = filepath2inode
]]--

local function inode_info(inode, aname)
	local target = cleanpath(filepath)
	local found = tree[target]
	if aname then
		return found[aname]
	end
	return found
end

local convert_raw2posix = {
	type = function(k,v)
		local convert = {
			f = "file",
			d = "directory",
			l = "link",
			s = "socket",
			p = "named pipe",
			c = "char device",
			b = "block device",
		}
		return "type", convert[v] or "other"
	end,
	mod = function(k, v) return "mode", v end, -- rw-rw-rw-
--	dev / ino / uid / gid / mtime / ctime / atime / size / nlink
}


local convert_raw2lfs = {
	type = function(k,v)
		local convert = {
			f = "file",
			d = "directory",
			l = "link",
			s = "socket",
			p = "named pipe",
			c = "char device",
			b = "block device",
		}
		return "mode", convert[v] or "other"
	end,
	atime = function(k, v) return "access", v end,
	mtime = function(k, v) return "modification", v end,
	ctime = function(k, v) return "change", v end,
	mod   = function(k, v) return "permissions", v end,
--	dev / ino / nlink / uid / gid / rdev / size / blocks / blksize
}

local function lfs_inode_info(inode, aname)
	local rawinfo = inode_info(inode, aname)
	local lfsinfo = {}
	for k,v in pairs(rawinfo) do
		local k2, v2 = k, v
		if convert_raw2lfs[k] then
			k2, v2 = convert_raw2lfs[k](k, v)
		else
			k2, v2 = k, v
		end
	end
	return lfsinfo
end
M.lfs_inode_info = lfs_inode_info


function M.mkdir(path, mode)
	mode = mode or 511
	
	return 
end

function M.mkfifo(path, mode)
	mode = mode or 511
end

function M.touch(path, mode, mtime) -- mkfile
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


--M.tree = tree
--M.data = fdata

return M
