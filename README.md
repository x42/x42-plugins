x42-plugins
===========

Collection of LV2 plugins - git externals - ready for packaging.
see plugin.list for the list of included plugins.

Debian Package
--------------

```
./build-deb.sh -us -uc
```

Installation on non-debian systems
----------------------------------

First time:

```
make submodules
make 
sudo make install
```

any later time:

```
make update
make 
sudo make install
```
