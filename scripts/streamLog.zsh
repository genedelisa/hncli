#!/usr/bin/env zsh

/usr/bin/log stream --predicate 'process == "com.rockhoppertech.createMIDI"' --type log --level debug --color always --style compact





#log stream --predicate '(subsystem == "com.rockhoppertech.createMIDI") && (category == "createMIDIService")' --debug --info --color always --style json

#log stream --predicate '(subsystem == "com.rockhoppertech.createMIDI") && (category == "createMIDIService")' --level debug --color always --style compact --type log



#/usr/bin/log stream --predicate 'process == "com.rockhoppertech.createMIDI"' --info --debug --last 1m --color always --style json
