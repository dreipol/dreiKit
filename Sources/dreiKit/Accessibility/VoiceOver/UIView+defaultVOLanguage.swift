//
//  UIView+defaultVOLanguage.swift
//  dreiKit
//
//  Created by Nils Becker on 06.05.21.
//

import UIKit

public extension UIView {
    static var defaultAccessibilityLanguage: String! {
        didSet {
            assert(swizzled, "Failed to swizzle accessibility language")
        }
    }
}

private extension NSObject {
    // implicitly lazy => dispatch_once
    static var swizzled: Bool = {
        guard let defaultingMethod = class_getInstanceMethod(NSObject.self, #selector(swizzled_accessibilityLanguage)),
              let originalMethod = class_getInstanceMethod(NSObject.self, #selector(accessibilityLanguage)) else {
            return false
        }
        let implementation = method_getImplementation(defaultingMethod)
        let types = method_getTypeEncoding(defaultingMethod)
        let overrideImpl = method_getImplementation(originalMethod)

        _ = class_replaceMethod(NSObject.self, #selector(accessibilityLanguage), implementation, types)
        _ = class_replaceMethod(NSObject.self, #selector(overrideAccessibiltyLanguage), overrideImpl, types)
        return true
    }()

    @objc private func swizzled_accessibilityLanguage() -> String? {
        if let overrideAccessibilityLanguage = overrideAccessibiltyLanguage() {
            return overrideAccessibilityLanguage
        }

        return UIView.defaultAccessibilityLanguage
    }

    @objc private func overrideAccessibiltyLanguage() -> String? {
        nil
    }
}
