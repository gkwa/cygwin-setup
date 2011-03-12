basename=cygwinsetup

$(basename) : $(basename).nsi
	makensis $(basename).nsi

$(basename).exe : $(basename).nsi
	makensis $(basename).nsi

run: $(basename).exe
	cmd /c $(basename).exe

clean : 
	rm $(basename).exe