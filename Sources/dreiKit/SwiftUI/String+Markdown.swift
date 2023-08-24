//
//  Swift+Markdown.swift
//
//
//  Created by Samuel Bichsel on 24.08.23.
//

import Foundation
import SwiftUI

public extension String {
    func convertHTMLLinksToMarkdown() -> LocalizedStringKey {
        var markdownString = self

        let regexPattern = #"<a\s+href="([^"]+)"[^>]*>(.*?)</a>"#
//                // swiftlint:disable:next force_try
        let regex = try! NSRegularExpression(pattern: regexPattern, options: [])

        let matches = regex.matches(in: markdownString, options: [], range: NSRange(location: 0, length: markdownString.utf16.count))

        for match in matches.reversed() {
            let hrefRange = match.range(at: 1)
            let textRange = match.range(at: 2)

            if hrefRange.location != NSNotFound && textRange.location != NSNotFound,
               let href = Range(hrefRange, in: markdownString),
               let text = Range(textRange, in: markdownString),
               let replaceRange = Range(match.range, in: markdownString) {
                let markdownLink = "[\(String(markdownString[text]))](\(String(markdownString[href])))"
                markdownString.replaceSubrange(replaceRange, with: markdownLink)
            }
        }

        return LocalizedStringKey(markdownString)
    }
}
