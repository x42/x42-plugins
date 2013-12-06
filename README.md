x42-plugins
===========

Collection of LV2 plugins - git externals - ready for packaging.
see plugin.list for and index of included plugins.

Releases
--------

The repository consists of various git-submodules, a release tar.xz
can be created by running `make dist` in a git clone of this repository.
This will update all submodules to their latest *tagged* version.

For convenience the latest version of this plugin bundle is automatically
generated at http://gareus.org/misc/x42-plugins.php (the URL is suitable
for automatic watching using uscan).


Custom Debian Package
---------------------

```
./build-deb.sh -us -uc
```
