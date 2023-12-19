//
//  UIApplication+Calling.swift
//  Foodnow
//
//  Created by Laila Becker on 19.12.2023.
//  Copyright © 2023 Foodnow AG. All rights reserved.
//

import UIKit

extension UIApplication {
    func tryCalling(phoneNumber: String) {
        let sanitized = phoneNumber.filter { !$0.isWhitespace }
        guard let url = URL(string: "tel://\(sanitized)") else {
            return
        }

        open(url)
    }
}
