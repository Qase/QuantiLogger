//
//  UIApplicationLogger.swift
//  QuantiLogger
//
//  Created by Martin Troup on 28/12/2017.
//  Copyright © 2017 quanti. All rights reserved.
//

import Foundation

public enum ApplicationCallbackType: String {
	case willTerminate
	case didBecomeActive
	case willResignActive
	case didEnterBackground
	case didFinishLaunching
	case willEnterForeground
	case significantTimeChange
	case userDidTakeScreenshot
	case didChangeStatusBarFrame
	case didReceiveMemoryWarning
	case willChangeStatusBarFrame
	case didChangeStatusBarOrientation
	case willChangeStatusBarOrientation
	case protectedDataDidBecomeAvailable
	case backroundRefreshStatusDidChange
	case protectedDataWillBecomeUnavailable

	static let allValues: [ApplicationCallbackType] = [.willTerminate, .didBecomeActive,
													   .willResignActive, .didEnterBackground,
													   .didFinishLaunching, .willEnterForeground,
													   .significantTimeChange, .userDidTakeScreenshot,
													   .didChangeStatusBarFrame, .didReceiveMemoryWarning,
													   .willChangeStatusBarFrame, .didChangeStatusBarOrientation,
													   .willChangeStatusBarOrientation, .protectedDataDidBecomeAvailable,
													   .backroundRefreshStatusDidChange, .protectedDataWillBecomeUnavailable]

	var notificationName: NSNotification.Name {
		switch self {
		case .willTerminate:
			return UIApplication.willTerminateNotification
		case .didBecomeActive:
			return UIApplication.didBecomeActiveNotification
		case .willResignActive:
			return UIApplication.willResignActiveNotification
		case .didEnterBackground:
			return UIApplication.didEnterBackgroundNotification
		case .didFinishLaunching:
			return UIApplication.didFinishLaunchingNotification
		case .willEnterForeground:
			return UIApplication.willEnterForegroundNotification
		case .significantTimeChange:
			return UIApplication.significantTimeChangeNotification
		case .userDidTakeScreenshot:
			return UIApplication.userDidTakeScreenshotNotification
		case .didChangeStatusBarFrame:
			return UIApplication.didChangeStatusBarFrameNotification
		case .didReceiveMemoryWarning:
			return UIApplication.didReceiveMemoryWarningNotification
		case .willChangeStatusBarFrame:
			return UIApplication.willChangeStatusBarFrameNotification
		case .didChangeStatusBarOrientation:
			return UIApplication.didChangeStatusBarOrientationNotification
		case .willChangeStatusBarOrientation:
			return UIApplication.willChangeStatusBarOrientationNotification
		case .protectedDataDidBecomeAvailable:
			return UIApplication.protectedDataDidBecomeAvailableNotification
		case .backroundRefreshStatusDidChange:
			return UIApplication.backgroundRefreshStatusDidChangeNotification
		case .protectedDataWillBecomeUnavailable:
			return UIApplication.protectedDataWillBecomeUnavailableNotification
		}
	}
}

protocol ApplicationCallbackLoggerDelegate: class {
	func logApplicationCallback(_ message: String, onLevel level: Level)
}

class ApplicationCallbackLogger {
	weak var delegate: ApplicationCallbackLoggerDelegate?

	var callbacks: [ApplicationCallbackType]? = [] {
		didSet {
			let _oldValue = oldValue?.count == 0 ? ApplicationCallbackType.allValues : oldValue
			let _callbacks = callbacks?.count == 0 ? ApplicationCallbackType.allValues : callbacks

			removeNotifications(for: getCallbacksToRemove(from: _oldValue, basedOn: _callbacks))
			addNotifications(for: getCallbacksToAdd(from: _callbacks, basedOn: _oldValue))
		}
	}

	var level: Level = .debug

	init() {
		addNotifications(for: ApplicationCallbackType.allValues)
	}

	/// Method to get array of callbacks to remove (thus those, who are in oldCallbacks but not in newCallbacks).
	/// The method is used for removeNotifications(for:) method.
	///
	/// - Parameters:
	///   - oldCallbacks: old array of callbacks
	///   - newCallbacks: new array of callbacks
	/// - Returns: array of callbacks to be removed
	private func getCallbacksToRemove(from oldCallbacks: [ApplicationCallbackType]?, basedOn newCallbacks: [ApplicationCallbackType]?) -> [ApplicationCallbackType] {
		return oldCallbacks?.filter { !(newCallbacks?.contains($0) ?? false) } ?? []
	}

	/// Method to get array of callbacks to add (thus those, who are in newCallbacks but not in oldCallbacks).
	/// The method is used for addNotifications(for:) method.
	///
	/// - Parameters:
	///   - newCallbacks: new array of callbacks
	///   - oldCallbacks: old array of callbacks
	/// - Returns: array of callbacks to be added
	private func getCallbacksToAdd(from newCallbacks: [ApplicationCallbackType]?, basedOn oldCallbacks: [ApplicationCallbackType]?) -> [ApplicationCallbackType] {
		return newCallbacks?.filter { !(oldCallbacks?.contains($0) ?? false) } ?? []
	}

	/// Method to remove specific Application's notification callbacks
	///
	/// - Parameter callbacks: callbacks to be removed
	private func removeNotifications(`for` callbacks: [ApplicationCallbackType]) {
		callbacks.forEach { (callback) in
			NotificationCenter.default.removeObserver(self, name: callback.notificationName, object: nil)
		}
	}

	/// Method to add specific Application's notification callbacks
	///
	/// - Parameter callbacks: callbacks to be added
	private func addNotifications(`for` callbacks: [ApplicationCallbackType]) {
		callbacks.forEach { (callback) in
			NotificationCenter.default.addObserver(self, selector: Selector(callback.rawValue), name: callback.notificationName, object: nil)
		}
	}
}

// MARK: - Application's notification callbacks
extension ApplicationCallbackLogger {
	private func log(_ message: String, onLevel level: Level) {
		delegate?.logApplicationCallback(message, onLevel: level)
	}

	@objc fileprivate func willTerminate() {
		log("\(#function)", onLevel: level)
	}

	@objc fileprivate func didBecomeActive() {
		log("\(#function)", onLevel: level)
	}

	@objc fileprivate func willResignActive() {
		log("\(#function)", onLevel: level)
	}

	@objc fileprivate func didEnterBackground() {
		log("\(#function)", onLevel: level)
	}

	@objc fileprivate func didFinishLaunching() {
		log("\(#function)", onLevel: level)
	}

	@objc fileprivate func willEnterForeground() {
		log("\(#function)", onLevel: level)
	}

	@objc fileprivate func significantTimeChange() {
		log("\(#function)", onLevel: level)
	}

	@objc fileprivate func userDidTakeScreenshot() {
		log("\(#function)", onLevel: level)
	}

	@objc fileprivate func didChangeStatusBarFrame() {
		log("\(#function)", onLevel: level)
	}

	@objc fileprivate func didReceiveMemoryWarning() {
		log("\(#function)", onLevel: level)
	}

	@objc fileprivate func willChangeStatusBarFrame() {
		log("\(#function)", onLevel: level)
	}

	@objc fileprivate func didChangeStatusBarOrientation() {
		log("\(#function)", onLevel: level)
	}

	@objc fileprivate func willChangeStatusBarOrientation() {
		log("\(#function)", onLevel: level)
	}

	@objc fileprivate func protectedDataDidBecomeAvailable() {
		log("\(#function)", onLevel: level)
	}

	@objc fileprivate func backroundRefreshStatusDidChange() {
		log("\(#function)", onLevel: level)
	}

	@objc fileprivate func protectedDataWillBecomeUnavailable() {
		log("\(#function)", onLevel: level)
	}
}
