#!/usr/bin/env zsh
# -*- mode: sh; sh-shell: zsh; sh-indentation: 4; sh-basic-offset: 4; coding: utf-8; -*-
# vim: ft=zsh:sw=4:ts=4:et
#
# Time-stamp: "Last Modified 2022-04-25 06:46:04 by Gene De Lisa, genedelisa"
#
#
# File: run tests for hncli
#
# Gene De Lisa
# gene@rockhoppertech.com
# http://rockhoppertech.com/blog/
# License - http://unlicense.org
################################################################################
#
# https://developer.apple.com/library/archive/technotes/tn2339/_index.html


# -R reset zsh options
# -L options LOCAL_OPTIONS, LOCAL_PATTERNS and LOCAL_TRAPS will be set

emulate -LR zsh

local SCRIPT_NAME=${ZSH_SCRIPT:t:r}

local scheme="hncli"

local ios_destination="platform=iOS Simulator,OS=14.5,name=iPad (8th generation)"

local macos_destination="platform=macOS,arch=arm64"

(( $+commands[xcodebuild] )) || {
    print "You need xcodebuild to be installed."
    exit 1
}

test_ios() {

    xcodebuild clean test \
	       -scheme ${scheme} \
	       -destination ${destination} \
	       CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO ONLY_ACTIVE_ARCH=NO
    return ${status}
}

test_macos() {

    xcodebuild clean test \
	       -scheme ${scheme} \
	       -destination ${macos_destination}
    return ${status}
}




usage() {
    readonly local help_text="""
Run the tests.
Requires that you specify macos or ios or both

Usage: ${SCRIPT_NAME} flags
Flags:
  -h or --help           Print usage information
  -m or --macos
  -i or --ios
"""
    print ${help_text}
    exit 0
}


main() {
    zparseopts -a runtests_options -D -E -- \
               h=help_opt           -help=help_opt \
               v=verbose_opt        -verbose=verbose_opt \
               m=mac_opt            -mac=mac_opt \
               i=ios_opt            -ios=ios_opt \
	|| {

	error_message "zparseopts error" ${status}
	usage
	exit 1
    }

    [[ -n ${help_opt} ]] && {usage}

    [[ -n ${mac_opt} ]] && {
	test_macos
    }

    [[ -n ${ios_opt} ]] && {
	test_ios
    }
    return ${status}
}


###############################################################################
# requires at least one arg
[[ $# -lt 1 ]] && usage

main "${@}"
return ${status}
