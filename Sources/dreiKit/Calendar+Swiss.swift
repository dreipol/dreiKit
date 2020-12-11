//
//  Calendar+Swiss.swift
//  dreiKit
//
//  Created by Nils Becker on 27.11.20.
//

import Foundation

public extension Calendar {
    static func cet() -> Self {
        var calendar = Calendar(identifier: .gregorian)
        // swiftlint:disable:next force_unwrapping
        calendar.timeZone = TimeZone(identifier: "CET")!
        return calendar
    }

    static func swissGerman() -> Calendar {
        var calendar = cet()
        calendar.locale = Locale(identifier: "gsw_CH")
        return calendar
    }

    static func swissFrench() -> Calendar {
        var calendar = cet()
        calendar.locale = Locale(identifier: "fr_CH")
        return calendar
    }

    static func swissItalian() -> Calendar {
        var calendar = cet()
        calendar.locale = Locale(identifier: "it_CH")
        return calendar
    }

    static func swissRomansh() -> Calendar {
        var calendar = cet()
        calendar.locale = Locale(identifier: "rm_CH")
        return calendar
    }
}
