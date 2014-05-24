#!/usr/bin/make

-include gitversion.mak
export RW=../robtk/

###############################################################################

VERSION ?=$(shell date +%Y%m%d)
SUBDIRS = balance.lv2 convoLV2 nodelay.lv2 xfade.lv2 \
          midifilter.lv2 meters.lv2 sisco.lv2 tuna.lv2 \
          onsettrigger.lv2 mixtri.lv2

all clean install uninstall: submodule_check $(SUBDIRS)

$(SUBDIRS)::
	$(MAKE) -C $@ $(MAKECMDGOALS)

###############################################################################

dist:
	$(MAKE) -f Makefile.git dist

submodule_check:
	-test -d .git -a .gitmodules -a -f Makefile.git && $(MAKE) -f Makefile.git submodule_check

submodules:
	-test -d .git -a .gitmodules -a -f Makefile.git && $(MAKE) -f Makefile.git submodules

tagupdate:
	-test -d .git -a .gitmodules -a -f Makefile.git && $(MAKE) -f Makefile.git tagupdate

.PHONY: dist submodule_check submodules tagupdate
