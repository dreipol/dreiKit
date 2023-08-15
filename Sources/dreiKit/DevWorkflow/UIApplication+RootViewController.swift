//
//  UIApplication+RootViewController.swift
//  dreiKit
//
//  Created by Samuel Bichsel on 15.08.23.
//

import UIKit

extension UIApplication {
    var currentKeyWindow: UIWindow? {
        connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first { $0.isKeyWindow }
    }

    public var rootViewController: UIViewController! {
        currentKeyWindow!.rootViewController
    }
}
