//
//  UIImage+Manipulation.swift
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

    //   https://stackoverflow.com/questions/20021478/add-transparent-space-around-a-uiimage
    func withPadding(_ padding: CGFloat) -> UIImage? {
        return withPadding(x: padding, y: padding)
    }

    func withPadding(x: CGFloat, y: CGFloat) -> UIImage? {
        let newWidth = size.width + 2 * x
        let newHeight = size.height + 2 * y
        let newSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        let origin = CGPoint(x: (newWidth - size.width) / 2, y: (newHeight - size.height) / 2)
        draw(at: origin)
        let imageWithPadding = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageWithPadding
    }

    func doubleHeight() -> UIImage {
        defer { UIGraphicsEndImageContext() }

        let newHeight = size.height * 2
        let newSize = CGSize(width: size.width, height: newHeight)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        let origin = CGPoint(x: 0, y: 0)
        draw(at: origin)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return self
        }

        return newImage
    }

    func transparentImageBackgroundTo(_ color: UIColor) -> UIImage {
        defer { UIGraphicsEndImageContext() }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let imageRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return self
        }
        ctx.setFillColor(color.cgColor)
//        ctx.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ctx.fill(imageRect)
        // Apply the source self's alpha
        draw(in: imageRect, blendMode: .normal, alpha: 1.0)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return self
        }
        return newImage
    }
}
