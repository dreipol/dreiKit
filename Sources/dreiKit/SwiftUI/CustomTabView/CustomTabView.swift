//
//  CustomTabbar.swift
//  Barryvox
//
//  Created by Laila Becker on 18.06.2024.
//  Copyright © 2024 dreipol GmbH. All rights reserved.
//

import SwiftUI
import UIKit

private struct VerticalLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.icon
            configuration.title
        }
    }
}

public enum HorizontalTabBarExpansionMode {
    case fill
    case fixedPadded(leading: CGFloat, trailing: CGFloat)

    public static func fixedPadded(horizontal: CGFloat) -> HorizontalTabBarExpansionMode {
        .fixedPadded(leading: horizontal, trailing: horizontal)
    }
}

private extension View {
    @ViewBuilder func applyExpansionMode(_ mode: HorizontalTabBarExpansionMode) -> some View {
        switch mode {
        case .fill:
            self
                .frame(maxWidth: .infinity)
        case .fixedPadded(leading: let leading, trailing: let trailing):
            self
                .padding(.leading, leading)
                .padding(.trailing, trailing)
        }
    }
}

private extension View {
    func apply<Style: TabItemStyle>(tabItemStyle: Style, isPressed: Bool, isSelected: Bool) -> some View {
        let configuration = TabItemConfiguration(label: AnyView(erasing: self), isPressed: isPressed, isSelected: isSelected)
        return tabItemStyle.makeBody(configuration: configuration)
    }
}

private struct TabItemButtonStyle<ItemStyle: TabItemStyle>: ButtonStyle {
    let tabItemStyle: ItemStyle
    var isSelected: Bool

    @Environment(\.accessibilityShowButtonShapes) private var showButtonShapes
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast

    private var contrast: Double {
        switch colorSchemeContrast {
        case .standard: return 1
        case .increased: return 5
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .apply(tabItemStyle: tabItemStyle, isPressed: configuration.isPressed, isSelected: isSelected)
            .background {
                if showButtonShapes && isSelected {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.tint)
                        .opacity(0.3)
                }
            }
            .contrast(contrast)
            .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

public struct CustomTabView<Tag: Hashable, ItemStyle: TabItemStyle, BarBackground: ViewModifier>: View {
    @Binding var selection: Tag
    let tabs: [CustomTabItem<Tag>]

    private var tabItemStyle: ItemStyle
    private var backgroundModifier: BarBackground
    private var topPadding: CGFloat
    private var bottomPadding: CGFloat
    private var expansionMode: HorizontalTabBarExpansionMode
    private var barHidden: Bool = false

    @State private var bottomSafeArea: CGFloat = 0

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    fileprivate init(selection: Binding<Tag>,
                     tabs: [CustomTabItem<Tag>],
                     tabItemStyle: ItemStyle,
                     backgroundModifier: BarBackground,
                     topPadding: CGFloat,
                     bottomPadding: CGFloat,
                     expansionMode: HorizontalTabBarExpansionMode) {
        _selection = selection
        self.tabs = tabs
        self.tabItemStyle = tabItemStyle
        self.backgroundModifier = backgroundModifier
        self.topPadding = topPadding
        self.bottomPadding = bottomPadding
        self.expansionMode = expansionMode
    }

    public var body: some View {
        GeometryReader { geo in
            CachedViews(tabs: tabs, selectedTab: selection, safeArea: geo.safeAreaInsets)
                .ignoresSafeArea()
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if !barHidden {
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    ForEach(tabs, id: \.tag) { tab in
                        Button {
                            selection = tab.tag
                        } label: {
                            tab.label()
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(TabItemButtonStyle(tabItemStyle: tabItemStyle, isSelected: tab.tag == selection))
                        .disabled(tab.disabled)
                        .accessibilityShowsLargeContentViewer {
                            tab.label()
                                .apply(tabItemStyle: tabItemStyle, isPressed: false, isSelected: false)
                        }
                    }
                }
                .labelStyle(VerticalLabelStyle())
                .applyExpansionMode(expansionMode)
                .modifier(backgroundModifier)
                .shadow(color: .black.opacity(0.2), radius: 10)
                .shadow(color: .black.opacity(0.12), radius: 30)
                .padding(.top, topPadding)
                .padding(.bottom, bottomPadding)
                .background {
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                bottomSafeArea = geo.safeAreaInsets.bottom + geo.size.height
                            }
                            .onChange(of: geo.safeAreaInsets.bottom + geo.size.height) { newValue in
                                bottomSafeArea = newValue
                            }
                    }
                }
                .transition(reduceMotion ? .opacity : .offset(y: bottomSafeArea))
                .disableAccessibilityDynamicTypeSizes()
            }
        }
    }
}

public extension CustomTabView {
    func tabBarPadding(top: CGFloat? = nil, bottom: CGFloat? = nil) -> Self {
        var copy = self
        if let top {
            copy.topPadding = top
        }
        if let bottom {
            copy.bottomPadding = bottom
        }
        return copy
    }

    func tabBar(horizontalMode: HorizontalTabBarExpansionMode) -> Self {
        var copy = self
        copy.expansionMode = horizontalMode
        return copy
    }

    func tabBarHidden(_ hidden: Bool = true) -> Self {
        var copy = self
        copy.barHidden = hidden
        return copy
    }
}

public extension CustomTabView where ItemStyle == NoneTabItemStyle, BarBackground == StyledBackgroundModifier<BackgroundStyle> {
    init(selection: Binding<Tag>, @TabsBuilder<Tag> tabs: () -> [CustomTabItem<Tag>]) {
        self.init(selection: selection,
                  tabs: tabs(),
                  tabItemStyle: .none,
                  backgroundModifier: StyledBackgroundModifier(style: .background),
                  topPadding: 0,
                  bottomPadding: 0,
                  expansionMode: .fill
        )
    }
}

public extension CustomTabView {
    func tabBarBackground<S, T>(_ style: S, in shape: T, fillStyle: FillStyle = FillStyle()) ->
    CustomTabView<Tag, ItemStyle, FullyStyledBackgroundModifier<S, T>> where S: ShapeStyle, T: Shape {
        let modifier = FullyStyledBackgroundModifier(style: style, shape: shape, fillStyle: fillStyle)
        return CustomTabView<Tag, ItemStyle, FullyStyledBackgroundModifier<S, T>>(selection: _selection,
                                                                                  tabs: tabs,
                                                                                  tabItemStyle: tabItemStyle,
                                                                                  backgroundModifier: modifier,
                                                                                  topPadding: topPadding,
                                                                                  bottomPadding: bottomPadding,
                                                                                  expansionMode: expansionMode
        )
    }

    func tabBarBackground<S>(_ style: S) ->
    CustomTabView<Tag, ItemStyle, StyledBackgroundModifier<S>> where S: ShapeStyle {
        let modifier = StyledBackgroundModifier(style: style)
        return CustomTabView<Tag, ItemStyle, StyledBackgroundModifier<S>>(selection: _selection,
                                                                          tabs: tabs,
                                                                          tabItemStyle: tabItemStyle,
                                                                          backgroundModifier: modifier,
                                                                          topPadding: topPadding,
                                                                          bottomPadding: bottomPadding,
                                                                          expansionMode: expansionMode
        )
    }

    func tabBarBackground<T>(in shape: T, fillStyle: FillStyle = FillStyle()) ->
    CustomTabView<Tag, ItemStyle, ShapedBackgroundModifier<T>> where T: Shape {
        let modifier = ShapedBackgroundModifier(shape: shape, fillStyle: fillStyle)
        return CustomTabView<Tag, ItemStyle, ShapedBackgroundModifier<T>>(selection: _selection,
                                                                          tabs: tabs,
                                                                          tabItemStyle: tabItemStyle,
                                                                          backgroundModifier: modifier,
                                                                          topPadding: topPadding,
                                                                          bottomPadding: bottomPadding,
                                                                          expansionMode: expansionMode
        )
    }

    func tabBarBackground<Background: View>(alignment: Alignment = .center, @ViewBuilder content: @escaping () -> Background) ->
    CustomTabView<Tag, ItemStyle, ViewBackgroundModifier<Background>> {
        let modifier = ViewBackgroundModifier(alignment: alignment, background: content)
        return CustomTabView<Tag, ItemStyle, ViewBackgroundModifier<Background>>(selection: _selection,
                                                                                 tabs: tabs,
                                                                                 tabItemStyle: tabItemStyle,
                                                                                 backgroundModifier: modifier,
                                                                                 topPadding: topPadding,
                                                                                 bottomPadding: bottomPadding,
                                                                                 expansionMode: expansionMode
        )
    }
}

public extension CustomTabView {
    func tabItemStyle<Style>(_ style: Style) -> CustomTabView<Tag, Style, BarBackground> {
        return CustomTabView<Tag, Style, BarBackground>(selection: _selection,
                                                        tabs: tabs,
                                                        tabItemStyle: style,
                                                        backgroundModifier: backgroundModifier,
                                                        topPadding: topPadding,
                                                        bottomPadding: bottomPadding,
                                                        expansionMode: expansionMode)
    }
}
