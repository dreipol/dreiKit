//
//  CustomTabItem.swift
//  Barryvox
//
//  Created by Laila Becker on 26.06.2024.
//  Copyright © 2024 Mammut Sports Group AG. All rights reserved.
//

import SwiftUI

public struct CustomTabItem<Tag: Hashable>: View {
    var label: () -> AnyView
    var content: () -> AnyView
    var tag: Tag

    private(set) var disabled = false

    fileprivate init(label: @escaping () -> AnyView, content: @escaping () -> AnyView, tag: Tag) {
        self.label = label
        self.content = content
        self.tag = tag
    }

    public var body: some View {
        content()
    }

    public func disabled(_ disabled: Bool = true) -> Self {
        var copy = self
        copy.disabled = disabled
        return copy
    }
}

public extension View {
    func customTabItem<Tag: Hashable, Label: View>(for tag: Tag, @ViewBuilder label: @escaping () -> Label) -> CustomTabItem<Tag> {
        CustomTabItem(label: { AnyView(erasing: label()) }, content: { AnyView(erasing: self) }, tag: tag)
    }
}

@resultBuilder
struct TabsBuilder<Tag: Hashable> {
    static func buildBlock(_ components: [CustomTabItem<Tag>]...) -> [CustomTabItem<Tag>] { Array(components.joined()) }

    static func buildExpression(_ expression: CustomTabItem<Tag>) -> [CustomTabItem<Tag>] { [expression] }

    static func buildArray(_ components: [[CustomTabItem<Tag>]]) -> [CustomTabItem<Tag>] { Array(components.joined()) }

    static func buildOptional(_ component: [CustomTabItem<Tag>]?) -> [CustomTabItem<Tag>] { component ?? [] }

    static func buildEither(first component: [CustomTabItem<Tag>]) -> [CustomTabItem<Tag>] { component }

    static func buildEither(second component: [CustomTabItem<Tag>]) -> [CustomTabItem<Tag>] { component }

    static func buildLimitedAvailability(_ component: [CustomTabItem<Tag>]) -> [CustomTabItem<Tag>] { component }
}

public struct TabItemConfiguration {
    var label: AnyView
    var isPressed: Bool
    var isSelected: Bool
}

public protocol TabItemStyle {
    associatedtype Result: View

    func makeBody(configuration: Configuration) -> Result

    typealias Configuration = TabItemConfiguration
}

public struct NoneTabItemStyle: TabItemStyle {
    static let none: Self = NoneTabItemStyle()

    private init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(configuration.isSelected ? AnyShapeStyle(.selection) : AnyShapeStyle(.quaternary))
    }
}
