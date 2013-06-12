SUBDIRS = balance.lv2 convoLV2 nodelay.lv2 xfade.lv2 midifilter.lv2
TARNAME=x42-plugins
VERSION=$(shell git show -s --format="%ci" HEAD | cut -d' ' -f 1)-$(shell git describe --always)

TARF=$(TARNAME)_$(VERSION).orig.tar

all clean install uninstall: $(SUBDIRS)

$(SUBDIRS)::
	$(MAKE) -C $@ $(MAKECMDGOALS)


submodules:
	git submodule init
	git submodule update

reset:
	git submodule foreach git checkout master
	git submodule foreach git reset -hard

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
	git archive --prefix=$(TARNAME)-$(VERSION)/ --format tar HEAD > $(TARF)
	TEMPFILE=$(shell mktemp); \
	git submodule foreach \
		"git archive --prefix=$(TARNAME)-$(VERSION)/"'$$(basename $$(pwd))/'" --format tar HEAD > $${TEMPFILE}; \
		tar --concatenate -f ../$(TARF) $${TEMPFILE}"; \
		rm $${TEMPFILE}
	rm -f $(TARF).xz
	xz $(TARF)

.PHONY: submodules update reset dist
