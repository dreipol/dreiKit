//
//  OrderedList.swift
//  dreiKit
//
//  Created by Laila Becker on 23.01.2025.
//

import SwiftUI

private extension HorizontalAlignment {
    private enum NumberedListAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[HorizontalAlignment.leading]
        }
    }

    static let numberedListAlignment = HorizontalAlignment(NumberedListAlignment.self)
}

@resultBuilder
public struct OrderedListBuilder {
    public static func buildBlock(_ components: [AnyView]...) -> [AnyView] { Array(components.joined()) }
    public static func buildExpression<V: View>(_ expression: V) -> [AnyView] { [AnyView(erasing: expression)] }
    public static func buildArray(_ components: [[AnyView]]) -> [AnyView] { Array(components.joined()) }
    public static func buildOptional(_ component: [AnyView]?) -> [AnyView] { component ?? [] }
    public static func buildEither(first component: [AnyView]) -> [AnyView] { component }
    public static func buildEither(second component: [AnyView]) -> [AnyView] { component }
    public static func buildLimitedAvailability(_ component: [AnyView]) -> [AnyView] { component }
}

public struct OrderedList<Label>: View where Label: View {
    var labelGenerator: (Int) -> Label
    var labelSpacing: CGFloat?
    var itemSpacing: CGFloat?
    var items: [AnyView]

    init(labelGenerator: @escaping (Int) -> Label,
         labelSpacing: CGFloat? = nil,
         itemSpacing: CGFloat? = nil,
         @OrderedListBuilder items: () -> [AnyView]) {
        self.labelGenerator = labelGenerator
        self.labelSpacing = labelSpacing
        self.itemSpacing = itemSpacing
        self.items = items()
    }

    public var body: some View {
        VStack(alignment: .numberedListAlignment, spacing: itemSpacing) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                HStack(alignment: .firstTextBaseline, spacing: labelSpacing) {
                    labelGenerator(index)
                        .alignmentGuide(.numberedListAlignment) { $0[.trailing] }
                    item
                }
            }
        }
    }
}

public extension OrderedList where Label == Text {
    init(labelSpacing: CGFloat? = nil, itemSpacing: CGFloat? = nil, @OrderedListBuilder items: () -> [AnyView]) {
        self.init(labelGenerator: { Text("\($0 + 1).") }, labelSpacing: labelSpacing, itemSpacing: itemSpacing, items: items)
    }
}
