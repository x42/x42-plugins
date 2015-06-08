x42-plugins
===========

Collection of LV2 plugins - git externals - ready for packaging.
see plugin.list for an index of included plugins.

Releases
--------

The repository consists of various git-submodules, a release tar.xz
can be created by running `make dist` in a git clone of this repository.
This will update all submodules to their latest *tagged* version.

For convenience the latest version of this plugin bundle is automatically
generated at http://gareus.org/misc/x42-plugins.php (the URL is suitable
for automatic watching using uscan).

Install
-------

This repository is intended for distribution packagers, not end-users.
It has been adoped by a wide variety of GNU/Linux distributions already.
Please check your distribution.

Custom Debian Package
---------------------

```
./build-deb.sh -us -uc
```

Screenshots
-----------

![screenshot](https://raw.github.com/x42/meters.lv2/master/doc/LV2ebur128.png "EBU R128 Meter GUI")
![screenshot](https://raw.github.com/x42/meters.lv2/master/doc/LV2meters.png "Various Needle Meters in Ardour")
![screenshot](https://raw.github.com/x42/meters.lv2/master/doc/spectr_and_goni.png "Spectum Analyzer and Stereo Phase Scope")
![screenshot](https://raw.github.com/x42/tuna.lv2/master/img/tuna2.png "Tuna with Spectrum display")
![screenshot](https://raw.github.com/x42/sisco.lv2/master/img/sisco4.png "Four Channel Variant")
![screenshot](https://raw.github.com/x42/balance.lv2/master/doc/screenshot_ui.png "Built-in openGL GUI")
![screenshot](https://raw.github.com/x42/xfade.lv2/master/screenshot_ardour.png "Ardour3 and xfade.lv2")
![screenshot](https://raw.github.com/x42/fil4.lv2/master/img/fil4_v2.png "Parametric EQ")
