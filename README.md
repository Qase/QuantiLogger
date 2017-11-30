![Platform](https://img.shields.io/cocoapods/p/PagingKit.svg?style=flat)
![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Pod compatible](https://cocoapod-badges.herokuapp.com/v/QuantiLogger/badge.png)](https://cocoapods.org)
[![](https://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat-square "License")](LICENSE)

# QuantiLogger
Swift lightweight logger. 


## Requirements

- Swift 4.0+
- Xcode 9+
- iOS 11.0+

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. You can install Carthage with [Homebrew](https://brew.sh) using the following command:
```
$ brew update
$ brew install carthage
```
To integrate QuantiLogger into your Xcode project using Carthage, specify it in your `Cartfile`:
```
github "Qase/QuantiLogger" ~> 1.10
``` 
Run `carthage update` to build the framework and drag the built `QuantiLogger.framework` into your Xcode project.

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:
```
$ gem install cocoapods
```
To integrate QuantiLogger into your Xcode project using CocoaPods, specify it in your Podfile:
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
  pod 'QuantiLogger', '~> 1.10'
end
```
Then, run the following command:
```
$ pod install
```
