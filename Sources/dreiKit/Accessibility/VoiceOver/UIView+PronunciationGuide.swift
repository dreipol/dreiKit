//
//  UIView+PronunciationGuide.swift
//  dreiKit
//
//  Created by Nils Becker on 05.10.21.
//

import UIKit

private typealias ObjCFunctionCallable = @convention(c) (NSObject, Selector) -> NSObject?

public extension UIView {
    static var pronunciationGuide: [String: String] = [:] {
        didSet {
            assert(swizzled, "Failed to swizzle pronunciation guide")
        }
    }

    static var abbreviations: [String: String] = [:] {
        didSet {
            assert(swizzled, "Failed to swizzle pronunciation guide")
        }
    }
}

private extension NSObject {
    // implicitly lazy => dispatch_once
    static var swizzled: Bool = {
        guard let labelNew = class_getInstanceMethod(NSObject.self, #selector(swizzled_accessibilityAttributedLabel)),
              let labelOld = class_getInstanceMethod(NSObject.self, #selector(accessibilityAttributedLabel)),
              let valueNew = class_getInstanceMethod(NSObject.self, #selector(swizzled_accessibilityAttributedValue)),
              let valueOld = class_getInstanceMethod(NSObject.self, #selector(accessibilityAttributedValue)),
              let hintNew = class_getInstanceMethod(NSObject.self, #selector(swizzled_accessibilityAttributedHint)),
              let hintOld = class_getInstanceMethod(NSObject.self, #selector(accessibilityAttributedHint)),
              let userInputLabelsNew = class_getInstanceMethod(NSObject.self, #selector(swizzled_accessibilityAttributedUserInputLabels)),
              let userInputLabelsOld = class_getInstanceMethod(NSObject.self, #selector(accessibilityAttributedUserInputLabels)) else {
            return false
        }
        method_exchangeImplementations(labelNew, labelOld)
        method_exchangeImplementations(valueNew, valueOld)
        method_exchangeImplementations(hintNew, hintOld)
        method_exchangeImplementations(userInputLabelsNew, userInputLabelsOld)
        return true
    }()

    private func callOriginal<R>(_ selector: Selector) -> R? {
        let method = class_getMethodImplementation(NSObject.self, selector)
        let callable = unsafeBitCast(method, to: ObjCFunctionCallable.self)
        return callable(self, selector) as? R
    }

    private func withoutRecursion<R>(_ block: () -> R?) -> R? {
        let returnAddresses = Thread.callStackReturnAddresses
        // Ideally we would compare entire stack frames to allow for recursion where some form of "progress" is made. However, this is a
        // close enough approximation. It disallows reaching the same call site twice.
        guard returnAddresses.count == Set(returnAddresses).count else {
            return nil
        }

        return block()
    }

    @objc private func swizzled_accessibilityAttributedLabel() -> NSAttributedString? {
        let originalResult: NSAttributedString? = callOriginal(#selector(swizzled_accessibilityAttributedLabel))
            // Some views (e.g. UILabel) define their own fallbacks, i.e. they call super.accessibilityAttributed... and return another
            // value if that returns nil. We want to obtain that value but we need to break the recursion to avoid stack overflows.
            ?? withoutRecursion { accessibilityAttributedLabel }
        return originalResult.map {
            NSMutableAttributedString(attributedString: $0).applyPronunciationGuide()
        }
    }

    @objc private func swizzled_accessibilityAttributedValue() -> NSAttributedString? {
        let originalResult: NSAttributedString? = callOriginal(#selector(swizzled_accessibilityAttributedValue))
            // Some views (e.g. UILabel) define their own fallbacks, i.e. they call super.accessibilityAttributed... and return another
            // value if that returns nil. We want to obtain that value but we need to break the recursion to avoid stack overflows.
            ?? withoutRecursion { accessibilityAttributedValue }
        return originalResult.map {
            NSMutableAttributedString(attributedString: $0).applyPronunciationGuide()
        }
    }

    @objc private func swizzled_accessibilityAttributedHint() -> NSAttributedString? {
        let originalResult: NSAttributedString? = callOriginal(#selector(swizzled_accessibilityAttributedHint))
            // Some views (e.g. UILabel) define their own fallbacks, i.e. they call super.accessibilityAttributed... and return another
            // value if that returns nil. We want to obtain that value but we need to break the recursion to avoid stack overflows.
            ?? withoutRecursion { accessibilityAttributedHint }
        return originalResult.map {
            NSMutableAttributedString(attributedString: $0).applyPronunciationGuide()
        }
    }

    @objc private func swizzled_accessibilityAttributedUserInputLabels() -> [NSAttributedString] {
        let originalResult: [NSAttributedString] = callOriginal(#selector(swizzled_accessibilityAttributedUserInputLabels))
            // Some views (e.g. UILabel) define their own fallbacks, i.e. they call super.accessibilityAttributed... and return another
            // value if that returns nil. We want to obtain that value but we need to break the recursion to avoid stack overflows.
            ?? withoutRecursion { accessibilityAttributedUserInputLabels }
            ?? []
        return originalResult.map {
            NSMutableAttributedString(attributedString: $0).applyPronunciationGuide()
        }
    }
}

extension NSMutableAttributedString {
    func applyPronunciationGuide() -> NSAttributedString {
        guard let wordRegex = try? NSRegularExpression(pattern: "\\S+", options: []), length > 0 else {
            return self
        }

        let attributes = attributes(at: 0, effectiveRange: nil)
        wordRegex.mapMatches(onString: self) { word, _ in
            let fullWord = UIView.abbreviations[word] ?? word

            guard let pronunciation = UIView.pronunciationGuide[fullWord] else {
                return NSAttributedString(string: fullWord, attributes: attributes)
            }

            var resolvedAttributes = attributes
            resolvedAttributes[.accessibilitySpeechIPANotation] = pronunciation
            return NSAttributedString(string: fullWord.lowercased(), attributes: resolvedAttributes)
        }

        return self
    }
}
