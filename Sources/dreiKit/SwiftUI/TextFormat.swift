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

private extension View {
    @ViewBuilder func foregroundColorIfSet(_ color: Color?) -> some View {
        if let c = color {
            self.foregroundColor(c)
        } else {
            self
        }
    }
}

public struct TextFormat: TextModifier, Equatable {
    let font: Font
    let lineSpacing: CGFloat
    let tracking: CGFloat
    let kerning: CGFloat
    let color: Color?

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
