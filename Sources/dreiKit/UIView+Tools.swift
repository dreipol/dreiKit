//
//  UIView+Tools.swift
//  dreiKit
//
//  Created by Simon Müller on 18.09.19.
//  Copyright © 2019 dreipol. All rights reserved.
//

import UIKit

public extension UIView {

    class func verticalLine() -> UIView {
        let view = UIView.autoLayout()
        view.isUserInteractionEnabled = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }

    class func horizontalLine() -> UIView {
        let view = UIView.autoLayout()
        view.isUserInteractionEnabled = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }

    func randomColorForSubviews(alpha: CGFloat = 1) {
        for view in subviews {
            view.backgroundColor = .random
            view.alpha = alpha
        }
        backgroundColor = .random
    }
}


public extension UIView {

    // Scale and rotate does not work combined when animating
    // In this case chain it manually together

    func scale(_ scale: CGFloat) {
        transform = CGAffineTransform(scaleX: scale, y: scale)
        //        transform = transform.scaledBy(x: scale, y: scale)
    }

    func rotate(_ degree: CGFloat) {
        transform = CGAffineTransform(rotationAngle: CGFloat.radiansFrom(degree: degree))
        //        transform = transform.rotated(by: CGFloat(angle))
    }
}
