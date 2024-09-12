//
//  View+ReadSize.swift
//
//  Created by Laila Becker on 02.05.2024.
//  Copyright © 2024 dreipol GmbH. All rights reserved.
//

import SwiftUI

private struct HideViewWithHeight: ViewModifier {
    var minHeight: CGFloat

    @State private var currentHeight: CGFloat

    init(minHeight: CGFloat) {
        self.minHeight = minHeight
        _currentHeight = State(initialValue: minHeight)
    }

    func body(content: Content) -> some View {
        if currentHeight >= minHeight {
            content
                .readHeight(into: $currentHeight)
        }
    }
}

private struct HideViewWithWidth: ViewModifier {
    var minWidth: CGFloat

    @State private var currentWidth: CGFloat

    init(minWidth: CGFloat) {
        self.minWidth = minWidth
        _currentWidth = State(initialValue: minWidth)
    }

    func body(content: Content) -> some View {
        content
            .layoutPriority(-.infinity)
            .readWidth(into: $currentWidth)
            .opacity(currentWidth >= minWidth ? 1 : 0)
    }
}

public extension View {
    func readSize(into binding: Binding<CGSize>) -> some View {
        background {
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        binding.wrappedValue = geo.size
                    }
                    .onChange(of: geo.size) { newValue in
                        binding.wrappedValue = newValue
                    }
            }
        }
    }

    func readHeight(into binding: Binding<CGFloat>) -> some View {
        background {
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        binding.wrappedValue = geo.size.height
                    }
                    .onChange(of: geo.size.height) { newValue in
                        binding.wrappedValue = newValue
                    }
            }
        }
    }

    func readWidth(into binding: Binding<CGFloat>) -> some View {
        background {
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        binding.wrappedValue = geo.size.width
                    }
                    .onChange(of: geo.size.width) { newValue in
                        binding.wrappedValue = newValue
                    }
            }
        }
    }

    func hiddenWhenHeightInsufficient(minHeight: CGFloat) -> some View {
        modifier(HideViewWithHeight(minHeight: minHeight))
    }

    func hiddenWhenWidthInsufficient(minWidth: CGFloat) -> some View {
        modifier(HideViewWithWidth(minWidth: minWidth))
    }
}
