# Bloated Makefile to make new releases of pisg

all: release

# Ugly hack to get the version number from Pisg.pm
VERSION = $(shell grep "version =>" modules/Pisg.pm | sed 's/.*\"\(.*\)\".*/\1/')

DIRNAME = pisg-$(VERSION)

TARFILE = pisg-$(VERSION).tar.gz
ZIPFILE = pisg-$(VERSION).zip

FILES = pisg \
	 COPYING \
	 README \
	 pisg.cfg \
	 lang.txt

DOCS = docs/FORMATS \
	 docs/Changelog \
	 docs/CREDITS \
	 docs/pisg-doc.html \
	 docs/pisg-doc.txt \
	 docs/pisg-doc.xml \
	 docs/pisg.1 \

DEVDOCS = docs/dev/API

GFX = gfx/green-h.png \
	 gfx/green-v.png \
	 gfx/blue-h.png \
	 gfx/blue-v.png \
	 gfx/yellow-h.png \
	 gfx/yellow-v.png \
	 gfx/red-h.png \
	 gfx/red-v.png \

SCRIPTS = scripts/crontab \
	   scripts/dropegg.pl \
	   scripts/egg2mirc.awk \
	   scripts/eggdrop-pisg.tcl \
	   scripts/mirc2egg.sed \
	   scripts/sirc-timestamp.pl \
	   scripts/windows-ftp-upload.txt

ADDALIAS = scripts/addalias/addalias.pl \
	    scripts/addalias/README

MODULESDIR = modules

MAIN_MODULE = $(MODULESDIR)/Pisg.pm

PISG_MODULES = $(MODULESDIR)/Pisg/Common.pm \
	       $(MODULESDIR)/Pisg/HTMLGenerator.pm

PARSER_MODULES = $(MODULESDIR)/Pisg/Parser/Logfile.pm

FORMAT_MODULES = $(MODULESDIR)/Pisg/Parser/Format/axur.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/bxlog.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/bobot.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/blootbot.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/dancer.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/dircproxy.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/DCpp.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/eggdrop.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/energymech.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/grufti.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/hydra.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/ircle.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/infobot.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/irssi.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/ircII.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/javabot.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/kvirc.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/lulubot.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/oer.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/mbot.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/mIRC.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/mIRC6.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/mIRC6hack.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/muh.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/muh2.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/moobot.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/perlbot.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/pircbot.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/psybnc.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/sirc.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/supy.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/virc98.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/Vision.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/Trillian.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/Template.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/RacBot.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/rbot.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/xchat.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/winbot.pm \
		 $(MODULESDIR)/Pisg/Parser/Format/zcbot.pm \

docs:
	$(MAKE) -C docs

release: docs
	mkdir -p newrelease

	mkdir $(DIRNAME)
	cp $(FILES) $(DIRNAME)

	mkdir $(DIRNAME)/scripts
	cp $(SCRIPTS) $(DIRNAME)/scripts

	mkdir $(DIRNAME)/gfx
	cp $(GFX) $(DIRNAME)/gfx

	mkdir $(DIRNAME)/docs
	cp -r $(DOCS) $(DIRNAME)/docs

	mkdir $(DIRNAME)/layout
	cp layout/*.css $(DIRNAME)/layout

	mkdir $(DIRNAME)/docs/dev
	cp $(DEVDOCS) $(DIRNAME)/docs/dev

	mkdir $(DIRNAME)/scripts/addalias
	cp $(ADDALIAS) $(DIRNAME)/scripts/addalias

	mkdir $(DIRNAME)/$(MODULESDIR)

	mkdir $(DIRNAME)/$(MODULESDIR)/Pisg
	mkdir $(DIRNAME)/$(MODULESDIR)/Pisg/Parser
	mkdir $(DIRNAME)/$(MODULESDIR)/Pisg/Parser/Format
	cp $(MAIN_MODULE) $(DIRNAME)/$(MODULESDIR)/
	cp $(PISG_MODULES) $(DIRNAME)/$(MODULESDIR)/Pisg/
	cp $(PARSER_MODULES) $(DIRNAME)/$(MODULESDIR)/Pisg/Parser
	cp $(FORMAT_MODULES) $(DIRNAME)/$(MODULESDIR)/Pisg/Parser/Format

	tar zcfv newrelease/$(TARFILE) $(DIRNAME)
	zip -r pisg $(DIRNAME)
	mv pisg.zip newrelease/$(ZIPFILE)
	mv $(DIRNAME) newrelease

clean:
	cd docs && make clean
	rm -rf newrelease/
	rm -rf $(DIRNAME)

.PHONY: all release docs clean
