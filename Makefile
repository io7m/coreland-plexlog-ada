# auto generated - do not edit

default: all

all:\
UNIT_TESTS/create UNIT_TESTS/create.o UNIT_TESTS/dir.ali UNIT_TESTS/dir.o \
UNIT_TESTS/getline.ali UNIT_TESTS/getline.o UNIT_TESTS/lines UNIT_TESTS/lines.o \
UNIT_TESTS/log UNIT_TESTS/log.ali UNIT_TESTS/log.o UNIT_TESTS/rotate \
UNIT_TESTS/rotate.o UNIT_TESTS/t_assert.o UNIT_TESTS/t_dir1 \
UNIT_TESTS/t_dir1.ali UNIT_TESTS/t_dir1.o UNIT_TESTS/t_init1 \
UNIT_TESTS/t_init1.ali UNIT_TESTS/t_init1.o UNIT_TESTS/t_init2 \
UNIT_TESTS/t_init2.ali UNIT_TESTS/t_init2.o UNIT_TESTS/t_open1 \
UNIT_TESTS/t_open1.ali UNIT_TESTS/t_open1.o UNIT_TESTS/test.a \
UNIT_TESTS/test.ali UNIT_TESTS/test.o UNIT_TESTS/write UNIT_TESTS/write.o \
ctxt/bindir.o ctxt/ctxt.a ctxt/dlibdir.o ctxt/incdir.o ctxt/repos.o \
ctxt/slibdir.o ctxt/version.o deinstaller deinstaller.o install-core.o \
install-error.o install-posix.o install-win32.o install.a installer installer.o \
instchk instchk.o insthier.o plexlog-ada.a plexlog-api.ali plexlog-api.o \
plexlog-dir_stack.ali plexlog-dir_stack.o plexlog-posix.ali plexlog-posix.o \
plexlog.ali plexlog.o plexlog_posix.o

# Mkf-deinstall
deinstall: deinstaller conf-sosuffix
	./deinstaller
deinstall-dryrun: deinstaller conf-sosuffix
	./deinstaller dryrun

# Mkf-install
install: installer postinstall conf-sosuffix
	./installer
	./postinstall

install-dryrun: installer conf-sosuffix
	./installer dryrun

# Mkf-instchk
install-check: instchk conf-sosuffix
	./instchk

# Mkf-test
tests:
	(cd UNIT_TESTS && make)
tests_clean:
	(cd UNIT_TESTS && make clean)

# -- SYSDEPS start
flags-c_string:
	@echo SYSDEPS c_string-flags run create flags-c_string 
	@(cd SYSDEPS/modules/c_string-flags && ./run)
libs-c_string-S:
	@echo SYSDEPS c_string-libs-S run create libs-c_string-S 
	@(cd SYSDEPS/modules/c_string-libs-S && ./run)
flags-chrono-ada:
	@echo SYSDEPS chrono-ada-flags run create flags-chrono-ada 
	@(cd SYSDEPS/modules/chrono-ada-flags && ./run)
libs-chrono-ada-S:
	@echo SYSDEPS chrono-ada-libs-S run create libs-chrono-ada-S 
	@(cd SYSDEPS/modules/chrono-ada-libs-S && ./run)
libs-chrono-S:
	@echo SYSDEPS chrono-libs-S run create libs-chrono-S 
	@(cd SYSDEPS/modules/chrono-libs-S && ./run)
libs-corelib-S:
	@echo SYSDEPS corelib-libs-S run create libs-corelib-S 
	@(cd SYSDEPS/modules/corelib-libs-S && ./run)
libs-integer-S:
	@echo SYSDEPS integer-libs-S run create libs-integer-S 
	@(cd SYSDEPS/modules/integer-libs-S && ./run)
flags-plexlog:
	@echo SYSDEPS plexlog-flags run create flags-plexlog 
	@(cd SYSDEPS/modules/plexlog-flags && ./run)
libs-plexlog-S:
	@echo SYSDEPS plexlog-libs-S run create libs-plexlog-S 
	@(cd SYSDEPS/modules/plexlog-libs-S && ./run)


c_string-flags_clean:
	@echo SYSDEPS c_string-flags clean flags-c_string 
	@(cd SYSDEPS/modules/c_string-flags && ./clean)
c_string-libs-S_clean:
	@echo SYSDEPS c_string-libs-S clean libs-c_string-S 
	@(cd SYSDEPS/modules/c_string-libs-S && ./clean)
chrono-ada-flags_clean:
	@echo SYSDEPS chrono-ada-flags clean flags-chrono-ada 
	@(cd SYSDEPS/modules/chrono-ada-flags && ./clean)
chrono-ada-libs-S_clean:
	@echo SYSDEPS chrono-ada-libs-S clean libs-chrono-ada-S 
	@(cd SYSDEPS/modules/chrono-ada-libs-S && ./clean)
chrono-libs-S_clean:
	@echo SYSDEPS chrono-libs-S clean libs-chrono-S 
	@(cd SYSDEPS/modules/chrono-libs-S && ./clean)
corelib-libs-S_clean:
	@echo SYSDEPS corelib-libs-S clean libs-corelib-S 
	@(cd SYSDEPS/modules/corelib-libs-S && ./clean)
integer-libs-S_clean:
	@echo SYSDEPS integer-libs-S clean libs-integer-S 
	@(cd SYSDEPS/modules/integer-libs-S && ./clean)
plexlog-flags_clean:
	@echo SYSDEPS plexlog-flags clean flags-plexlog 
	@(cd SYSDEPS/modules/plexlog-flags && ./clean)
plexlog-libs-S_clean:
	@echo SYSDEPS plexlog-libs-S clean libs-plexlog-S 
	@(cd SYSDEPS/modules/plexlog-libs-S && ./clean)


sysdeps_clean:\
c_string-flags_clean \
c_string-libs-S_clean \
chrono-ada-flags_clean \
chrono-ada-libs-S_clean \
chrono-libs-S_clean \
corelib-libs-S_clean \
integer-libs-S_clean \
plexlog-flags_clean \
plexlog-libs-S_clean \


# -- SYSDEPS end


UNIT_TESTS/create:\
cc-link UNIT_TESTS/create.ld UNIT_TESTS/create.o
	./cc-link UNIT_TESTS/create UNIT_TESTS/create.o

UNIT_TESTS/create.o:\
cc-compile UNIT_TESTS/create.c
	./cc-compile UNIT_TESTS/create.c

UNIT_TESTS/dir.ali:\
ada-compile UNIT_TESTS/dir.adb UNIT_TESTS/dir.ads
	./ada-compile UNIT_TESTS/dir.adb

UNIT_TESTS/dir.o:\
UNIT_TESTS/dir.ali

UNIT_TESTS/getline.ali:\
ada-compile UNIT_TESTS/getline.adb
	./ada-compile UNIT_TESTS/getline.adb

UNIT_TESTS/getline.o:\
UNIT_TESTS/getline.ali

UNIT_TESTS/lines:\
cc-link UNIT_TESTS/lines.ld UNIT_TESTS/lines.o
	./cc-link UNIT_TESTS/lines UNIT_TESTS/lines.o

UNIT_TESTS/lines.o:\
cc-compile UNIT_TESTS/lines.c
	./cc-compile UNIT_TESTS/lines.c

UNIT_TESTS/log:\
ada-bind ada-link UNIT_TESTS/log.ald UNIT_TESTS/log.ali plexlog.ali \
plexlog-posix.ali plexlog-api.ali plexlog-ada.a UNIT_TESTS/getline.ali
	./ada-bind UNIT_TESTS/log.ali
	./ada-link UNIT_TESTS/log UNIT_TESTS/log.ali plexlog-ada.a

UNIT_TESTS/log.ali:\
ada-compile UNIT_TESTS/log.adb plexlog-api.ali
	./ada-compile UNIT_TESTS/log.adb

UNIT_TESTS/log.o:\
UNIT_TESTS/log.ali

UNIT_TESTS/rotate:\
cc-link UNIT_TESTS/rotate.ld UNIT_TESTS/rotate.o
	./cc-link UNIT_TESTS/rotate UNIT_TESTS/rotate.o

UNIT_TESTS/rotate.o:\
cc-compile UNIT_TESTS/rotate.c
	./cc-compile UNIT_TESTS/rotate.c

UNIT_TESTS/t_assert.o:\
cc-compile UNIT_TESTS/t_assert.c UNIT_TESTS/t_assert.h
	./cc-compile UNIT_TESTS/t_assert.c

UNIT_TESTS/t_dir1:\
ada-bind ada-link UNIT_TESTS/t_dir1.ald UNIT_TESTS/t_dir1.ali \
UNIT_TESTS/test.ali plexlog-dir_stack.ali plexlog-posix.ali plexlog.ali \
plexlog-ada.a
	./ada-bind UNIT_TESTS/t_dir1.ali
	./ada-link UNIT_TESTS/t_dir1 UNIT_TESTS/t_dir1.ali plexlog-ada.a

UNIT_TESTS/t_dir1.ali:\
ada-compile UNIT_TESTS/t_dir1.adb plexlog-dir_stack.ali
	./ada-compile UNIT_TESTS/t_dir1.adb

UNIT_TESTS/t_dir1.o:\
UNIT_TESTS/t_dir1.ali

UNIT_TESTS/t_init1:\
ada-bind ada-link UNIT_TESTS/t_init1.ald UNIT_TESTS/t_init1.ali plexlog.ali \
plexlog-posix.ali plexlog-api.ali plexlog-ada.a UNIT_TESTS/dir.ali \
UNIT_TESTS/test.ali
	./ada-bind UNIT_TESTS/t_init1.ali
	./ada-link UNIT_TESTS/t_init1 UNIT_TESTS/t_init1.ali plexlog-ada.a

UNIT_TESTS/t_init1.ali:\
ada-compile UNIT_TESTS/t_init1.adb UNIT_TESTS/dir.ali plexlog-api.ali
	./ada-compile UNIT_TESTS/t_init1.adb

UNIT_TESTS/t_init1.o:\
UNIT_TESTS/t_init1.ali

UNIT_TESTS/t_init2:\
ada-bind ada-link UNIT_TESTS/t_init2.ald UNIT_TESTS/t_init2.ali plexlog.ali \
plexlog-posix.ali plexlog-api.ali plexlog-ada.a UNIT_TESTS/dir.ali \
UNIT_TESTS/test.ali
	./ada-bind UNIT_TESTS/t_init2.ali
	./ada-link UNIT_TESTS/t_init2 UNIT_TESTS/t_init2.ali plexlog-ada.a

UNIT_TESTS/t_init2.ali:\
ada-compile UNIT_TESTS/t_init2.adb plexlog-api.ali
	./ada-compile UNIT_TESTS/t_init2.adb

UNIT_TESTS/t_init2.o:\
UNIT_TESTS/t_init2.ali

UNIT_TESTS/t_open1:\
ada-bind ada-link UNIT_TESTS/t_open1.ald UNIT_TESTS/t_open1.ali \
UNIT_TESTS/test.ali plexlog-dir_stack.ali plexlog-posix.ali plexlog.ali \
plexlog-ada.a
	./ada-bind UNIT_TESTS/t_open1.ali
	./ada-link UNIT_TESTS/t_open1 UNIT_TESTS/t_open1.ali plexlog-ada.a

UNIT_TESTS/t_open1.ali:\
ada-compile UNIT_TESTS/t_open1.adb plexlog-api.ali
	./ada-compile UNIT_TESTS/t_open1.adb

UNIT_TESTS/t_open1.o:\
UNIT_TESTS/t_open1.ali

UNIT_TESTS/test.a:\
cc-slib UNIT_TESTS/test.sld UNIT_TESTS/test.o
	./cc-slib UNIT_TESTS/test UNIT_TESTS/test.o

UNIT_TESTS/test.ali:\
ada-compile UNIT_TESTS/test.adb
	./ada-compile UNIT_TESTS/test.adb

UNIT_TESTS/test.o:\
UNIT_TESTS/test.ali

UNIT_TESTS/write:\
cc-link UNIT_TESTS/write.ld UNIT_TESTS/write.o
	./cc-link UNIT_TESTS/write UNIT_TESTS/write.o

UNIT_TESTS/write.o:\
cc-compile UNIT_TESTS/write.c
	./cc-compile UNIT_TESTS/write.c

ada-bind:\
conf-adabind conf-systype conf-adatype conf-adabflags conf-adafflist \
	flags-chrono-ada flags-c_string flags-cwd

ada-compile:\
conf-adacomp conf-adatype conf-systype conf-adacflags conf-adafflist \
	flags-chrono-ada flags-c_string flags-cwd

ada-link:\
conf-adalink conf-adatype conf-systype conf-adaldflags conf-aldfflist \
	libs-plexlog-S libs-chrono-ada-S libs-c_string-S libs-chrono-S libs-chrono-C \
	libs-corelib-S libs-corelib-C libs-integer-S libs-integer-C

ada-srcmap:\
conf-adacomp conf-adatype conf-systype

ada-srcmap-all:\
ada-srcmap conf-adacomp conf-adatype conf-systype

cc-compile:\
conf-cc conf-cctype conf-systype conf-cflags conf-ccfflist flags-plexlog

cc-link:\
conf-ld conf-ldtype conf-systype conf-ldflags conf-ldfflist libs-plexlog-S \
	libs-chrono-S libs-chrono-C libs-corelib-S libs-corelib-C libs-integer-S \
	libs-integer-C

cc-slib:\
conf-systype

conf-adatype:\
mk-adatype
	./mk-adatype > conf-adatype.tmp && mv conf-adatype.tmp conf-adatype

conf-cctype:\
conf-cc mk-cctype
	./mk-cctype > conf-cctype.tmp && mv conf-cctype.tmp conf-cctype

conf-ldtype:\
conf-ld mk-ldtype
	./mk-ldtype > conf-ldtype.tmp && mv conf-ldtype.tmp conf-ldtype

conf-sosuffix:\
mk-sosuffix
	./mk-sosuffix > conf-sosuffix.tmp && mv conf-sosuffix.tmp conf-sosuffix

conf-systype:\
mk-systype
	./mk-systype > conf-systype.tmp && mv conf-systype.tmp conf-systype

# ctxt/bindir.c.mff
ctxt/bindir.c: mk-ctxt conf-bindir
	rm -f ctxt/bindir.c
	./mk-ctxt ctxt_bindir < conf-bindir > ctxt/bindir.c

ctxt/bindir.o:\
cc-compile ctxt/bindir.c
	./cc-compile ctxt/bindir.c

ctxt/ctxt.a:\
cc-slib ctxt/ctxt.sld ctxt/bindir.o ctxt/dlibdir.o ctxt/incdir.o ctxt/repos.o \
ctxt/slibdir.o ctxt/version.o
	./cc-slib ctxt/ctxt ctxt/bindir.o ctxt/dlibdir.o ctxt/incdir.o ctxt/repos.o \
	ctxt/slibdir.o ctxt/version.o

# ctxt/dlibdir.c.mff
ctxt/dlibdir.c: mk-ctxt conf-dlibdir
	rm -f ctxt/dlibdir.c
	./mk-ctxt ctxt_dlibdir < conf-dlibdir > ctxt/dlibdir.c

ctxt/dlibdir.o:\
cc-compile ctxt/dlibdir.c
	./cc-compile ctxt/dlibdir.c

# ctxt/incdir.c.mff
ctxt/incdir.c: mk-ctxt conf-incdir
	rm -f ctxt/incdir.c
	./mk-ctxt ctxt_incdir < conf-incdir > ctxt/incdir.c

ctxt/incdir.o:\
cc-compile ctxt/incdir.c
	./cc-compile ctxt/incdir.c

# ctxt/repos.c.mff
ctxt/repos.c: mk-ctxt conf-repos
	rm -f ctxt/repos.c
	./mk-ctxt ctxt_repos < conf-repos > ctxt/repos.c

ctxt/repos.o:\
cc-compile ctxt/repos.c
	./cc-compile ctxt/repos.c

# ctxt/slibdir.c.mff
ctxt/slibdir.c: mk-ctxt conf-slibdir
	rm -f ctxt/slibdir.c
	./mk-ctxt ctxt_slibdir < conf-slibdir > ctxt/slibdir.c

ctxt/slibdir.o:\
cc-compile ctxt/slibdir.c
	./cc-compile ctxt/slibdir.c

# ctxt/version.c.mff
ctxt/version.c: mk-ctxt VERSION
	rm -f ctxt/version.c
	./mk-ctxt ctxt_version < VERSION > ctxt/version.c

ctxt/version.o:\
cc-compile ctxt/version.c
	./cc-compile ctxt/version.c

deinstaller:\
cc-link deinstaller.ld deinstaller.o insthier.o install.a ctxt/ctxt.a
	./cc-link deinstaller deinstaller.o insthier.o install.a ctxt/ctxt.a

deinstaller.o:\
cc-compile deinstaller.c install.h
	./cc-compile deinstaller.c

install-core.o:\
cc-compile install-core.c install.h
	./cc-compile install-core.c

install-error.o:\
cc-compile install-error.c install.h
	./cc-compile install-error.c

install-posix.o:\
cc-compile install-posix.c install.h
	./cc-compile install-posix.c

install-win32.o:\
cc-compile install-win32.c install.h
	./cc-compile install-win32.c

install.a:\
cc-slib install.sld install-core.o install-posix.o install-win32.o \
install-error.o
	./cc-slib install install-core.o install-posix.o install-win32.o \
	install-error.o

install.h:\
install_os.h

installer:\
cc-link installer.ld installer.o insthier.o install.a ctxt/ctxt.a
	./cc-link installer installer.o insthier.o install.a ctxt/ctxt.a

installer.o:\
cc-compile installer.c install.h
	./cc-compile installer.c

instchk:\
cc-link instchk.ld instchk.o insthier.o install.a ctxt/ctxt.a
	./cc-link instchk instchk.o insthier.o install.a ctxt/ctxt.a

instchk.o:\
cc-compile instchk.c install.h
	./cc-compile instchk.c

insthier.o:\
cc-compile insthier.c ctxt.h install.h
	./cc-compile insthier.c

mk-adatype:\
conf-adacomp conf-systype

mk-cctype:\
conf-cc conf-systype

mk-ctxt:\
mk-mk-ctxt
	./mk-mk-ctxt

mk-ldtype:\
conf-ld conf-systype conf-cctype

mk-mk-ctxt:\
conf-cc conf-ld

mk-sosuffix:\
conf-systype

mk-systype:\
conf-cc conf-ld

plexlog-ada.a:\
cc-slib plexlog-ada.sld plexlog.o plexlog-api.o plexlog-posix.o plexlog_posix.o
	./cc-slib plexlog-ada plexlog.o plexlog-api.o plexlog-posix.o plexlog_posix.o

plexlog-api.ads:\
plexlog.ali plexlog-dir_stack.ali plexlog-posix.ali

plexlog-api.ali:\
ada-compile plexlog-api.adb plexlog.ali plexlog-api.ads
	./ada-compile plexlog-api.adb

plexlog-api.o:\
plexlog-api.ali

plexlog-dir_stack.ads:\
plexlog-posix.ali

plexlog-dir_stack.ali:\
ada-compile plexlog-dir_stack.adb plexlog-dir_stack.ads
	./ada-compile plexlog-dir_stack.adb

plexlog-dir_stack.o:\
plexlog-dir_stack.ali

plexlog-posix.ads:\
plexlog.ali

plexlog-posix.ali:\
ada-compile plexlog-posix.adb plexlog.ali plexlog-posix.ads
	./ada-compile plexlog-posix.adb

plexlog-posix.o:\
plexlog-posix.ali

plexlog.ali:\
ada-compile plexlog.ads plexlog.ads
	./ada-compile plexlog.ads

plexlog.o:\
plexlog.ali

plexlog_posix.o:\
cc-compile plexlog_posix.c
	./cc-compile plexlog_posix.c

clean-all: sysdeps_clean tests_clean obj_clean ext_clean
clean: obj_clean
obj_clean:
	rm -f UNIT_TESTS/create UNIT_TESTS/create.o UNIT_TESTS/dir.ali UNIT_TESTS/dir.o \
	UNIT_TESTS/getline.ali UNIT_TESTS/getline.o UNIT_TESTS/lines UNIT_TESTS/lines.o \
	UNIT_TESTS/log UNIT_TESTS/log.ali UNIT_TESTS/log.o UNIT_TESTS/rotate \
	UNIT_TESTS/rotate.o UNIT_TESTS/t_assert.o UNIT_TESTS/t_dir1 \
	UNIT_TESTS/t_dir1.ali UNIT_TESTS/t_dir1.o UNIT_TESTS/t_init1 \
	UNIT_TESTS/t_init1.ali UNIT_TESTS/t_init1.o UNIT_TESTS/t_init2 \
	UNIT_TESTS/t_init2.ali UNIT_TESTS/t_init2.o UNIT_TESTS/t_open1 \
	UNIT_TESTS/t_open1.ali UNIT_TESTS/t_open1.o UNIT_TESTS/test.a \
	UNIT_TESTS/test.ali UNIT_TESTS/test.o UNIT_TESTS/write UNIT_TESTS/write.o \
	ctxt/bindir.c ctxt/bindir.o ctxt/ctxt.a ctxt/dlibdir.c ctxt/dlibdir.o \
	ctxt/incdir.c ctxt/incdir.o ctxt/repos.c ctxt/repos.o ctxt/slibdir.c \
	ctxt/slibdir.o ctxt/version.c ctxt/version.o deinstaller deinstaller.o \
	install-core.o install-error.o install-posix.o install-win32.o install.a \
	installer installer.o instchk instchk.o insthier.o plexlog-ada.a \
	plexlog-api.ali plexlog-api.o plexlog-dir_stack.ali plexlog-dir_stack.o \
	plexlog-posix.ali plexlog-posix.o plexlog.ali plexlog.o
	rm -f plexlog_posix.o
ext_clean:
	rm -f conf-adatype conf-cctype conf-ldtype conf-sosuffix conf-systype mk-ctxt

regen:\
ada-srcmap ada-srcmap-all
	./ada-srcmap-all
	cpj-genmk > Makefile.tmp && mv Makefile.tmp Makefile
