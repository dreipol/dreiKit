//
//  UIEdgeInsets+Tools.swift
//  Barryvox
//
//  Created by Laila Becker on 26.06.2024.
//  Copyright © 2024 Mammut Sports Group AG. All rights reserved.
//

import SwiftUI
import UIKit

public extension UIEdgeInsets {
    init(edgeInsets: EdgeInsets, layoutDirection: LayoutDirection) {
        switch layoutDirection {
        case .rightToLeft:
            self.init(top: edgeInsets.top, left: edgeInsets.trailing, bottom: edgeInsets.bottom, right: edgeInsets.leading)
        case .leftToRight:
            fallthrough
        @unknown default:
            self.init(top: edgeInsets.top, left: edgeInsets.leading, bottom: edgeInsets.bottom, right: edgeInsets.trailing)
        }
    }

    static func - (minuend: UIEdgeInsets, subtrahend: UIEdgeInsets) -> UIEdgeInsets {
        UIEdgeInsets(top: minuend.top - subtrahend.top,
                     left: minuend.left - subtrahend.left,
                     bottom: minuend.bottom - subtrahend.bottom,
                     right: minuend.right - subtrahend.right)
    }
}
