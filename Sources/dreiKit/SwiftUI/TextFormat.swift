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
    public let font: Font
    public let lineSpacing: CGFloat
    public let tracking: CGFloat
    public let kerning: CGFloat
    public let color: Color?

    public init(font: Font, lineSpacing: CGFloat = 0, tracking: CGFloat = 0, kerning: CGFloat = 0, color: Color? = nil) {
        self.font = font
        self.lineSpacing = lineSpacing
        self.tracking = tracking
        self.kerning = kerning
        self.color = color
    }

    public func body(_ view: Text) -> some View {
        return view
            .font(font)
            .tracking(tracking)
            .kerning(kerning)
            .lineSpacing(lineSpacing)
            .foregroundColorIfSet(color)
    }
}

struct TextishViewModifier: ViewModifier {
    let format: TextFormat

    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            return content
                .font(format.font)
                .tracking(format.tracking)
                .kerning(format.kerning)
                .lineSpacing(format.lineSpacing)
                .foregroundColorIfSet(format.color)
        } else {
            return content
                .font(format.font)
                .lineSpacing(format.lineSpacing)
                .foregroundColorIfSet(format.color)
        }
    }
}

public extension View {
    func textStyle(_ style: TextFormat) -> some View {
        return modifier(TextishViewModifier(format: style))
    }
}
