#!/usr/bin/env zsh

# https://developer.apple.com/library/archive/technotes/tn2339/_index.html

# to find out the schemes
# xcodebuild -list

# to find out the available destinations
#xcodebuild -showdestinations -scheme GDTerminalColor

local scheme=hncli

#xcodebuild -scheme ${scheme} -destination 'platform=macOS' -configuration Debug build

#xcodebuild test -scheme ${scheme} -destination 'platform=macOS' -configuration Debug build


xcodebuild -scheme ${scheme} -destination 'platform=macOS,arch=arm64'  -configuration Debug build
#xcodebuild -scheme ${scheme} -destination 'platform=macOS,arch=x86_64' -configuration Debug build

#xcodebuild -scheme ${scheme} -destination 'platform=iOS Simulator,OS=15.4,name=iPhone 13 Pro Max' -configuration Debug build
