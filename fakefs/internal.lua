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
		mod = "rw-rw-rw-"
	},
}

local by_path = {
	["/"] = false,
	["/var"] = inodes[1],
	["/var/log"] = inodes[2],
	["/var/log/file"] = inodes[3],
}
]]--

-- the catalog
local tree = {}

-- inodes
local inodes

--[[
local by_inodes = { [123] = inodes[1], }

local function make_indexes()
	for i, item in ipairs(inodes) do by_inodes[assert(item.ino)] = item end
end
]]--


local inodecnt
local function newinode()
	inodecnt = inodecntinodecnt +1
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
	local found = by_path[target]
	if not found then
		return nil
	end
	return found.inode
end
M.filepath2inode = filepath2inode
]]--

local function inode_info(inode, aname)
	local target = cleanpath(filepath)
	local found = by_path[target]
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


function M.mkdir(path)
	return 
end

function M.mkfile(path)

end

function M.cd(subpath)
	PWD = subpath
end

function M.pwd(path)
	return PWD and PWD == "" and "/" or PWD or "/"
end

return M
