//
//  String+HTMLDecoding.swift
//  
//  Created by Laila Becker on 23.05.23.
//  Copyright © 2023 dreipol. All rights reserved.
//

import SwiftUI

extension StringProtocol {
    @available(iOS 16, *)
    func parseHTML(isDarkMode: Bool) -> AttributedString? {
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html,
                                                                           .characterEncoding: String.Encoding.utf8.rawValue]

        guard let styleTemplateUrl = Bundle.main.url(forResource: isDarkMode ? "htmlStyleTemplateDark" : "htmlStyleTemplate",
                                                     withExtension: "html"),
            let templateString = try? String(contentsOf: styleTemplateUrl),
            let data = String(format: templateString, String(self)).data(using: .utf8),
            let nsAttributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }

        let converted = AttributedString(nsAttributedString)
        // For some reason our conversion adds a newline at the end of the string...
        return AttributedString(converted[converted.startIndex ..< converted.index(beforeCharacter: converted.endIndex)])
    }

    @available(iOS 16, *)
    fileprivate func splitKeepingSeparator(separator: String) -> [any StringProtocol] {
        let splits = split(separator: separator)
        if splits.count > 1 {
            // swiftlint:disable:next force_unwrapping
            return splits.map { $0 + separator }.dropLast(splits.last!.isEmpty ? 1 : 0)
        } else {
            return splits
        }
    }
}

extension TextAlignment {
    func toHorizontalAlignment() -> HorizontalAlignment {
        switch self {
        case .center: return .center
        case .leading: return .leading
        case .trailing: return .trailing
        }
    }
}

@available(iOS 16, *)
struct HTMLView: View {
    private let paragraphs: [String]
    private let paragraphSpacing: CGFloat
    let plainStyle: any TextModifier

    @State private var completeCount = 0

    @Environment(\.multilineTextAlignment) private var multilineTextAlignment

    init(text: String, paragraphSpacing: CGFloat) {
        self.paragraphSpacing = paragraphSpacing

        let pSplit = text.splitKeepingSeparator(separator: "</p>")
        let h1Split = pSplit
            .flatMap { $0.splitKeepingSeparator(separator: "</h1>") }
        let h2Split = h1Split
            .flatMap { $0.splitKeepingSeparator(separator: "</h2>") }
        let h3Split = h2Split
            .flatMap { $0.splitKeepingSeparator(separator: "</h3>") }
        paragraphs = h3Split
            .map { String($0) }
    }

    var body: some View {
        VStack(alignment: multilineTextAlignment.toHorizontalAlignment(), spacing: paragraphSpacing) {
            ForEach(paragraphs.indices, id: \.self) { index in
                HTMLParagraphView(text: paragraphs[index],
                                  numParagraphs: paragraphs.count,
                                  processingComplete: $completeCount,
                                  plainStyle: plainStyle)
            }
        }
    }
}

private struct HTMLParagraphView: View {
    let text: String
    let numParagraphs: Int
    @Binding var processingComplete: Int
    let plainStyle: any TextModifier

    @State private var html: AttributedString?

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            if let html, processingComplete == numParagraphs {
                Text(html)
            } else if processingComplete == numParagraphs {
                Text(text)
                    .textStyle(plainStyle)
//                    .foregroundColor(.Vaduz.monochrome700)
            }
        }.onAppear {
            DispatchQueue.main.async {
                // Running conversion immediately causes a SIGABRT
                // https://stackoverflow.com/questions/72689505/attributegraph-precondition-failure-setting-value-during-update-when-using-nsat
                html = text.parseHTML(isDarkMode: colorScheme == .dark)
                processingComplete += 1
            }
        }.onChange(of: colorScheme) { newValue in
            DispatchQueue.main.async {
                // Running conversion immediately causes a SIGABRT
                // https://stackoverflow.com/questions/72689505/attributegraph-precondition-failure-setting-value-during-update-when-using-nsat
                html = text.parseHTML(isDarkMode: newValue == .dark)
            }
        }
    }
}

@available(iOS 16, *)
struct HTMLDecoding_Previews: PreviewProvider {
    static let content = """
    <p>regular <b>bold</b> <em>italic</em> <u>underline</u></p>
    <h1>h1 <b>bold</b> <em>italic</em> <u>underline</u></h1>
    <h2>h2 <b>bold</b> <em>italic</em> <u>underline</u></h2>
    <h3>h3 <b>bold</b> <em>italic</em> <u>underline</u></h3>
    <p>
    <ul>
        <li>First</li>
        <li>Second</li>
        <li>Third item that is longer and probably spans multiple lines on most phone sizes...</li>
    </ul>
    <ol>
        <li>First</li>
        <li>Second</li>
        <li>Third item that is longer and probably spans multiple lines on most phone sizes...</li>
    </ol>
    This is a <a href="https://dreipol.ch">link</a>.
    </p>
    <p>and this is another paragraph </p>
    <h1>Headline in text</h1>
    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
    """
    static var previews: some View {
        ScrollView {
            HTMLView(text: content, paragraphSpacing: 16, plainStyle: previewTextModifier)
        }
    }
    
    static let previewTextModifier = TextFormat(font: .body)
}
