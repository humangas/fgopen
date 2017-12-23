FING_CMDNAME := fgo
FING_INSTALLPATH := /usr/local/bin

.DEFAULT_GOAL := help

.PHONY: all help install update

all:

help:
	@echo "Usage: make [target] [args]"
	@echo ""
	@echo "target:"
	@echo " - install:   Install fgopen.sh as a $(FING_CMDNAME) command."
	@echo " - update:    After git pull, execute the install command."
	@echo ""

install: 
	rm -rf $(FING_INSTALLPATH)/$(FING_CMDNAME)
	cp $(PWD)/fgopen.sh $(FING_INSTALLPATH)/$(FING_CMDNAME)
	chmod +x $(FING_INSTALLPATH)/$(FING_CMDNAME)
	@echo ""
	@echo "Install Completion. Usage: $(FING_CMDNAME) --help"
	@echo "Please install dependency software. See also: README.md"

update:
	git pull origin master
	@make install
