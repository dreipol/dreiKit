//
//  Swift+Markdown.swift
//
//
//  Created by Samuel Bichsel on 24.08.23.
//

import Foundation
import SwiftUI

public extension String {
    private func convertToMarkdown() -> String {
        var markdownString = self

        let regexPattern = #"<a\s+href="([^"]+)"[^>]*>(.*?)</a>|<strong>(.*?)</strong>"#
        // swiftlint:disable:next force_try
        let regex = try! NSRegularExpression(pattern: regexPattern, options: [])

        let matches = regex.matches(in: markdownString, options: [], range: NSRange(location: 0, length: markdownString.utf16.count))

        for match in matches.reversed() {
            let hrefRange = match.range(at: 1)
            let textRange = match.range(at: 2)
            let strongRange = match.range(at: 3)

            if hrefRange.location != NSNotFound && textRange.location != NSNotFound,
               let href = Range(hrefRange, in: markdownString),
               let text = Range(textRange, in: markdownString),
               let replaceRange = Range(match.range, in: markdownString) {
                let markdownLink = "[\(String(markdownString[text]))](\(String(markdownString[href])))"
                markdownString.replaceSubrange(replaceRange, with: markdownLink)
            }

            if strongRange.location != NSNotFound, let strong = Range(strongRange, in: markdownString) {
                let markdownStrong = "**\(String(markdownString[strong]))**"
                markdownString.replaceSubrange(Range(match.range, in: markdownString)!, with: markdownStrong)
            }
        }
        return markdownString
    }

    /// Convert html tags to markdown so that they can be used in SwiftUI
    /// - Important: So far only **links and bold** are supported.
    func convertHTMLTagsMarkdown() -> LocalizedStringKey {
        return LocalizedStringKey(convertToMarkdown())
    }

    /// Convert html tags to markdown so that they can be used as AttributedString
    /// - Important: So far only **links and bold** are supported.
    func convertHTMLTagsMarkdownAttributed() -> AttributedString? {
        return try? AttributedString(markdown: convertToMarkdown())
    }
}

// swiftlint:disable all
struct Previews_String_Markdown_Previews: PreviewProvider {
    static let linkText = """
                Für Informationen zur Herkunftsdeklaration von Produkten von A' Amico Pizza, <a href="https://uploads-ssl.webflow.com/ 60252f9c2d84b60986d1ca50/6321b81def89be Ob7bf303b4_A%60Amico%20Pizza_Fleischdek laration.pdf" target="_blank" rel="noreferrer"> klicke hier</a>.
    """
    static var previews: some View {
        VStack {
            Text(linkText.convertHTMLTagsMarkdown())
            Text("<strong>Plane jetzt deine Bestellung.</strong> Du kannst für eine Lieferzeit <strong>ab 17:30 Uhr</strong> vorbestellen.".convertHTMLTagsMarkdown())
        }
    }
}
// swiftlint:enable all
