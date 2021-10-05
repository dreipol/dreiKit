//
//  UIAccessibilityCustomAction+Tools.swift
//  dreiKit
//
//  Created by Nils Becker on 05.10.21.
//

import UIKit

public extension UIAccessibilityCustomAction {
    static func localized(key: String, _ args: String..., languageCode: String? = nil, action: @escaping Handler) -> UIAccessibilityCustomAction {
        let pronouncable = String(format: key.localized, args).forVoiceOver(languageCode: languageCode)
        return UIAccessibilityCustomAction(attributedName: pronouncable, actionHandler: action)
    }
}
