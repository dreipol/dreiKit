//
//  StreetNavigationManager.swift
//  Transport
//
//  Created by Nils Becker on 08.10.20.
//  Copyright © 2020 dreipol GmbH. All rights reserved.
//

import UIKit

public struct StreetNavigationManager {
    weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    /**
     Show directions. If Google Maps is installed lets user choose which app to use.

     Checking whether Google Maps is installed requires `comgooglemaps` to be added to `LSApplicationQueriesSchemes in the App's Info.plist

     - Parameter from: starting point for the navigation or nil if current locaiton should be used
     - Parameter to: destination for the navigation
     - Parameter appChoicePrompt: title for action sheet when choosing between Apple Maps and Google Maps
    */
    public func showStreetDirections(from: Address?, to: Address, appChoicePrompt: String) {
        let formatter = AddressFormatter()
        guard let toEncoded = formatter.queryEncodedString(address: to) else {
            return
        }

        var appleURLString = "https://maps.apple.com/?daddr=\(toEncoded)&dirflg=d"
        var googleURLString = "comgooglemaps://?daddr=\(toEncoded)&directionsmode=driving"
        if let from = from,
           let fromEncoded = formatter.queryEncodedString(address: from) {
            appleURLString += "&saddr=\(fromEncoded)"
            googleURLString += "&saddr=\(fromEncoded)"
        }
        guard let appleURL = URL(string: appleURLString),
              let googleURL = URL(string: googleURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(googleURL) {
            let picker = UIAlertController(title: appChoicePrompt, message: nil, preferredStyle: .actionSheet)
            picker.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: { _ in
                UIApplication.shared.open(appleURL, options: [:], completionHandler: nil)
            }))
            picker.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { _ in
                UIApplication.shared.open(googleURL, options: [:], completionHandler: nil)
            }))
            viewController?.present(picker, animated: true, completion: nil)
        } else {
            UIApplication.shared.open(appleURL, options: [:], completionHandler: nil)
        }
    }
}
