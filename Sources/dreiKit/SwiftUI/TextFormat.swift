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

public struct TextFormat: TextModifier, Equatable {
    let font: Font
    let lineSpacing: CGFloat
    let tracking: CGFloat
    
    public init(font: Font, lineSpacing: CGFloat, tracking: CGFloat) {
        self.font = font
        self.lineSpacing = lineSpacing
        self.tracking = tracking
    }
    
    public func body(_ view: Text) -> some View {
        return view
            .font(font)
            .tracking(tracking)
            .lineSpacing(lineSpacing)
    }
}
