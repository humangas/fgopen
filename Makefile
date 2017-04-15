FO_CMDNAME := fo
FO_INSTALLPATH := /usr/local/bin

.DEFAULT_GOAL := help

.PHONY: all help install update

all:

help:
	@echo "Usage: make [target] [args]"
	@echo ""
	@echo "target:"
	@echo " - install [CMDNAME=<cmd>]:   Install fileopener.sh as a <cmd> command. The default is the name 'fo'."
	@echo " - update  [CMDNAME=<cmd>]:   After git pull, execute the install command."
	@echo ""

install:
	rm -rf $(FO_INSTALLPATH)/$(FO_CMDNAME)
	ln -s $(PWD)/fileopener.sh $(FO_INSTALLPATH)/$(FO_CMDNAME)
	chmod +x $(FO_INSTALLPATH)/$(FO_CMDNAME)
	@echo ""
	@echo "Install Completion. Usage: $(FO_CMDNAME) --help"

update:
	git pull origin master
	@make install
