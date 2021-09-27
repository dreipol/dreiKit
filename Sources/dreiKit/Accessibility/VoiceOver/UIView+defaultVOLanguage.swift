//
//  UIView+defaultVOLanguage.swift
//  dreiKit
//
//  Created by Nils Becker on 06.05.21.
//

import UIKit

private enum AssociatedObjectKey {
    case overrideAccessibiltyLanguage

    static var overrideAccessibiltyLanguageKey = AssociatedObjectKey.overrideAccessibiltyLanguage
}

public extension UIView {
    static var defaultAccessibilityLanguage: String! {
        didSet {
            // TODO: only works while voice over is enabled
            assert(swizzled, "Failed to swizzle accessibility language")
        }
    }

    // implicitly lazy => dispatch_once
    private static var swizzled: Bool = {
        guard let defaultingMethod = class_getInstanceMethod(UIView.self, #selector(swizzled_accessibilityLanguage)),
              let originalMethod = class_getInstanceMethod(UIView.self, #selector(accessibilityLanguage)) else {
            return false
        }
        let implementation = method_getImplementation(defaultingMethod)
        let types = method_getTypeEncoding(defaultingMethod)
        guard let overrideImpl = class_replaceMethod(UIView.self, #selector(accessibilityLanguage), implementation, types) else {
            return false
        }
        _ = class_replaceMethod(UIView.self, #selector(overrideAccessibiltyLanguage), overrideImpl, types)
        return true
    }()

    @objc private func swizzled_accessibilityLanguage() -> String? {
        if let overrideAccessibilityLanguage = overrideAccessibiltyLanguage() {
            return overrideAccessibilityLanguage
        }

        return Self.defaultAccessibilityLanguage
    }

    @objc private func overrideAccessibiltyLanguage() -> String? {
        nil
    }
}
