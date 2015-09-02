local data1 =  {
	[1] = "var",
	["var"] = {
		type = "directory",
		inode = 1,
		[1]="log",
		["log"] = {
			type = "directory",
			inode = 2,
			[1] = "file.log".
			["file.log"] = {
				type = "regular",
				
			},
		},
	},
}

local data2 = {
	name = "", -- the rootfs directory
	type = "directory",
	inode = 0,
	uid = 0, gid = 0,
	{
		name = "var",
		type = "directory"
		inode = 1,
		uid = 0, gid = 0,
		{
			name = "log",
			type = "directory"
			inode = 2,
			{
				name = "file.log",
				type = "regular",
				inode = 789,
				content = "",
			},
			{
				name = "file2.log",
				type = "regular",
				inode = 111,
				content = "aaaaaaaa",
			},
		},	
	},
}


local data 3
do
	local inodes = {
		[0] = {
			inode = 0,
			name = "", -- the rootfs directory
			type = "directory",
		},
		{
			inode = 123,
			name = "var",
			type = "directory",
		},
		{
			inode = 456,
			name = "log",
			type = "directory",
		},
		{
			inode = 789,
			name = "file.log",
			type = "regular",
		},
	}

	local by_inodes = { [123] = inodes[1], 	}
	local by_path = {
		["/var"] = inodes[1],
		["/var/log"] = inodes[2],
		["/var/log/file"] = inodes[3],
	}

	for i, item in ipairs(inodes) do by_inodes[item.inode] = item end

	data 3 = {
		inodes = inodes,
		by_inodes = by_inodes,
		by_path = by_path,
	}
end


