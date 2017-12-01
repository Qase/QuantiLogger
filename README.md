![Platform](https://img.shields.io/cocoapods/p/PagingKit.svg?style=flat)
![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Pod compatible](https://cocoapod-badges.herokuapp.com/v/QuantiLogger/badge.png)](https://cocoapods.org)
[![](https://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat-square "License")](LICENSE)

# QuantiLogger
QuantiLogger is a super lightweight logging library for iOS development in Swift. It provides a few pre-built loggers including native os_log or a file logger. It also provides an interface for creating custom loggers.

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

## Usage

### Logging levels

It is possible to log on different levels. Each logger can support different levels, meaning that it records only log messages on such levels. For example multiple loggers of the same type can be set to support different levels and thus separate logging on such level. Another use case is to further filter messages of specific type declared by its level. 

Although it is definitely up to the developer in which way the levels will be used, there is a recommended way how to use them since each of them serves a different purpose.


- `info` for mostly UI related user actions
- `debug` for debugging purposes
- `verbose` for extended debug purposes, especially when there is a need for very specific messages
- `warn` for warnings
- `error` for errors
- `system` (for native os_log only) matches to os_log_fault -> sends a fault-level message to the logging system
- `process` (for native os_log only) matches to os_log_error -> sends an error-level message to the logging system

### Pre-build loggers
```
ConsoleLogger
```
The simplest logger. Wraps `print(_:separator:terminator:)` function from Swift Standard Library.

```
SystemLogger
```
Wraps the native ```OSLog``` to log messages on the system level.

```
FileLogger
```

Enables logging to a file. Each log file relates to a single day data. Another day, another log file is used. `numberOfLogFiles` specifies the number of log files that are stored. In other words, how many days back (log files) should be kept. If the last log file is filled, the first one gets overriden using the simplest Round-robin strategy.

### Creating custom loggers

There is a possibility of creating custom loggers just by implementing `Logging` protocol. In the simplest form, the custom logger only needs to implement `log(_:onLevel:)` and `levels()` methods. Optionaly it can also implement `configure()` method in case there is some configuration necessary before starting logging.

Here is an example of a custom logger that enables logging to Crashlytics:
```
import Fabric
import Crashlytics

class CrashLyticsLogger: QuantiLogger.Logging {
    open func configure() {
        Fabric.with([Crashlytics.self])
    }
    
    open func log(_ message: String, onLevel level: Level) {
        CLSLogv("%@", getVaList(["[\(level.rawValue) \(Date().toFullDateTimeString())] \(message)"]))
    }

    open func levels() -> [Level] {
        return [.verbose, .info, .debug, .warn, .error]
    }

}
```


### Initialization

Logging initialization is done through `LogManager` Singleton instance. The LogManager holds an array of all configured loggers and then manages the logging.

Here is an example of how to initialize the logger to use `FileLogger`, `ConsoleLogger` and previously created custom `CrashLyticsLogger`:

```
let logManager = LogManager.shared

let fileLogger = FileLogger()
fileLogger.levels = [.warn, .error]
logManager.add(fileLogger)

let systemLogger = ConsoleLogger()
systemLogger.levels = [.verbose, .info, .debug, .warn, .error]
logManager.add(systemLogger)

let crashlyticsLogger = CrashLyticsLogger()
logManager.add(crashlyticsLogger)
```

### Logging

Logging is done using a simple `QLog(_:onLevel)` macro function. Such function can be used anywhere, where `QuantiLogger` is imported. 

Example of how to log:
```
QLog("This is the message to be logged.", onLevel: .info)
```

### Sending file logs via mail

The framework also provides `LogFilesViaMailViewController` that has a pre-configured controller that, when presented, will offer the option to send all log files via mail. It is constructed using `init(withRecipients:)` where `withRecipients` is `[String]` containing all mail recipients.

Example can be seen in a form of `SendLogFilesViaMailViewController` within `QuantiLoggerExample` which is a working example within the framework (clone the project to see).

![Example](https://user-images.githubusercontent.com/2511209/33484357-2c76cb84-d6a2-11e7-8302-804a1ed67fb4.PNG "Example")

### Displaying file logs in UITableView

The framework also provides `FileLoggerTableViewDatasource` which is a pre-configured `UITableViewDataSource` containing all log files merged, each log = a single `UITableViewCell`.

Example can be seen in a form of `LogListTableViewController` within `QuantiLoggerExample` which is a working example within teh framework (clone the project to see).

![Example](https://user-images.githubusercontent.com/2511209/33484358-2c94790e-d6a2-11e7-8810-20db77dd2960.PNG "Example")

## License

`QuantiLogger` is released under the [MIT License](LICENSE).
