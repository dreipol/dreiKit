//
//  DefaultBehaviorTextFieldDelegate.swift
//  dreiKit
//
//  Created by Nils Becker on 10.09.20.
//

import UIKit

open class DefaultBehaviorTextFieldDelegate: NSObject, UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
              let range = Range(range, in: text) else {
            return isValid(text: string, in: textField)
        }

        let afterEdit = text.replacingCharacters(in: range, with: string)
        return isValid(text: afterEdit, in: textField)
    }

    open func isValid(text: String, in textField: UITextField) -> Bool {
        return true
    }
}

public final class KeyboardValidationTextFieldDelegate: DefaultBehaviorTextFieldDelegate {
    public static let shared = KeyboardValidationTextFieldDelegate()

    public override func isValid(text: String, in textField: UITextField) -> Bool {
        var validationString = text
        switch textField.keyboardType {
        case .decimalPad:
            if validationString.filter({ $0 == "." || $0 == "," }).count > 1 {
                return false
            }
            validationString = validationString.filter({ $0 != "." && $0 != "," })
            fallthrough
        case .numberPad:
            return validationString.allSatisfy({ $0.isNumber })
        default:
            return true
        }
    }
}

public final class CurrencyValidationTextFieldDelegate: DefaultBehaviorTextFieldDelegate {
    public static let shared = CurrencyValidationTextFieldDelegate()

    public override func isValid(text: String, in textField: UITextField) -> Bool {
        var subUnits = text.drop(while: { $0.isNumber })
        if let separator = subUnits.first, separator == "." || separator == "," {
            subUnits = subUnits.dropFirst()
        }
        return subUnits.allSatisfy({ $0.isNumber }) && subUnits.count <= 2
    }
}
