# hncli

<!-- PROJECT SHIELDS -->
<!--
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
[![Contributors][contributors-shield]][contributors-url]
[![Build Status][build-status-shield]][build-status-url]
-->

[![MIT License][license-shield]][license-url]
[![Stargazers][stars-shield]][stars-url]
[![Forks][forks-shield]][forks-url]
[![Issues][issues-shield]][issues-url]

[![Platforms][platforms-macos-shield]][platforms-macos-url]
[![Swift 5][swift5-shield]][swift5-url]

[![Xcode Build][xcodebuild-shield]][xcodebuild-url]

[![Tweet][tweet-shield]][tweet-url]

[![Sponsors][sponsors-shield]][sponsors-url]


## Table of Contents
  * [Summary](#summary)
  * [Blog post](#blog-post-for-this-example)
  * [Usage](#usage)
  * [Logging](#logging)
  * [Issues](#issues)
  * [Licensing](#licensing)
  * [Credits](#credits)


## Summary

This is a Swift command line app that will fetch and display various types of "stories" from Hacker News.

https://github.com/HackerNews/API

[Project Documentation][github-pages]


## Blog post for this example

[Blog post][blog-post-url]


## Usage

```shell
xcrun swift run -- hncli
xcrun swift run -- hncli  -h
xcrun swift run -- hncli  --help

xcrun swift run hncli --display-brief --fetch-limit 5 --ask
xcrun swift run hncli --display-brief --fetch-limit 5 --new
xcrun swift run hncli --display-brief --fetch-limit 5 --top
xcrun swift run hncli --display-brief --fetch-limit 5 --best
xcrun swift run hncli --display-brief --fetch-limit 5 --job
xcrun swift run hncli --display-brief --fetch-limit 5 --show

xcrun swift run hncli --display-brief --fetch-limit 5 --new --show-logging --verbose --display-json  


```


## Logging

## Set logging level

```
sudo /usr/bin/log config --mode "level:default" --subsystem
com.rockhoppertech.hncli
sudo /usr/bin/log config --mode "level:info" --subsystem
com.rockhoppertech.hncli
sudo /usr/bin/log config --mode "level:debug" --subsystem
com.rockhoppertech.hncli

sudo /usr/bin/log config --mode "level:debug,persist:debug" --subsystem
com.rockhoppertech.hncli



```

### See the logs

```
log show --info --debug --predicate '(subsystem == "com.rockhoppertech.hncli")' --style compact
log show --info --debug --predicate '(subsystem ==
"com.rockhoppertech.hncli") && (category == "Service")'
```

Or, in a separate window, stream the logs to stdout when you run the program.
```
log stream --predicate '(subsystem == "com.rockhoppertech.hncli")' --type log --level debug --color always --style compact

log stream --predicate '(subsystem == "com.rockhoppertech.hncli") && (category == "Service")' --type log --level debug --style json
```

### Logging References

[Customizing logging][logging-customizing]

[Logging documentation][logging-docs]

[OSLog documentation][oslog-docs]

[Logger documentation][logger-docs]


## Issues

If you find a problem, check out current [Issues][issues-url] or [Add a new Issue][issues-new]

## Buy my kitty Giacomo some cat food

If anything I wrote saved you a bit of time, consider donating to my kitty's food fund. He eats more food than I :)

[![Paypal][paypal-img]][paypal-url]

<img src="http://www.rockhoppertech.com/blog/wp-content/uploads/2016/07/momocoding-1024.png" alt="Giacomo Kitty" width="400" height="300">

## Sponsors

If you prefer to not use Paypal, please consider supporting this project by becoming a sponsor.

Become a sponsor through [GitHub Sponsors][github-sponsors]. :heart:


## Licensing

[MIT License article on Wikipedia][MIT-license-wiki-url]

Please read the [LICENSE](LICENSE) for details.

## Credits

[Gene De Lisa's development blog](http://rockhoppertech.com/blog/)

[Gene De Lisa's music blog](http://genedelisa.com/)

[![Twitter @GeneDeLisaDev][twitter-shield]][twitter-url]

[![LinkedIn][linkedin-shield]][linkedin-url]

[![Stackoverflow][stackoverflow-shield]][stackoverflow-url]



<!-- Markdown Reference Links & Images -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[contributors-shield]: https://img.shields.io/github/contributors/genedelisa/hncli.svg?style=flat
[contributors-url]: https://github.com/genedelisa/hncli/graphs/contributors

[forks-shield]: https://img.shields.io/github/forks/genedelisa/hncli.svg?style=flat
[forks-url]: https://github.com/genedelisa/hncli/network/members

[stars-shield]: https://img.shields.io/github/stars/genedelisa/hncli.svg?style=flat
[stars-url]: https://github.com/genedelisa/hncli/stargazers

[issues-shield]: https://img.shields.io/github/issues/genedelisa/hncli.svg?style=flat
[issues-url]: https://github.com/genedelisa/hncli/issues

[downloads-shield]:https://img.shields.io/github/downloads/genedelisa/hncli/total
[downloads-url]: https://github.com/genedelisa/hncli/releases/

[license-shield]: https://img.shields.io/github/license/genedelisa/hncli.svg?style=flat
[license-url]: https://github.com/genedelisa/hncli/blob/main/LICENSE

[MIT-license-wiki-url]:https://en.wikipedia.org/wiki/MIT_License

[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-blue.svg?style=for-the-badge&logo=linkedin
[linkedin-url]: https://linkedin.com/in/genedelisa

[sponsors-shield]:https://img.shields.io/badge/Sponsors-Rockhopper%20Technologies-orange.svg?style=flat
[sponsors-url]:https://rockhoppertech.com/

[twitter-shield]:https://img.shields.io/twitter/follow/GeneDeLisaDev.svg?style=social
[twitter-url]: https://twitter.com/GeneDeLisaDev

[build-status-shield]:https://travis-ci.org/genedelisa/hncli.svg
[build-status-url]:https://travis-ci.org/genedelisa/hncli
[travis-status-url]:https://img.shields.io/travis/com/genedelisa/hncli?style=for-the-badge
[circleci-status-url]:https://img.shields.io/circleci/build/github/genedelisa/hncli

[github-tag-shield]:https://img.shields.io/github/tag/genedelisa/hncli.svg
[github-tag-url]:https://github.com/genedelisa/hncli/

[github-release-shield]:https://img.shields.io/github/release/genedelisa/hncli.svg
[github-release-url]:https://github.com/genedelisa/hncli/

[github-version-shield]:https://badge.fury.io/gh/genedelisa%2Fhncli
[github-version-url]:https://github.com/genedelisa/hncli

[github-last-commit]:https://img.shields.io/github/last-commit/genedelisa/hncli

[github-issues]:https://img.shields.io/github/issues-raw/genedelisa/hncli
[github-closed-issues]:https://img.shields.io/github/issues-closed-raw/genedelisa/hncli

[github-stars-shield]:https://img.shields.io/github/stars/genedelisa/hncli.svg?style=social&label=Star&maxAge=2592000
[github-stars-url]:https://github.com/genedelisa/hncli/stargazers/

[swift5-shield]:https://img.shields.io/badge/swift5-compatible-4BC51D.svg?style=flat
[swift5-url]:https://developer.apple.com/swift

[platforms-ios-shield]:https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat
[platforms-ios-url]:https://swift.org/

[platforms-macos-shield]:https://img.shields.io/badge/Platforms-macOS-lightgray.svg?style=flat
[platforms-macos-url]:https://swift.org/

[platforms-osx-shield]:https://img.shields.io/badge/Platforms-OS%20X-lightgray.svg?style=flat
[platforms-osx-url]:https://swift.org/

[paypal-img]:https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif
[paypal-url]:https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=F5KE9Z29MH8YQ&bnP-DonationsBF:btn_donate_SM.gif:NonHosted

[stackoverflow-blah-shield]:https://img.shields.io/badge/stackoverflow-lightgray.svg?style=flat
[stackoverflow-shield]:https://stackoverflow-badge.vercel.app/?userID=409891
[stackoverflow-url]:https://stackoverflow.com/users/409891/gene-de-lisa

[github-pages]:https://genedelisa.github.io/hncli/

[blog-post-url]:http://www.rockhoppertech.com/blog/



[logging-customizing]:https://developer.apple.com/documentation/os/logging/customizing_logging_behavior_while_debugging
[logging-docs]:https://developer.apple.com/documentation/os/logging
[oslog-docs]:https://developer.apple.com/documentation/os/oslog
[logger-docs]:https://developer.apple.com/documentation/os/logger



[xcodebuild-shield]:https://github.com/genedelisa/hncli/actions/workflows/xcodebuild.yml/badge.svg
[xcodebuild-url]:https://github.com/genedelisa/hncli/actions/workflows/xcodebuild.yml

[tweet-shield]:https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Fgithub.com%2Fgenedelisa%2hncli
[tweet-url]:https://twitter.com/intent/tweet?text=Cool:&url=https%3A%2F%2Fgithub.com%2Fgenedelisa%2Fhncli 

[packageindex-platforms-url]:https://swiftpackageindex.com/genedelisa/hncli%2Fbadge%3Ftype%3Dplatforms
[packageindex-platforms-shield]:https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fgenedelisa%2Fhncli%2Fbadge%3Ftype%3Dplatforms

[packageindex-swiftversions-url]:https://swiftpackageindex.com/genedelisa/hncli%2Fbadge%3Ftype%3Dswift-versions
[packageindex-swiftversions-shield]:https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fgenedelisa%2Fhncli%2Fbadge%3Ftype%3Dswift-versions
