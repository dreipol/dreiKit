//
//  LocationPermissionManager.swift
//  dreiKit
//
//  Created by Nils Becker on 08.04.21.
//

import CoreLocation

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
