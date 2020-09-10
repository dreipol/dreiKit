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
        var validationString = string
        switch textField.keyboardType {
        case .decimalPad:
            if validationString.filter({ $0 == "." || $0 == "," }).count > 1 {
                return false
            }
            if textField.text?.allSatisfy({ $0 != "." && $0 != "," }) ?? true {
                validationString = validationString.filter({ $0 != "." && $0 != "," })
            }
            fallthrough
        case .numberPad:
            return validationString.allSatisfy({ $0.isNumber })
        default:
            return true
        }
    }
}
