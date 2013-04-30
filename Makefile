ENVAR_SRC=./src
ENVAR_BUILD=./build
EXECUTABLE=envar

all: tests $(EXECUTABLE)
	
$(EXECUTABLE):
	mkdir -p ./build > /dev/null;
	csc $(ENVAR_SRC)/main.scm -o $(ENVAR_BUILD)/$(EXECUTABLE) -I $(ENVAR_SRC)
clean:
	rm -f ./build/$(EXECUTABLE)
tests:
	csi -I $(ENVAR_SRC) -s $(ENVAR_SRC)/tests/tests.scm
	