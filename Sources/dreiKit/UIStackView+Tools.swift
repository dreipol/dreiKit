//
//  UIStackView+Tools.swift
//  dreiKit
//
//  Created by Simon Müller on 17.09.19.
//  Copyright © 2019 dreipol. All rights reserved.
//

import UIKit.UIStackView
import UIKit.NSLayoutConstraint

public extension UIStackView {

    static func autoLayout(axis: NSLayoutConstraint.Axis) -> Self {
        let stackView = autoLayout()
        stackView.axis = axis
        return stackView
    }

    func addSpace(_ height: CGFloat) {
        let view = UIView()
        view.isUserInteractionEnabled = false
        let anchor = self.axis == .horizontal ? view.widthAnchor : view.heightAnchor
        anchor.constraint(equalToConstant: height).isActive = true
        addArrangedSubview(view)
    }

    func removeArrangedView(_ view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }

    func removeAllArrangedSubviews() {
        for view in arrangedSubviews {
            removeArrangedView(view)
        }
    }
}
