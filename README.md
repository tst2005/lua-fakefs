Lua Fake FS
===========

Abstraction FS Layer to fake access to FileSystem
The virtual FS is kept in memory.


Application
-----------

* Be able to embedding file and content inside all-in-one script (see lua-aio, see awall)
* See lua-isolation, usefull to implement io.open withtout access to the real FS>
* Love2d: be able to have a full read/writable FS (but the realone)

Possible futur use
------------------

* emulate lfs with posix ?
* emulate posix with lfs ?

License
=======

MIT
