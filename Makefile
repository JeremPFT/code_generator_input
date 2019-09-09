ifdef OS
	EXT=.exe
else
	EXT=
endif

BUILD=gprbuild$(EXT)
CLEAN=gprclean$(EXT)

EXEC=input-tests-run$(EXT)

all:  run_tests

compil_lib::
	$(BUILD) -j4 -g -gnatef input_lib.gpr

compil_tests::
	$(BUILD) -j4 -g -gnatef input_tests.gpr

clean::
	$(CLEAN) input_lib.gpr
	$(CLEAN) input_tests.gpr

run_tests: compil_lib compil_tests
	${HOME}/tmp/bin/$(EXEC) ${HOME}/../projets_perso/ada/code_generator_input/examples/model/input.txt

gnattest: compil_lib
	gnattest$(EXT) -Pinput_lib.gpr src_lib/input-element-dummy.ads

xref::
	gnatxref -a -aIsrc_lib -aIsrc_tests -aOout_lib -aOout_obj src_test/input-tests-run.adb
