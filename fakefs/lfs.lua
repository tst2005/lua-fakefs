local M = {}

local internal = require "fakefs.internal"
local filepath2inode = internal.filepath2inode
local inode_info = internal.lfs_inode_info

function M.attributes(filepath, aname)
	-- aname is optional
	local inode = filepath2inode(filepath)
	local info = inode_info(inode, aname)
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
