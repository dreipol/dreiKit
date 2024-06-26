//
//  DynamicTypeSize+Tools.swift
//  Barryvox
//
//  Created by Laila Becker on 26.06.2024.
//  Copyright © 2024 Mammut Sports Group AG. All rights reserved.
//

import SwiftUI

public extension DynamicTypeSize {
    func disallowAccessibilitySizes() -> Self {
        guard isAccessibilitySize else {
            return self
        }

        return Self.allCases.filter { !$0.isAccessibilitySize }.max() ?? self
    }

    func atMost(_ size: Self) -> Self {
        guard self > size else {
            return self
        }

        return size
    }
}

private struct LimitDynamicSize: ViewModifier {
    var maxSize: DynamicTypeSize

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    func body(content: Content) -> some View {
        content
            .dynamicTypeSize(dynamicTypeSize.atMost(maxSize))
    }
}

private struct DisableAccessibilityDynamicTypeSizes: ViewModifier {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    func body(content: Content) -> some View {
        content
            .dynamicTypeSize(dynamicTypeSize.disallowAccessibilitySizes())
    }
}

public extension View {
    func limitDynamicTypeSize(to maxSize: DynamicTypeSize) -> some View {
        modifier(LimitDynamicSize(maxSize: maxSize))
    }

    func disableAccessiblityDynamicTypeSizes() -> some View {
        modifier(DisableAccessibilityDynamicTypeSizes())
    }
}
