local M = {}

M.posix = require "fakefs.posix"
M.lfs = require "fakefs.lfs"
M.love = {}
M.love.filesystem = require "fakefs.love.filesystem"

return M
