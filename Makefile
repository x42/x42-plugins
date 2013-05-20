SUBDIRS = balance.lv2 convoLV2 nodelay.lv2 xfade.lv2

all clean install uninstall: $(SUBDIRS)

$(SUBDIRS)::
	$(MAKE) -C $@ $(MAKECMDGOALS)


submodules:
	git submodule init
	git submodule update

update:
	git submodule foreach git pull
	-git commit $(SUBDIRS) -m "update submodules"

.PHONY: submodules update
