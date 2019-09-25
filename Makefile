LIB_GPR=input_lib.gpr
TEST_GPR=input_tests.gpr
EXEC=input-tests-run$(EXT)
RUN=${HOME}/tmp/bin/$(EXEC)

CMD=make -f ../common/Makefile LIB_GPR=$(LIB_GPR) TEST_GPR=$(TEST_GPR) RUN=$(RUN) EXEC=$(EXEC)

.PHONY : all compil_lib compil_tests clean run_tests

all compil_lib compil_tests clean run_tests::
	$(CMD) $@
