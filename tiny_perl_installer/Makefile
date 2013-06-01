name=TinyPerl

include VERSION.mk
version=$(majorv).$(minorv).$(microv).$(qualifierv)

installer=$(name)_v$(version).exe

UPDATE_LIB_ARGS  = --ini-parser-version=2.14
ifdef VERBOSE
UPDATE_LIB_ARGS += --verbose
endif


$(installer): $(name).nsi Makefile update_lib
	@makensis \
		/V2 \
		/Doutfile=$(installer) \
		/Dname="$(name)" \
		/DtinyPerl=tinyperl-2.0-580-win32 \
		/Dversion=$(version) \
		$<

installer: $(installer)
.PHONY: installer

all: test2

upload: $(installer)
	-robocopy . //10.0.2.10/taylor.monacelli $(installer)
.PHONY: upload

# generate this something like this in test.bat:
# C:\Program Files\Streambox\TinyPerl\tinyperl.exe test.pl
test.bat: Makefile test.pl silent_install
	@reg query HKLM\\Software\\Streambox\\$(name) /v tinyPerlExe | \
	sed -ne '/REG_SZ/{s,.*REG_SZ[[:blank:]]*\(.*\),\"\1\",;s,$$, test.pl,p;}' > $@

check: query_perl_path
qpp: query_perl_path
query_perl_path:
	reg query HKLM\\Software\\Streambox\\$(name) /v tinyPerlExe
.PHONY: qpp check

# usage: VERBOSE=1 make update_lib
# or
# usage: make update_lib
update_lib:
	@sh add_to_lib.sh $(UPDATE_LIB_ARGS)

test: $(installer)
	cmd /c $(installer)
.PHONY: test

test2: test.txt

test.txt: test.bat Makefile test.pl
	@cmd /c test.bat
	@cat $@

test.pl:
	$(create-test.pl)

tpt: test.pl-test
.PHONY: tpt
test.pl-test:
	rm -f test.pl
	$(create-test.pl)
	cat test.pl

.PHONY: test.pl-test

un: uninstall
.PHONY: un
uninstall: uninstall.bat
	cmd /c uninstall.bat
.PHONY: uninstall

si: silent_install
.PHONY: si
silent_install: $(installer)
	$(silent_install)
.PHONY: silent_install



uninstall.bat: uninstall.bat Makefile
	echo '@echo on' > $@
	echo 'cd "%PROGRAMFILES%\Streambox\${name}"' >> $@
	echo '.\Uninstall.exe' >> $@

create-test.pl = echo "open(F,'>test.txt'); print F join(',',qw/1 2 3 4 5/) . \""\\n"\"; close(F);" > test.pl
silent_install = cmd /c $(installer) /S

clean:
	@$(MAKE) -C t/t1 clean
	@rm -f $(installer)
	@rm -f TinyPerl_v*.exe
	@rm -f before_modification.list
	@rm -f after_modification.list
	@rm -f diff_modification.list
	@rm -f Config-Tiny-*.tar.gz
	@rm -f uninstall.bat
	@rm -f test.bat
	@rm -f test.txt
	@rm -f test.pl
	@rm -f wget_out.txt
	@rm -rf lib
	@rm -rf tinyperl-2.0-580-win32
	@rm -rf Config-Tiny-*/

.PHONY: clean
