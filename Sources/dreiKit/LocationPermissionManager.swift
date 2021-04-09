//
//  LocationPermissionManager.swift
//  dreiKit
//
//  Created by Nils Becker on 08.04.21.
//

import CoreLocation

public class LocationPermissionManager: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var callbacks = [(CLAuthorizationStatus) -> Void]()

    public override init() {
        super.init()
        manager.delegate = self
    }

    public func requestPermission(callback: @escaping (CLAuthorizationStatus) -> Void) {
        guard CLLocationManager.authorizationStatus() == .notDetermined else {
            callback(CLLocationManager.authorizationStatus())
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
}
