name=add_reboot_icon_to_quicklaunch_bar
installer=$(name).exe

testip=10.0.2.224

include VERSION.mk
version=$(majorv).$(minorv).$(microv).$(qualifierv)

$(installer): \
	$(name).nsi \
	show_quick_launch_in_xp.exe \
	force_reboot_now.exe \
	PinItem\\PinItem.wsf \
	PinItem\\PinItem.cmd
	makensis \
		/Doutfile=$(installer) \
		/Dname="$(name)" \
		/Dversion=$(version) \
		$<

show_quick_launch_in_xp.exe: show_quick_launch_in_xp.au3
	Aut2exe.exe /in $< /out $@ /icon Windows-Restart.ico

PinItem\\PinItem.wsf:
	7za x -y -oPinItem PinItem.zip

# http://technet.microsoft.com/en-us/solutionaccelerators/dd407791
# http://go.microsoft.com/fwlink/?LinkId=163307
ZTIUtility.vbs:
	wget -nc 'http://download.microsoft.com/download/b/3/a/b3a89fae-f7bf-4e7c-b208-223b991e9c30/MicrosoftDeploymentToolkit2012_x86.msi'
	msiexec /a MicrosoftDeploymentToolkit2012_x86.msi /qb TARGETDIR=c:\\windows\\temp\\MicrosoftDeploymentToolkit2012_x86
	cp c:/windows/temp/MicrosoftDeploymentToolkit2012_x86/Microsoft\ Deployment\ Toolkit/Templates/Distribution/Scripts/ZTIUtility.vbs .

# http://blogs.technet.com/b/deploymentguys/archive/2009/04/08/pin-items-to-the-start-menu-or-windows-7-taskbar-via-script.aspx
checkupdate_pinitem:
	wget http://blogs.technet.com/cfs-file.ashx/__key/communityserver-components-postattachments/00-03-22-36-81/PinItem.zip

force_reboot_now.exe: force_reboot_now.nsi
	makensis \
		/Dname=force_reboot_now \
		/Doutfile="$@" \
		$<

upload: $(installer)
	-robocopy . //10.0.2.10/taylor.monacelli $(installer)
.PHONY: upload

test: $(installer)
	cmd /c $(installer)
.PHONY: test

un: uninstall
.PHONY: un
uninstall: Uninstall.bat
	cmd /c Uninstall.bat
.PHONY: uninstall

si: silent_install
.PHONY: si
silent_install: $(installer)
	cmd /c $(installer) /S
.PHONY: silent_install


Uninstall.bat: Uninstall.bat Makefile
	echo '@echo on' > $@
	echo 'cd "%PROGRAMFILES%\Streambox\${name}"' >> $@
	echo '.\Uninstall.exe' >> $@

test2: $(installer)
	-robocopy . //10.0.2.224/t $(installer)
.PHONY: test2


clean:
	rm -rf \
		$(installer) \
		PinItem \
		MicrosoftDeploymentToolkit2012_x86.msi \
		force_reboot_now.exe \
		show_quick_launch_in_xp.exe \
		Uninstall.bat

.PHONY: clean
