CMDNAME := fo

.DEFAULT_GOAL := help

.PHONY: all help install

all:

help:
	@echo "Usage: make [target] [args]"
	@echo ""
	@echo "target:"
	@echo " - install [CMDNAME=<cmd>]:   Install fileopener.sh as a <cmd> command. The default is the name 'fo'."
	@echo " - update  [CMDNAME=<cmd>]:   After git pull, execute the install command."
	@echo ""

install:
	rm -rf /usr/local/bin/$(CMDNAME)
	ln -s $(PWD)/fileopener.sh /usr/local/bin/$(CMDNAME)
	chmod +x /usr/local/bin/$(CMDNAME)
	@echo ""
	@echo "Install Completion. Run '$(CMDNAME)' command."

update:
	git pull origin master
	@make install
