//
//  ViewWithShadow.swift
//  Multiplatform Redux Sample
//
//  Created by Nils Becker on 22.04.21.
//

import UIKit

public class ViewWithShadow: UIView {
    public let color: UIColor
    public let x: CGFloat
    public let y: CGFloat
    public let blur: CGFloat
    public let spread: CGFloat

    public init(color: UIColor,
                x: CGFloat,
                y: CGFloat,
                blur: CGFloat,
                spread: CGFloat) {
        self.color = color
        self.x = x
        self.y = y
        self.blur = blur
        self.spread = spread

        super.init(frame: .zero)
        layer.addShadow(color: color, x: x, y: y, blur: blur, spread: spread)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        DispatchQueue.main.async { [weak self] in
            self?.updateShadow()
        }
    }

    public func updateShadow() {
        layer.addShadow(color: color, x: x, y: y, blur: blur, spread: spread)
    }
}
