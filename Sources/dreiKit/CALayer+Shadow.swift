//
//  CALayer+Shadow.swift
//  Multiplatform Redux Sample
//
//  Created by Julia Strasser on 15.01.21.
//

import UIKit

public extension CALayer {
  func addShadow(
    color: UIColor,
    x: CGFloat,
    y: CGFloat,
    blur: CGFloat,
    spread: CGFloat) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = 1
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
          shadowPath = nil
        } else {
          let dx = -spread
          let rect = bounds.insetBy(dx: dx, dy: dx)
          shadowPath = UIBezierPath(rect: rect).cgPath
        }
        shouldRasterize = true
        rasterizationScale = UIScreen.main.scale
  }
}
