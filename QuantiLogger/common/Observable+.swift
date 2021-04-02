//
//  Observable+.swift
//  QuantiLogger
//
//  Created by Martin Troup on 02/01/2020.
//  Copyright © 2020 quanti. All rights reserved.
//

//import Foundation
//import RxSwift
//
//extension Observable {
//    func qDebug(_ message: String) -> Observable {
//        return self.do(onNext: { element in
//            LogManager.shared.log("\(message) -> Event next(\(element))", onLevel: .debug)
//        }, onError: { error in
//            LogManager.shared.log("\(message) -> Event error(\(error))", onLevel: .debug)
//        }, onCompleted: {
//            LogManager.shared.log("\(message) -> Event completed", onLevel: .debug)
//        }, onSubscribed: {
//            LogManager.shared.log("\(message) -> subscribed", onLevel: .debug)
//        }) {
//            LogManager.shared.log("\(message) -> isDisposed", onLevel: .debug)
//        }
//    }
//}
