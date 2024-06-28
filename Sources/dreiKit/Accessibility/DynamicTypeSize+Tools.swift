//
//  DynamicTypeSize+Tools.swift
//  Barryvox
//
//  Created by Laila Becker on 26.06.2024.
//  Copyright © 2024 dreipol GmbH. All rights reserved.
//

import SwiftUI

public extension DynamicTypeSize {
    func disallowAccessibilitySizes() -> Self {
        guard isAccessibilitySize else {
            return self
        }

        return Self.allCases.filter { !$0.isAccessibilitySize }.max() ?? self
    }
}

private struct LimitDynamicSize: ViewModifier {
    var maxSize: DynamicTypeSize

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    func body(content: Content) -> some View {
        content
            .dynamicTypeSize(max(dynamicTypeSize, maxSize))
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
