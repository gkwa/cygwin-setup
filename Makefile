basename=cygwinsetup

include VERSION.mk

installer=$(basename)_v$(version).exe
i=$(installer)


$(i): \
	$(basename).nsi \
	bginfo.bgi \
	cygwinsetup.nsi \
	home-administrator.bat \
	home-pull.sh \
	installed.db \
	Makefile
	makensis $(basename).nsi

upload: $(i)
	-robocopy . //10.0.2.10/Development/tools /w:1 /r:1 $(i)
	-robocopy . //10.0.2.10/taylor.monacelli /w:1 /r:1 $(i)

run: $(i)
	cmd /c $(i)

clean: 
	-rm \
		$(i)