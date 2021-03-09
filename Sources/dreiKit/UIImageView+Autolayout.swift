//
//  UIImage+Manipulation.swift
//  dreiKit
//
//  Created by Samuel Bichsel on 05.03.21.
//

import UIKit

public extension UIImageView {
    class func autoLayout(image: UIImage?) -> Self {
        let imageView = autoLayout()
        imageView.image = image
        return imageView
    }
}
