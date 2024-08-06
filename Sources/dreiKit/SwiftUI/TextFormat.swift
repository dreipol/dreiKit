import SwiftUI

public protocol TextModifier {
    associatedtype Body: View

    func body(_ view: Text) -> Body
}

public extension Text {
    func modifier<TM: TextModifier>(_ theModifier: TM) -> some View {
        return theModifier.body(self)
    }

    func textStyle<TM: TextModifier>(_ style: TM) -> some View {
        modifier(style)
    }
}

public protocol TextishModifier {
    associatedtype TextishBody: View

    func styleBody(_ view: some View) -> TextishBody
}

public extension View {
    func modifier<TM: TextishModifier>(_ theModifier: TM) -> some View {
        return theModifier.styleBody(self)
    }

    func textStyle<TM: TextishModifier>(_ style: TM) -> some View {
        modifier(style)
    }
}

public extension View {
    @ViewBuilder func foregroundColorIfSet(_ color: Color?) -> some View {
        if let c = color {
            self.foregroundColor(c)
        } else {
            self
        }
    }
}

public struct TextFormat: TextModifier, Equatable {
    public let font: AccessibleStaticFont
    public let lineSpacing: CGFloat
    public let tracking: CGFloat
    public let kerning: CGFloat
    public let color: Color?

    public init(font: AccessibleStaticFont, lineSpacing: CGFloat = 0, tracking: CGFloat = 0, kerning: CGFloat = 0, color: Color? = nil) {
        self.font = font
        self.lineSpacing = lineSpacing
        self.tracking = tracking
        self.kerning = kerning
        self.color = color
    }

    public init(dynamicFont: Font, lineSpacing: CGFloat = 0, tracking: CGFloat = 0, kerning: CGFloat = 0, color: Color? = nil) {
        self.init(font: AccessibleStaticFont(regular: dynamicFont, bold: dynamicFont),
                  lineSpacing: lineSpacing,
                  tracking: tracking,
                  kerning: kerning,
                  color: color)
    }

    @MainActor
    public func body(_ view: Text) -> some View {
        return view
            .tracking(tracking)
            .kerning(kerning)
            .lineSpacing(lineSpacing)
            .font(font)
            .foregroundColorIfSet(color)
    }
}

struct TextishViewModifier: ViewModifier {
    let format: TextFormat

    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            return content
                .tracking(format.tracking)
                .kerning(format.kerning)
                .lineSpacing(format.lineSpacing)
                .font(format.font)
                .foregroundColorIfSet(format.color)
        } else {
            return content
                .lineSpacing(format.lineSpacing)
                .font(format.font)
                .foregroundColorIfSet(format.color)
        }
    }
}

public extension View {
    func textStyle(_ style: TextFormat) -> some View {
        return modifier(TextishViewModifier(format: style))
    }
}
