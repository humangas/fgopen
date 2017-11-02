FING_CMDNAME := fing
FING_INSTALLPATH := ~/bin

.DEFAULT_GOAL := help

.PHONY: all help install update

all:

help:
	@echo "Usage: make [target] [args]"
	@echo ""
	@echo "target:"
	@echo " - install:   Install findgrep.sh as a $(FING_CMDNAME) command."
	@echo " - update:    After git pull, execute the install command."
	@echo ""

install:
	rm -rf $(FING_INSTALLPATH)/$(FING_CMDNAME)
	cp $(PWD)/findgrep.sh $(FING_INSTALLPATH)/$(FING_CMDNAME)
	chmod +x $(FING_INSTALLPATH)/$(FING_CMDNAME)
	@echo ""
	@echo "Install Completion. Usage: $(FING_CMDNAME) --help"

update:
	git pull origin master
	@make install
