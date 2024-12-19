//
//  LocationPermissionManager.swift
//  dreiKit
//
//  Created by Nils Becker on 08.04.21.
//

import CoreLocation
import UIKit

public extension CLAuthorizationStatus {
    var isLocationAvailable: Bool {
        switch self {
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            return true
        default:
            return false
        }
    }
}

public class LocationPermissionManager: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var callbacks = [(CLAuthorizationStatus) -> Void]()

    public override init() {
        super.init()
        manager.delegate = self
    }

    public func requestPermissionIfNeeded(callback: @escaping (CLAuthorizationStatus) -> Void) {
        let status = CLLocationManager.authorizationStatus()
        guard status == .notDetermined else {
            callback(status)
            return
        }
        callbacks.append(callback)
        manager.requestWhenInUseAuthorization()
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status != .notDetermined else {
            return
        }

        for callback in callbacks {
            callback(status)
        }
        callbacks = []
    }

    @available(iOS 15.0, *)
    /// Only use with `CLLocationButton` (introduced in iOS 15) to be notified when location updates are availabel.
    public func checkLocationButtonGranted(callback: @escaping (Bool) -> Void) {
        let status = CLLocationManager.authorizationStatus()
        guard !status.isLocationAvailable else {
            callback(true)
            return
        }

        callbacks.append { status in
            callback(status.isLocationAvailable)
        }
    }
}

fileprivate class LocationAlwaysPermissionHelper: NSObject, CLLocationManagerDelegate {
    let manager: CLLocationManager

    private var continuation: UnsafeContinuation<Bool, any Error>?
    private var foregroundObserver: NSObjectProtocol?
    private var backgroundObserver: NSObjectProtocol?

    override init() {
        manager = CLLocationManager()
        super.init()
        manager.delegate = self
    }

    func requestAlwaysPermission() async throws -> Bool {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            return true
        }

        return try await withUnsafeThrowingContinuation { continuation in
            self.continuation = continuation
            continueCheck()
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        continueCheck()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }

    private func continueCheck() {
        guard let continuation else {
            return
        }

        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            continuation.resume(returning: true)
            self.continuation = nil
        case .authorizedWhenInUse:
            guard foregroundObserver == nil && backgroundObserver == nil else {
                return
            }

            foregroundObserver = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
                guard let self else {
                    return
                }

                self.continuation?.resume(returning: self.manager.authorizationStatus == .authorizedAlways)
                self.continuation = nil
            }

            DispatchQueue.main.async {
                let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { [weak self] _ in
                    self?.continuation?.resume(returning: false)
                    self?.continuation = nil
                }
                let backgroundObserver = NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { [weak self] _ in
                    timer.invalidate()
                }
                self.manager.requestAlwaysAuthorization()
            }
        default:
            continuation.resume(returning: false)
            self.continuation = nil
        }
    }
}

private var helper: LocationAlwaysPermissionHelper?

public extension CLLocationManager {
    @MainActor
    static func runRequestAlwaysAuthorizationFlow() async throws -> Bool {
        let helper = LocationAlwaysPermissionHelper()
        return try await helper.requestAlwaysPermission()
    }
}
