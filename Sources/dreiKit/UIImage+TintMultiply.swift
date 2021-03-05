//
//  UIImage+TintMultiply.swift
//  dreiKit
//
//  Created by Samuel Bichsel on 05.03.21.
//

import UIKit.UIImage

public extension UIImage {
    func withTintByMultiply(with color: UIColor) -> UIImage {
        defer { UIGraphicsEndImageContext() }

        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext(), let cgImage = cgImage else {
            return self
        }

        // flip the image
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -size.height)

        // multiply blend mode
        context.setBlendMode(.multiply)

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: cgImage)
        color.setFill()
        context.fill(rect)

        // create UIImage
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return self
        }

        return newImage
    }
}
