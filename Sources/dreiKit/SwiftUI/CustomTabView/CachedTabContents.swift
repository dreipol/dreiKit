//
//  CachedTabContents.swift
//  Barryvox
//
//  Created by Laila Becker on 26.06.2024.
//  Copyright © 2024 dreipol GmbH. All rights reserved.
//

import SwiftUI
import UIKit

/// Lazily loads the views and avoids resetting their states if the view is hidden and shown again.
class CachedHostingController<Tag: Hashable>: UIViewController {
    private var cache: [Tag: UIHostingController<AnyView>] = [:]
    var tabs: [CustomTabItem<Tag>]
    var selectedTab: Tag {
        didSet {
            update()
        }
    }

    init(tabs: [CustomTabItem<Tag>], selectedTab: Tag) {
        self.tabs = tabs
        self.selectedTab = selectedTab
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        update()
    }

    @MainActor
    private func update() {
        let controller: UIHostingController<AnyView>
        if let cached = cache[selectedTab] {
            controller = cached
        } else if let tabItem = tabs.first(where: { $0.tag == selectedTab }) {
            controller = UIHostingController(rootView: tabItem.content())
            cache[selectedTab] = controller
        } else {
            controller = UIHostingController(rootView: AnyView(erasing: Color.clear))
            cache[selectedTab] = controller
        }

        children.forEach {
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
        addChild(controller)
        view.addSubview(controller.view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.fillSuperview()
    }
}

struct CachedViews<Tag: Hashable>: UIViewControllerRepresentable {
    typealias UIViewControllerType = CachedHostingController<Tag>

    let tabs: [CustomTabItem<Tag>]
    var selectedTab: Tag
    var safeArea: EdgeInsets

    @Environment(\.layoutDirection) private var layoutDirection

    func makeUIViewController(context: Context) -> CachedHostingController<Tag> {
        let controller = CachedHostingController(tabs: tabs, selectedTab: selectedTab)
        let existingInsets = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets ?? .zero
        controller.additionalSafeAreaInsets = UIEdgeInsets(edgeInsets: safeArea, layoutDirection: layoutDirection) - existingInsets
        return controller
    }

    func updateUIViewController(_ uiViewController: CachedHostingController<Tag>, context: Context) {
        if uiViewController.selectedTab != selectedTab {
            uiViewController.selectedTab = selectedTab
        }
        let existingInsets = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets ?? .zero
        uiViewController.additionalSafeAreaInsets = UIEdgeInsets(edgeInsets: safeArea, layoutDirection: layoutDirection) - existingInsets
    }
}
