//
//  Icon.swift
//  Barryvox
//
//  Created by Laila Becker on 26.06.2024.
//  Copyright © 2024 Mammut Sports Group AG. All rights reserved.
//

import SwiftUI

public struct Icon: View {
    var name: String
    @ScaledMetric private var width: CGFloat
    @ScaledMetric private var height: CGFloat

    public init(_ name: String, size: CGSize? = nil, relativeTo: Font.TextStyle = .body) {
        self.name = name
        let unscaledSize = size ?? Self.getSize(name: name)
        _width = ScaledMetric(wrappedValue: unscaledSize.width, relativeTo: relativeTo)
        _height = ScaledMetric(wrappedValue: unscaledSize.height, relativeTo: relativeTo)
    }

    public var body: some View {
        Image(name)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
    }

    private static func getSize(name: String) -> CGSize {
        guard let image = UIImage(named: name) else {
            return .zero
        }

        return image.size
    }
}

public extension Icon {
    init(_ name: String, size: CGFloat, relativeTo: Font.TextStyle = .body) {
        self.init(name, size: CGSize(width: size, height: size), relativeTo: relativeTo)
    }
}
