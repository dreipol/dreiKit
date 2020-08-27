//
//  String+Tools.swift
//  dreiKit
//
//  Created by Simon Müller on 09.09.19.
//  Copyright © 2019 dreipol. All rights reserved.
//

import Foundation

public extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }

    var isLocalized: Bool {
        return self != localized
    }

    var localizedOptional: String? {
        return isLocalized ? localized : nil
    }

    func removingWhitespace() -> String {
        return filter { !$0.isWhitespace}
    }
}
