include VERSION.mk

name=add_reboot_icon_to_quicklaunch_bar
installer=$(name).exe


MAKENSIS = makensis
RM = rm -f
7Z = 7za
AUTOIT_TO_EXE = Aut2exe.exe

version=$(majorv).$(minorv).$(microv).$(qualifierv)

MAKENSIS_INSTALLER_SW =
MAKENSIS_FORCE_REBOOT_NOW_SW =
ifneq ($(findstring $(MAKEFLAGS),s),s)
ifndef V
	QUIET_MAKENSIS = @echo '   ' MAKENSIS $@;
	QUIET_7ZIP = @echo '   ' 7Z $@;
	QUIET_AUTOIT_TO_EXE = @echo '   ' AUTOIT $@;
	QUIET_GEN      = @echo '   ' GEN $@;
	MAKENSIS_INSTALLER_SW += /V2
	MAKENSIS_FORCE_REBOOT_NOW_SW += /V2
	export V
endif
endif

ifneq ($(findstring $(MAKEFLAGS),w),w)
	PRINT_DIR = --no-print-directory
endif

MAKENSIS_INSTALLER_SW += /Doutfile=$(installer)
MAKENSIS_INSTALLER_SW += /Dname="$(name)"
MAKENSIS_INSTALLER_SW += /Dversion=$(version)

$(installer): Makefile
$(installer): show_quick_launch_in_xp.exe
$(installer): force_reboot_now.exe
$(installer): PinItem\\PinItem.wsf
$(installer): PinItem\\PinItem.cmd
$(installer): $(name).nsi
	$(QUIET_MAKENSIS)$(MAKENSIS) $(MAKENSIS_INSTALLER_SW) $<

show_quick_launch_in_xp.exe: show_quick_launch_in_xp.au3
	$(QUIET_AUTOIT_TO_EXE)$(AUTOIT_TO_EXE) /in $< /out $@ /icon Windows-Restart.ico >/dev/null

PinItem\\PinItem.cmd PinItem\\PinItem.wsf:
	$(QUIET_7ZIP)$(7Z) x -y -oPinItem PinItem.zip >/dev/null

# http://technet.microsoft.com/en-us/solutionaccelerators/dd407791
# http://go.microsoft.com/fwlink/?LinkId=163307
ZTIUtility.vbs:
	wget -nc 'http://download.microsoft.com/download/b/3/a/b3a89fae-f7bf-4e7c-b208-223b991e9c30/MicrosoftDeploymentToolkit2012_x86.msi'
	msiexec /a MicrosoftDeploymentToolkit2012_x86.msi /qb TARGETDIR=c:\\windows\\temp\\MicrosoftDeploymentToolkit2012_x86
	cp c:/windows/temp/MicrosoftDeploymentToolkit2012_x86/Microsoft\ Deployment\ Toolkit/Templates/Distribution/Scripts/ZTIUtility.vbs .

# http://blogs.technet.com/b/deploymentguys/archive/2009/04/08/pin-items-to-the-start-menu-or-windows-7-taskbar-via-script.aspx
checkupdate_pinitem:
	wget http://blogs.technet.com/cfs-file.ashx/__key/communityserver-components-postattachments/00-03-22-36-81/PinItem.zip

MAKENSIS_FORCE_REBOOT_NOW_SW += /Dname=force_reboot_now
MAKENSIS_FORCE_REBOOT_NOW_SW += /Doutfile="$@"

force_reboot_now.exe: force_reboot_now.nsi
	$(QUIET_MAKENSIS)$(MAKENSIS) $(MAKENSIS_FORCE_REBOOT_NOW_SW) $<

upload: $(installer)
	-robocopy . //10.0.2.10/taylor.monacelli $(installer)

test: $(installer)
	cmd /c $(installer)

un: uninstall
uninstall: Uninstall.bat
	cmd /c Uninstall.bat

si: silent_install
silent_install: $(installer)
	cmd /c $(installer) /S

Uninstall.bat: Uninstall.bat Makefile
	echo '@echo on' > $@
	echo 'cd "%PROGRAMFILES%\Streambox\${name}"' >> $@
	echo '.\Uninstall.exe' >> $@

clean:
	$(RM) $(installer)
	$(RM) -r PinItem
	$(RM) MicrosoftDeploymentToolkit2012_x86.msi
	$(RM) force_reboot_now.exe
	$(RM) show_quick_launch_in_xp.exe
	$(RM) Uninstall.bat

.PHONY: clean
.PHONY: upload
.PHONY: test
.PHONY: un
.PHONY: uninstall
.PHONY: si
.PHONY: silent_install
.PHONY: test2
