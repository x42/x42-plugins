SUBDIRS = balance.lv2 convoLV2 nodelay.lv2 xfade.lv2 midifilter.lv2

all clean install uninstall: $(SUBDIRS)

$(SUBDIRS)::
	$(MAKE) -C $@ $(MAKECMDGOALS)

submodules:
	git submodule init
	git submodule update

reset:
	git submodule foreach git checkout master
	git submodule foreach git reset --ard

tagupdate:
	git submodule foreach git fetch
	git submodule foreach 'git merge $$(git describe --abbrev=0 --tags)'

update:
	git submodule foreach git pull
	-git commit $(SUBDIRS) -m "update submodules"

submodule_check:
	test -d .git && \
		git submodule status \
		| grep -q "^-" \
		&& $(MAKE) submodules

.PHONY: submodules update reset
