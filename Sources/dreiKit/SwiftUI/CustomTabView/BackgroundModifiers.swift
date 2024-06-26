//
//  BackgroundModifiers.swift
//  Barryvox
//
//  Created by Laila Becker on 26.06.2024.
//  Copyright © 2024 dreipol GmbH. All rights reserved.
//

import SwiftUI

public struct FullyStyledBackgroundModifier<S, T>: ViewModifier where S: ShapeStyle, T: Shape {
    let style: S
    let shape: T
    let fillStyle: FillStyle

    init(style: S, shape: T, fillStyle: FillStyle) {
        self.style = style
        self.shape = shape
        self.fillStyle = fillStyle
    }

    public func body(content: Content) -> some View {
        content
            .background(style, in: shape, fillStyle: fillStyle)
    }
}

public struct StyledBackgroundModifier<S>: ViewModifier where S: ShapeStyle {
    let style: S

    init(style: S) {
        self.style = style
    }

    public func body(content: Content) -> some View {
        content
            .background(style)
    }
}

public struct ShapedBackgroundModifier<T>: ViewModifier where T: Shape {
    let shape: T
    let fillStyle: FillStyle

    init(shape: T, fillStyle: FillStyle) {
        self.shape = shape
        self.fillStyle = fillStyle
    }

    public func body(content: Content) -> some View {
        content
            .background(in: shape, fillStyle: fillStyle)
    }
}

public struct ViewBackgroundModifier<Background: View>: ViewModifier {
    let alignment: Alignment
    let background: () -> Background

    init(alignment: Alignment, background: @escaping () -> Background) {
        self.alignment = alignment
        self.background = background
    }

    public func body(content: Content) -> some View {
        content
            .background(alignment: alignment, content: background)
    }
}
