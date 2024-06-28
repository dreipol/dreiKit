//
//  CustomTabItem.swift
//  Barryvox
//
//  Created by Laila Becker on 26.06.2024.
//  Copyright © 2024 dreipol GmbH. All rights reserved.
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
public struct TabsBuilder<Tag: Hashable> {
    public static func buildBlock(_ components: [CustomTabItem<Tag>]...) -> [CustomTabItem<Tag>] { Array(components.joined()) }
    public static func buildExpression(_ expression: CustomTabItem<Tag>) -> [CustomTabItem<Tag>] { [expression] }
    public static func buildArray(_ components: [[CustomTabItem<Tag>]]) -> [CustomTabItem<Tag>] { Array(components.joined()) }
    public static func buildOptional(_ component: [CustomTabItem<Tag>]?) -> [CustomTabItem<Tag>] { component ?? [] }
    public static func buildEither(first component: [CustomTabItem<Tag>]) -> [CustomTabItem<Tag>] { component }
    public static func buildEither(second component: [CustomTabItem<Tag>]) -> [CustomTabItem<Tag>] { component }
    public static func buildLimitedAvailability(_ component: [CustomTabItem<Tag>]) -> [CustomTabItem<Tag>] { component }
}

public struct TabItemConfiguration {
    public var label: AnyView
    public var isPressed: Bool
    public var isSelected: Bool
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
