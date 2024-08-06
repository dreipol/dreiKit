//
//  AccessibleStaticFont.swift
//
//
//  Created by Laila Becker on 05.08.2024.
//

import SwiftUI

public protocol FontDefinition: Equatable {
    func font(for legibilityWeight: LegibilityWeight) -> Font
}

public extension View {
    func font(_ font: any FontDefinition) -> some View {
        modifier(ApplyFontDefinition(font: font))
    }
}

private struct ApplyFontDefinition: ViewModifier {
    var font: any FontDefinition

    @Environment(\.legibilityWeight) private var legibilityWeigt

    func body(content: Content) -> some View {
        content.font(font.font(for: legibilityWeigt ?? .regular))
    }
}

// ⚠️ This causes infinite recursion because the compiler picks this function over the (more specific) version in SwiftUI when evaluating
// the ViewModifier above.
//
//extension Font: FontDefinition {
//    public func font(for legibilityWeight: LegibilityWeight) -> Font { self }
//}

public struct AccessibleStaticFont: FontDefinition {
    let regular: Font
    let bold: Font

    public func font(for legibilityWeight: LegibilityWeight) -> Font {
        switch legibilityWeight {
        case .regular: return regular
        case .bold: return bold
        }
    }
}

public extension AccessibleStaticFont {
    init(regularFamily: String, boldFamily: String, size: CGFloat, relativeTo: Font.TextStyle? = nil) {
        if let relativeTo {
            self.init(regular: .custom(regularFamily, size: size, relativeTo: relativeTo),
                      bold: .custom(boldFamily, size: size, relativeTo: relativeTo))
        } else {
            self.init(regular: .custom(regularFamily, size: size),
                      bold: .custom(boldFamily, size: size))
        }
    }

    init(regularFamily: String, boldFamily: String, fixedSize: CGFloat) {
        self.init(regular: .custom(regularFamily, fixedSize: fixedSize),
                  bold: .custom(boldFamily, fixedSize: fixedSize))
    }
}
