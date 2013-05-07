ENVAR_SRC=./src
ENVAR_BUILD=./build
ENVAR_TARGET=envar

VERSION=1.0

all: build

build: native.o
	mkdir -p ./build > /dev/null;
	csc $(ENVAR_SRC)/envar.scm $(ENVAR_BUILD)/native.o -o $(ENVAR_BUILD)/$(ENVAR_TARGET) -I $(ENVAR_SRC)
	rm -f $(ENVAR_BUILD)/native.o
	@echo
	@echo "BUILD SUCCESSFUL: " $(ENVAR_BUILD)/$(ENVAR_TARGET)
build-portable: native.o
	mkdir -p ./build > /dev/null;
	csc -deploy $(ENVAR_SRC)/envar.scm $(ENVAR_BUILD)/native.o -o $(ENVAR_BUILD)/$(ENVAR_TARGET) -I $(ENVAR_SRC)
	chicken-install -deploy -p ./$(ENVAR_BUILD)/$(ENVAR_TARGET) defstruct
	cp README $(ENVAR_BUILD)/$(ENVAR_TARGET)
	rm -f $(ENVAR_BUILD)/native.o
package: build-portable
	@echo PACKAGING
	
	cd $(ENVAR_BUILD); \
	tar -cf $(ENVAR_TARGET)-$(VERSION).tar ./$(ENVAR_TARGET)/ ;\
	gzip -9 --force $(ENVAR_TARGET)-$(VERSION).tar ;\
		
	@echo CLEAN-UP
	rm -rf $(ENVAR_BUILD)/$(ENVAR_TARGET)
	
	@echo
	@echo "BUILD SUCCESSFUL: " $(ENVAR_BUILD)/$(ENVAR_TARGET)/
clean:
	rm -f $(ENVAR_BUILD)/tests.exe $(ENVAR_BUILD)/native.o ./build/$(ENVAR_TARGET).exe
	rm -rf $(ENVAR_BUILD)/$(ENVAR_TARGET)
	rm -f $(ENVAR_BUILD)/*.tar.gz $(ENVAR_BUILD)/*.tar
tests: native.o
	mkdir -p ./build > /dev/null;
	csc $(ENVAR_SRC)/tests/tests.scm $(ENVAR_BUILD)/native.o -o $(ENVAR_BUILD)/tests -I $(ENVAR_SRC)
	$(ENVAR_BUILD)/tests
	rm -f $(ENVAR_BUILD)/native.o
	@echo
	@echo "TESTS SUCCESSFUL"
native.o:
	mkdir -p ./build > /dev/null;
	gcc -c $(ENVAR_SRC)/native.c -o $(ENVAR_BUILD)/native.o
