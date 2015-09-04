local M = {}

local internal = require "fakefs.internal"
local stat = internal.stat

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

local convert_lfs2raw = {
	mode = "type",
	access = "atime",
	modification = "mtime",
	change = "ctime",
	permissions = "mod",
}

local function lfs_stat(path, lfs_aname)
	if lfs_aname then
		local aname = convert_lfs2raw[aname]
		local rawinfo = stat(path, aname)
		local k, v = convert_raw2lfs[aname](aname, rawinfo)
		return v
 	end
	local rawinfo = stat(path)
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

function M.attributes(filepath, aname)
	-- aname is optional
	local inode = filepath2inode(filepath)
	local info = lfs_stat(inode, aname)
	-- dev
	-- ino
	-- mode = file, directory, link, socket, named pipe, char device, block device or other 
	-- nlink
	-- uid
	-- gid
	-- rdev
	-- access
	-- modification
	-- change
	-- size
	-- blocks
	-- blksize
	return info
end


function M.chdir(path)
	internal.cd(path)
end


function M.currentdir()
	return internal.pwd()
end

-- lfs.link (old, new[, symlink])
-- lfs.mkdir (dirname)
-- lfs.rmdir (dirname)
-- lfs.setmode (file, mode)
-- lfs.symlinkattributes (filepath [, aname])
-- lfs.touch (filepath [, atime [, mtime]])

-- lfs.lock (filehandle, mode[, start[, length]])
-- lfs.lock_dir(path, [seconds_stale])
-- lfs.unlock (filehandle[, start[, length]])

return M
