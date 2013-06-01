# http://stackoverflow.com/questions/649246/is-it-possible-to-create-a-multi-line-string-variable-in-a-makefile
uname_s=$(shell sh -c 'uname -s')

ifeq (Darwin,$(uname_s))
	pwd=$(shell sh -c 'echo $(CURDIR) | sed -e "s,/,\\\,g"')
else
	pwd=$(shell cygpath -w $(CURDIR))
endif

test:
	@cmd /c test.bat

export TEST_BODY
test.bat:
	@echo  "$$TEST_BODY" >$@

define TEST_BODY
REM -*- bat -*-
@Echo on

set PATH=%PROGRAMFILES%\Streambox\TinyPerl;%PATH%

tinyperl read_write.pl $(pwd)\file.conf

endef


clean:
	@rm -f test.bat

.PHONY: test
