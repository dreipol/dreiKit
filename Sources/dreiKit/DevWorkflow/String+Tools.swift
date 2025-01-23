//
//  String+Tools.swift
//  dreiKit
//
//  Created by Simon Müller on 09.09.19.
//  Copyright © 2019 dreipol. All rights reserved.
//

import SwiftUI
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

    func localized(_ args: CVarArg...) -> String {
        localized(args: args)
    }
    func localized(args: [any CVarArg]) -> String {
        String(format: self.localized, arguments: args)
    }

    @available(*, deprecated, message: "use `trimmingCharacters(in: .whitespacesAndNewlines)` directly.")
    func removingWhitespace() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func universalDecimal() -> Double? {
        let pointFormatter = NumberFormatter()
        pointFormatter.decimalSeparator = "."
        let commaFormatter = NumberFormatter()
        commaFormatter.decimalSeparator = ","
        var decimalValue = pointFormatter.number(from: self)?.doubleValue
        if decimalValue == nil {
            decimalValue = commaFormatter.number(from: self)?.doubleValue
        }
        return decimalValue
    }
}

public extension AttributedString {
    init(markdown: String,
         regularFont: Font,
         boldFont: Font? = nil,
         italicFont: Font? = nil,
         boldItalicFont: Font? = nil,
         linkColor: Color? = nil,
         linkUnderline: Bool = false) throws {
        try self.init(markdown: markdown)
        self.font = regularFont
        for run in runs {
            if let linkColor, run.link != nil {
                self[run.range].foregroundColor = linkColor
            }
            if linkUnderline, run.link != nil {
                self[run.range].underlineStyle = .single
            }

            guard let presentationIntents = run.inlinePresentationIntent else {
                continue
            }

            if presentationIntents.contains(.stronglyEmphasized) && presentationIntents.contains(.emphasized) {
                self[run.range].font = boldItalicFont ?? boldFont ?? italicFont ?? regularFont
            } else if presentationIntents.contains(.stronglyEmphasized) {
                self[run.range].font = boldFont ?? regularFont
            } else if presentationIntents.contains(.emphasized) {
                self[run.range].font = italicFont ?? regularFont
            }
        }
    }
}

// MARK: URL Extensions

public extension String {
    private var urlEncoded: String? {
        return addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
    }

    func toURL() -> URL? {
        URL(string: self)
    }

    func toTelUrl() -> URL? {
        return URL(string: "tel:\(self.trimmingCharacters(in: .whitespacesAndNewlines))")
    }

    func toAppleMapSearchUrl() -> URL? {
        guard let encoded = urlEncoded else {
            return nil
        }

        return URL(string: "https://maps.apple.com/?q=\(encoded)")
    }
}
