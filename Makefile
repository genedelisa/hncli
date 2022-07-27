# Makefile
#
# see https://www.gnu.org/software/make/manual/html_node/Standard-Targets.html
# Gene De Lisa
#

SHELL 			= /bin/sh
PROG                    = hncli
SRC			= Sources/**/*.swift
VERSION 		= 0.0.1
PREFIX 			= /usr/local
INSTALL_DIR		= $(PREFIX)/bin/$(PROG)
BUILD_PATH 		= .build/release/$(PROG)
SWIFT			= xcrun --sdk macosx swift
# you can see which swift with this:
# xcrun --show-sdk-path --sdk macosx

PREF_PLIST 		= com.rockhoppertech.$(PROG).plist
PREF_DIR 		= ~/Library/Preferences/Logging/Subsystems/

default: build-debug

build-release: SWIFT_FLAGS = --configuration release  --disable-sandbox
build-release: PREFIX = /usr/local
build-release: $(PROG)

build-debug: SWIFT_FLAGS = --configuration debug -Xswiftc "-D" -Xswiftc "DEBUG"
build-debug: PREFIX := "$(CURDIR)"
build-debug: $(PROG)

$(PROG): $(SRC)
	$(SWIFT) build $(SWIFT_FLAGS)

.PHONY: lintfix
lintfix:					## fix the problems discovered by swiftlint
	swiftlint --fix --format
#	swiftlint --fix --format --quiet

.PHONY: lint
lint:						## lint your sources
	swiftlint lint --quiet --strict

.PHONY: dockertest
dockertest:					## run the test target in docker
	docker build -f Dockerfile -t linuxtest .
	docker run linuxtest

.PHONY: runexe
runexe: 					## directly run the program
	.build/debug/$(PROG) -h

# e.g. make run ARGS=--verbose file
.PHONY: run
run: $(PROG)					## swift run the program. e.g. make run ARGS=--verbose file
	$(SWIFT) run -- $(PROG) $(ARGS)

# The Swift Package Index recommends that before submitting your package that this emits valid JSON.
# https://github.com/SwiftPackageIndex/PackageList
.PHONY: dump-package
dump-package:					## Dump this package as JSON.
	swift package dump-package

.PHONY: update
update:						## update the packages
	$(SWIFT) package update

.PHONY: test
test:						## run the tests
	$(SWIFT) test


.PHONY: install
install: release				## install the program to INSTALL_PATH
	install -d "$(PREFIX)/bin"
	install -C -m 755 $(BUILD_PATH) $(INSTALL_PATH)
	cp $(PREF_PLIST) $(PREF_DIR)

.PHONY: uninstall
uninstall:					## uninstall the program from INSTALL_PATH
	rm -f $(INSTALL_PATH)

release: build-release				## build the release version
debug: build-debug				## build the debug version


.PHONY: clean
clean:						## clean package
	$(SWIFT) package clean

.PHONY: docs
docs:						## Generate docs via Jazzy
	jazzy

# foreground Colors
fg_black 	:= $(shell tput -Txterm setaf 0)
fg_red 		:= $(shell tput -Txterm setaf 1)
fg_green 	:= $(shell tput -Txterm setaf 2)
fg_yellow 	:= $(shell tput -Txterm setaf 3)
fg_blue 	:= $(shell tput -Txterm setaf 4)
fg_magenta 	:= $(shell tput -Txterm setaf 5)
fg_cyan 	:= $(shell tput -Txterm setaf 6)
fg_white 	:= $(shell tput -Txterm setaf 7)
fg_default 	:= $(shell tput -Txterm setaf 9)

# background Colors
bg_black 	:= $(shell tput -Txterm setab 0)
bg_red 		:= $(shell tput -Txterm setab 1)
bg_green 	:= $(shell tput -Txterm setab 2)
bg_yellow 	:= $(shell tput -Txterm setab 3)
bg_blue 	:= $(shell tput -Txterm setab 4)
bg_magenta 	:= $(shell tput -Txterm setab 5)
bg_cyan 	:= $(shell tput -Txterm setab 6)
bg_white 	:= $(shell tput -Txterm setab 7)
bg_default 	:= $(shell tput -Txterm setab 9)

RESET		:= $(shell tput -Txterm sgr0)
bold		:= $(shell tput -Txterm bold)

# modified from https://gist.github.com/prwhite/8168133
# reads targets with help text that starts with two #s

.PHONY: help
help:			## This help dialog.
	@IFS=$$'\n' ; \
	help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##/:/'`); \
	printf "${bg_blue}${bold}${fg_yellow}%-30s %s\n" "target" "help" ; \
	printf "%-30s %s${RESET}\n" "------" "----" ; \
    for help_line in $${help_lines[@]}; do \
        IFS=$$':' ; \
        help_split=($$help_line) ; \
        help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
        help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
        printf "${fg_cyan}%-30s %s${RESET}" $$help_command ; \
        printf "${fg_magenta}%s${RESET}\n" $$help_info; \
    done
