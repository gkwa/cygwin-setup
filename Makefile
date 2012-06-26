basename=cygwinsetup

include VERSION.mk

installer=$(basename)_v$(version).exe
i=$(installer)

# Must use unicode since it supports 2048 byte strings
# fixme: a better method is to write out smaller strings to batch file
MAKENSIS=c:/Program\ Files/NSIS/Unicode/makensis.exe

VPATH=add_reboot_icon_to_quicklaunch_bar

changelog=$(i)-changelog.txt

$(i): \
	$(basename).nsi \
	bginfo.bgi \
	cygwinsetup.nsi \
	home-pull.sh \
	installed.db \
	add_reboot_icon_to_quicklaunch_bar.exe \
	Makefile
	$(MAKENSIS) \
		/Doutfile=$(installer) \
		$(basename).nsi

add_reboot_icon_to_quicklaunch_bar.exe:
	$(MAKE) -C add_reboot_icon_to_quicklaunch_bar installer=add_reboot_icon_to_quicklaunch_bar.exe

changelog: $(changelog)
$(changelog):
	git log --abbrev-commit --stat > $@
	unix2dos $@
.PHONY: $(changelog)


upload: $(i) $(changelog)
	-robocopy . //10.0.2.10/Development/tools /w:1 /r:1 $(i) $(changelog)
	-robocopy . //10.0.2.10/taylor.monacelli /w:1 /r:1 $(i) $(changelog)

run: $(i)
	cmd /c $(i)

clean:
	-rm -f \
		$(installer) \
		$(i) \
		$(changelog)
	$(MAKE) -C add_reboot_icon_to_quicklaunch_bar installer=add_reboot_icon_to_quicklaunch_bar.exe clean
