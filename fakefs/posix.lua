local M = {}

-- fake like posix -----------------------------------------------------------

-- local files = posix.dir(dir)
-- table.sort(files)
-- for _, f in ipairs(files) do end

-- iter, dir_obj = lfs.dir(path)
function M.dir(dir) -- return a i-table with relative file/dir names

end

--local full_name = string.format('%s/%s', directory, name)
--local info = assert(posix.stat(full_name))
function M.stat(full_name)
	local info = {}

	info.type = 'link'
	info.type = 'regular'
	info.type = 'directory'

end

--[[ /etc/passwd
uid     0
ctime   1435753742
ino     793598
atime   1441197001
mode    rw-r--r--
nlink   1
mtime   1435753742
type    regular
size    2180
gid     0
dev     2049
]]-- ls = -rw-r--r--

--[[ "."
uid     1000
ctime   1441212776
ino     24379408
atime   1441202421
mode    rwxr-x---
nlink   163         (nombre de "element contenu")
mtime   1441212776
type    directory
size    24576
gid     1000
dev     64769
]]-- ls = drwxr-x--

--[[ for k,v in pairs(require"posix".stat("/dev/fd/0")) do print(k,("%q"):format(v)) end
ctime   "1441213902"
gid     "1000"
atime   "1441213902"
mode    "rwx------"
ino     "182456963"
mtime   "1441213902"
nlink   "1"
size    "64"
uid     "1000"
type    "link"
dev     "3"
]]-- ls = lrwx-----

--[[ for k,v in pairs(require"posix".stat("/dev/null")) do print(k,("%q"):format(v)) end
ctime   "1416911989"
gid     "0"
atime   "1416911989"
mode    "rw-rw-rw-"
ino     "1029"
mtime   "1416911989"
nlink   "1"
size    "0"
uid     "0"
type    "character device"
dev     "5"
]]-- ls = crw-rw-rw

--[[  for k,v in pairs(require"posix".stat("/dev/xconsole") or {}) do print(k,("%q"):format(v)) end
ctime   "1441176121"
gid     "4"
atime   "1416912016"
mode    "rw-r-----"
ino     "3993"
mtime   "1441176121"
nlink   "1"
size    "0"
uid     "0"
type    "fifo"
dev     "5"
]]-- ls = prw-r----

--[[ for k,v in pairs(require"posix".stat("/run/acpid.socket") or {}) do print(k,("%q"):format(v)) end
ctime   "1416912017"
gid     "0"
atime   "1416912017"
mode    "rw-rw-rw-"
ino     "2974"
mtime   "1416912017"
nlink   "1"
size    "0"
uid     "0"
type    "socket"
dev     "11"
]]-- ls = srw-rw-rw-

--[[ si existe pas -> nil ]]--

return M
