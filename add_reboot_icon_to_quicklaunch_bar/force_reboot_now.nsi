Name "${name}"
OutFile "${outfile}"

Function .onInit
	SetSilent silent
FunctionEnd

Section section1 section_section1
  nsExec::ExecToStack '".\psshutdown.exe" -t 1 -r -f'
SectionEnd

# Emacs vars
# Local Variables: ***
# comment-column:0 ***
# tab-width: 2 ***
# comment-start:"# " ***
# End: ***
