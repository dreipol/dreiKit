//
//  String+Tools.swift
//  dreiKit
//
//  Created by Simon Müller on 09.09.19.
//  Copyright © 2019 dreipol. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}