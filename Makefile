basename=cygwinsetup

$(basename).exe: $(basename).nsi
	makensis $(basename).nsi

run: $(basename).exe
	cmd /c $(basename).exe

test: $(basename).exe
	-cmd /c start /min robocopy . //10.0.2.102/c$$ $(basename).exe /w:3 /r:100
	-cmd /c start /min robocopy . //10.0.2.185/c$$ $(basename).exe /w:3 /r:100
	-cmd /c start /min robocopy . //10.0.2.135/c$$ $(basename).exe /w:3 /r:100
	-cmd /c start /min robocopy . //10.0.2.10/taylor.monacelli/trash $(basename).exe /w:3 /r:100
	-cmd /c start /min robocopy . //10.0.2.166/c$$ $(basename).exe /w:3 /r:100
	-cmd /c start /min robocopy . //10.0.2.100/c$$ $(basename).exe /w:3 /r:100

clean : 
	-rm $(basename).exe