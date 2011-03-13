basename=cygwinsetup

$(basename).exe: $(basename).nsi
	makensis $(basename).nsi

run: $(basename).exe
	cmd /c $(basename).exe

test: $(basename).exe
	-cmd /c start robocopy . //10.0.2.102/c$$ $(basename).exe /w:1 /r:3
	-cmd /c start robocopy . //10.0.2.185/c$$ $(basename).exe /w:1 /r:3

clean : 
	-rm $(basename).exe