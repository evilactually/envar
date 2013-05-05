ENVAR_SRC=./src
ENVAR_BUILD=./build
EXECUTABLE=envar

all: $(EXECUTABLE)

$(EXECUTABLE):
	mkdir -p ./build > /dev/null;
	gcc -c $(ENVAR_SRC)/native.c -o $(ENVAR_BUILD)/native.o
	csc $(ENVAR_SRC)/envar.scm $(ENVAR_BUILD)/native.o -o $(ENVAR_BUILD)/$(EXECUTABLE) -I $(ENVAR_SRC)
	rm -f $(ENVAR_BUILD)/native.o
	@echo
	@echo "BUILD SUCCESSFUL: " $(ENVAR_BUILD)/$(EXECUTABLE)
$(EXECUTABLE)-deploy:
	mkdir -p ./build > /dev/null;
	gcc -c $(ENVAR_SRC)/native.c -o $(ENVAR_BUILD)/native.o
	csc -deploy $(ENVAR_SRC)/envar.scm $(ENVAR_BUILD)/native.o -o $(ENVAR_BUILD)/$(EXECUTABLE) -I $(ENVAR_SRC)
	rm -f $(ENVAR_BUILD)/native.o
	chicken-install -deploy -p .$(ENVAR_BUILD)/$(EXECUTABLE) defstruct
	@echo
	@echo "BUILD SUCCESSFUL: " $(ENVAR_BUILD)/$(EXECUTABLE)
clean:
	rm -f $(ENVAR_BUILD)/tests.exe $(ENVAR_BUILD)/native.o ./build/$(EXECUTABLE).exe
	rm -rf $(ENVAR_BUILD)/$(EXECUTABLE)
tests:
	mkdir -p ./build > /dev/null;
	gcc -c $(ENVAR_SRC)/native.c -o $(ENVAR_BUILD)/native.o
	csc $(ENVAR_SRC)/tests/tests.scm $(ENVAR_BUILD)/native.o -o $(ENVAR_BUILD)/tests -I $(ENVAR_SRC)
	$(ENVAR_BUILD)/tests
	@echo
	@echo "TESTS SUCCESSFUL"
