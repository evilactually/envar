ENVAR_SRC=./src
ENVAR_BUILD=./build
EXECUTABLE=envar

all: $(EXECUTABLE)

$(EXECUTABLE):
	mkdir -p ./build > /dev/null;
	gcc -c $(ENVAR_SRC)/native.c -o $(ENVAR_BUILD)/native.o
	csc $(ENVAR_SRC)/envar.scm $(ENVAR_BUILD)/native.o -o $(ENVAR_BUILD)/$(EXECUTABLE) -I $(ENVAR_SRC)
	@echo
	@echo "BUILD SUCCESSFUL: " $(ENVAR_BUILD)/$(EXECUTABLE)
clean:
	rm -f $(ENVAR_BUILD)/tests.exe $(ENVAR_BUILD)/native.o ./build/$(EXECUTABLE).exe
tests:
	mkdir -p ./build > /dev/null;
	gcc -c $(ENVAR_SRC)/native.c -o $(ENVAR_BUILD)/native.o
	csc $(ENVAR_SRC)/tests/tests.scm $(ENVAR_BUILD)/native.o -o $(ENVAR_BUILD)/tests -I $(ENVAR_SRC)
	$(ENVAR_BUILD)/tests
	@echo
	@echo "TESTS SUCCESSFUL"
