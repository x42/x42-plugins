#!/usr/bin/make

VERSION ?=$(shell date +%Y%m%d)
SUBDIRS = balance.lv2 convoLV2 nodelay.lv2 xfade.lv2 midifilter.lv2

all clean install uninstall: submodule_check $(SUBDIRS)

$(SUBDIRS)::
	$(MAKE) -C $@ $(MAKECMDGOALS)

###############################################################################
TARNAME = x42-plugins
TARF=$(TARNAME)_$(VERSION).orig.tar

submodules:
	git submodule init
	git submodule update

tagupdate:
	git submodule foreach git fetch
	git submodule foreach 'git reset --hard $$(git describe --abbrev=0 --tags)'
	-git commit $(SUBDIRS) -m "update submodules" \
		-m "$(shell git submodule foreach git describe --tags | tr "\n" " " | sed 's/Entering /@ -  /g' | tr "@" "\n")"

submodule_check:
	-test -d .git && \
		git submodule status \
		| grep -q "^-" \
		&& $(MAKE) submodules

dist: submodule_check tagupdate
	$(eval VERSION := $(shell git submodule --quiet foreach git show -s --format="%ci" HEAD | cut -d' ' -f 1 | sed 's/-//g' | sort -nr | head -n 1))
	git archive --prefix=$(TARNAME)-$(VERSION)/ --format tar HEAD > $(TARF)
	$(eval TEMPFILE := $(shell mktemp))
	git submodule foreach \
		"git archive --prefix=$(TARNAME)-$(VERSION)/"'$$(basename $$(pwd))/'" --format tar HEAD > $(TEMPFILE); \
		tar --concatenate -f ../$(TARF) $(TEMPFILE)";
	rm $(TEMPFILE)
	rm -f $(TARF).xz
	xz $(TARF)

.PHONY: submodules update reset dist
