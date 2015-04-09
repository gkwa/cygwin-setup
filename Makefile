basename=cygwinsetup

RM = rm -f


include VERSION.mk

branch_name := $(shell sh -c 'git rev-parse --abbrev-ref HEAD')
installer=$(basename)_v$(version).exe
ifneq ($(branch_name),master)
	installer=$(basename)_$(branch_name)_v$(version).exe
endif

# Must use unicode since it supports 2048 byte strings
# fixme: a better method is to write out smaller strings to batch file
MAKENSIS=c:/Program\ Files/NSIS/Unicode/makensis.exe

VPATH=add_reboot_icon_to_quicklaunch_bar

changelog=$(installer)-changelog.txt

MAKENSIS_SW =
ifneq ($(findstring $(MAKEFLAGS),s),s)
ifndef V
	QUIET_MAKE = @echo '   ' MAKE $@;
	QUIET_PERL = @echo '   ' TINYPERL $@;
	QUIET_MAKENSIS = @echo '   ' MAKENSIS $@;
	QUIET_GEN      = @echo '   ' GEN $@;
	MAKENSIS_SW += /V2
	export V
endif
endif

ifneq ($(findstring $(MAKEFLAGS),w),w)
	PRINT_DIR = --no-print-directory
endif

MAKENSIS_SW += /Doutfile=$(installer)

dropbox: ~/ephemeral/$(installer)
dropbox: ~/ephemeral/$(changelog)

~/ephemeral/$(installer): $(installer)
	cp $< $@
~/ephemeral/$(changelog): $(changelog)
	cp $< $@

$(installer): VERSION.mk
$(installer): sshd-auto-setup-controller.cmd
$(installer): sshd-auto-setup.sh
$(installer): configure_fstab.exe
$(installer): bginfo.bgi
$(installer): cygwinsetup.nsi
$(installer): installed.db
$(installer): add_reboot_icon_to_quicklaunch_bar.exe
$(installer): Makefile
$(installer): $(basename).nsi
	$(QUIET_MAKENSIS)$(MAKENSIS) $(MAKENSIS_SW) $<

configure_fstab.exe: configure_fstab.pl
	$(QUIET_PERL)tiny_perl_installer/tinyperl.exe -bin configure_fstab.pl $@ >/dev/null

add_reboot_icon_to_quicklaunch_bar.exe:
	$(QUIET_MAKE)$(MAKE) $(PRINT_DIR) -C add_reboot_icon_to_quicklaunch_bar installer=$@

changelog: $(changelog)
$(changelog):
	git log -m --abbrev-commit --pretty=tformat:'%h %ad %s' --date=short >$@
	unix2dos $@

fstab: test_fstab
test_fstab:
	perl -w configure_fstab.pl t/t1/fstab

tls: test_links_setup
test_links_setup:
	@perl -w links_setup.pl

test_batchfile_rootdir_replace:
	$(MAKE) -C t/t2 t

upload: $(installer) $(changelog)
	-robocopy . //10.0.2.10/Development/tools /w:1 /r:1 $^
	-robocopy . //10.0.2.10/users/taylor /w:1 /r:1 $^

run: $(installer)
	cmd /c $(installer)

clean:
	$(QUIET_MAKE)$(MAKE) -C add_reboot_icon_to_quicklaunch_bar \
		installer=add_reboot_icon_to_quicklaunch_bar.exe clean
	$(QUIET_MAKE)$(MAKE) -C t/t2 clean
	$(RM) configure_fstab.exe
	$(RM) $(installer)
	$(RM) $(changelog)
	$(RM) cygwinsetup_v*.exe-changelog.txt
	$(RM) cygwinsetup_v*.exe

.PHONY: test_fstab fstab
