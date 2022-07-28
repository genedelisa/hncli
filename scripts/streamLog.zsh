#!/usr/bin/env zsh

/usr/bin/log stream --predicate 'process == "com.rockhoppertech.hncli"' --type log --level debug --color always --style compact





#log stream --predicate '(subsystem == "com.rockhoppertech.hncli") && (category == "Service")' --debug --info --color always --style json

#log stream --predicate '(subsystem == "com.rockhoppertech.hncli") && (category == "Service")' --level debug --color always --style compact --type log



#/usr/bin/log stream --predicate 'process == "com.rockhoppertech.hncli"' --info --debug --last 1m --color always --style json
