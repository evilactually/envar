ENVAR_SRC=./src
ENVAR_BUILD=./build
EXECUTABLE=envar

all: tests $(EXECUTABLE)

$(EXECUTABLE):
	mkdir -p ./build > /dev/null;
	gcc -c $(ENVAR_SRC)/vars-native.c -o $(ENVAR_BUILD)/vars-native.o
	csc $(ENVAR_SRC)/envar.scm $(ENVAR_BUILD)/vars-native.o -o $(ENVAR_BUILD)/$(EXECUTABLE) -I $(ENVAR_SRC)
clean:
	rm -f $(ENVAR_BUILD)/tests $(ENVAR_BUILD)/vars-native.o ./build/$(EXECUTABLE)
tests:
	mkdir -p ./build > /dev/null;
	gcc -c $(ENVAR_SRC)/vars-native.c -o $(ENVAR_BUILD)/vars-native.o
	csc $(ENVAR_SRC)/tests/tests.scm $(ENVAR_BUILD)/vars-native.o -o $(ENVAR_BUILD)/tests -I $(ENVAR_SRC)
	$(ENVAR_BUILD)/tests
	