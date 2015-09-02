local M = {}

local internal = require "awall.internal"

funtion M.getDirectoryItems(dir)
	
end

-- https://love2d.org/wiki/love.filesystem
--
-- files = love.filesystem.enumerate( dir ) (x < 0.9.0)
-- files = love.filesystem.getDirectoryItems(dir) (0.9.0 <= x)
-- files = love.filesystem.getDirectoryItems(dir, callbackk) ( 0.9.0 <= x <= 0.9.1 < 0.10.0 )

-- love.filesystem.getWorkingDirectory()

funtion M.getWorkingDirectory()
	return internal.pwd()
end

return M
