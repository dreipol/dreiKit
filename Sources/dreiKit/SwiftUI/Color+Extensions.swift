//
//  Color+Extensions.swift
//
//  Created by Samuel Bichsel on 11.10.22.
//  Copyright © 2022 dreipol GmbH. All rights reserved.
//

import SwiftUI
import UIKit

// MARK: Hex helpers

private let nonHexCharacters: CharacterSet = .whitespacesAndNewlines.union(CharacterSet(charactersIn: "#"))

public extension Color {
    init(rgba: Int) {
        let r = CGFloat((rgba & 0xFF000000) >> 24) / 255.0
        let g = CGFloat((rgba & 0x00FF0000) >> 16) / 255.0
        let b = CGFloat((rgba & 0x0000FF00) >> 8) / 255.0
        let a = CGFloat(rgba & 0x000000FF) / 255.0
        self.init(red: r, green: g, blue: b, opacity: a)
    }

    init(_ argb: Int) {
        let a = CGFloat((argb & 0xFF000000) >> 24) / 255.0
        let r = CGFloat((argb & 0x00FF0000) >> 16) / 255.0
        let g = CGFloat((argb & 0x0000FF00) >> 8) / 255.0
        let b = CGFloat(argb & 0x000000FF) / 255.0
        self.init(red: r, green: g, blue: b, opacity: a)
    }

    init?(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: nonHexCharacters)

        var rgb: UInt64 = 0
        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }

        switch length {
        case 6:
            let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(rgb & 0x0000FF) / 255.0
            self.init(red: r, green: g, blue: b, opacity: 1.0)
        case 8:
            self.init(rgba: Int(rgb))
        default:
            return nil
        }
    }
}

// MARK: Appearance helpers

public extension UIColor {
    convenience init(
        light lightModeColor: @escaping @autoclosure () -> UIColor,
        dark darkModeColor: @escaping @autoclosure () -> UIColor
    ) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                return lightModeColor()
            case .dark:
                return darkModeColor()
            @unknown default:
                return lightModeColor()
            }
        }
    }
}

public extension Color {
    init!(lightHex: String, darkHex: String) {
        guard let light = Color(hex: lightHex), let dark = Color(hex: darkHex) else {
            fatalError()
        }
        self.init(light: light, dark: dark)
    }

    init(
        light lightModeColor: @escaping @autoclosure () -> Color,
        dark darkModeColor: @escaping @autoclosure () -> Color
    ) {
        self.init(UIColor(
            light: lightModeColor().uiColor,
            dark: darkModeColor().uiColor
        ))
    }

    var uiColor: UIColor {
        UIColor(self)
    }
}
