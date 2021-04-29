//
//  UIDevice+.swift
//  QuantiLogger
//
//  Created by George Ivannikov on 4/15/21.
//  Copyright © 2021 quanti. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    //Original Author: HAS
    // https://stackoverflow.com/questions/33855998/how-to-get-hardware-details-in-swift
    var cpuName: String {
        Array(CPUinfo().keys)[0]
    }

    var cpuSpeed: String {
        Array(CPUinfo().values)[0]
    }

    private func CPUinfo() -> [String: String] {
        #if targetEnvironment(simulator)
        let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
        #else

        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
  #endif

        switch identifier {
            case "iPod5,1":                                 return ["A5": "800 MHz"]
            case "iPod7,1":                                 return ["A8": "1.4 GHz"]
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return ["A4": "800 MHz"]
            case "iPhone4,1":                               return ["A5": "800 MHz"]
            case "iPhone5,1", "iPhone5,2":                  return ["A6": "1.3 GHz"]
            case "iPhone5,3", "iPhone5,4":                  return ["A6": "1.3 GHz"]
            case "iPhone6,1", "iPhone6,2":                  return ["A7": "1.3 GHz"]
            case "iPhone7,2":                               return ["A8": "1.4 GHz"]
            case "iPhone7,1":                               return ["A8": "1.4 GHz"]
            case "iPhone8,1":                               return ["A9": "1.85 GHz"]
            case "iPhone8,2":                               return ["A9": "1.85 GHz"]
            case "iPhone9,1", "iPhone9,3":                  return ["A10 Fusion": "2.34 GHz"]
            case "iPhone9,2", "iPhone9,4":                  return ["A10 Fusion": "2.34 GHz"]
            case "iPhone8,4":                               return ["A9": "1.85 GHz"]
            case "iPhone10,1", "iPhone10,4":                return ["A11 Bionic": "2.39 GHz"]
            case "iPhone10,2", "iPhone10,5":                return ["A11 Bionic": "2.39 GHz"]
            case "iPhone10,3", "iPhone10,6":                return ["A11 Bionic": "2.39 GHz"]
            case "iPhone11,2", "iPhone11,4",
                 "iPhone11,6", "iPhone11,8":               return ["A12": "2.5 GHz"]
            case "iPhone12,1", "iPhone12,3", "iPhone12,5":  return ["A13": "2650 GHz"]
            case "iPhone12,8":                              return ["A13": "2.65 GHz"]
            case "iPhone13,2", "iPhone13,1", "iPhone13,3":    return ["A14": "2.99 GHz"]
            case "iPhone13,4":                              return ["A14": "3.1 GHz"]
            case "iPad2,1", "iPad2,2",
                 "iPad2,3", "iPad2,4":                      return ["A5": "1.0 GHz"]
            case "iPad3,1", "iPad3,2", "iPad3,3":           return ["A5X": "1.0 GHz"]
            case "iPad3,4", "iPad3,5", "iPad3,6":           return ["A6X": "1.4 GHz"]
            case "iPad4,1", "iPad4,2", "iPad4,3":           return ["A7": "1.4 GHz"]
            case "iPad5,3", "iPad5,4":                      return ["A8X": "1.5 GHz"]
            case "iPad6,11", "iPad6,12":                    return ["A9": "1.85 GHz"]
            case "iPad2,5", "iPad2,6", "iPad2,7":           return ["A5": "1.0 GHz"]
            case "iPad4,4", "iPad4,5", "iPad4,6":           return ["A7": "1.3 GHz"]
            case "iPad4,7", "iPad4,8", "iPad4,9":           return ["A7": "1.3 GHz"]
            case "iPad5,1", "iPad5,2":                      return ["A8": "1.5 GHz"]
            case "iPad6,3", "iPad6,4":                      return ["A9X": "2.16 GHz"]
            case "iPad6,7", "iPad6,8":                      return ["A9X": "2.24 GHz"]
            case "iPad7,1", "iPad7,2":                      return ["A10X Fusion": "2.34 GHz"]
            case "iPad7,3", "iPad7,4":                      return ["A10X Fusion": "2.34 GHz"]
            default:                                        return ["N/A": "N/A"]
        }
    }
}
