//
//  RandomShape.swift
//
//
//  Created by Samuel Bichsel on 07.08.23.
//

import SwiftUI

public struct RandomShape: View {
    private let randomNumber: Int

    public init() {
        randomNumber = Int.random(in: 0 ..< 4)
    }

    public init(deterministic seed: Int) {
        randomNumber = abs(seed) % 5
    }

    public var body: some View {
        switch randomNumber {
        case 0:
            Circle()
        case 1:
            Polygon(sides: 3)
        case 2:
            Polygon(sides: 4)
        default:
            Polygon(sides: 6)
        }
    }
}

// Copied from https://blog.techchee.com/how-to-create-custom-shapes-in-swiftui/
public struct Polygon: Shape {
    var sides: Int = 5

    public func path(in rect: CGRect) -> Path {
        // get the center point and the radius
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = rect.width / 2

        // get the angle in radian,
        // 2 pi divided by the number of sides
        let angle = Double.pi * 2 / Double(sides)
        var path = Path()
        var startPoint = CGPoint(x: 0, y: 0)

        for side in 0 ..< sides {
            let x = center.x + CGFloat(cos(Double(side) * angle)) * CGFloat(radius)
            let y = center.y + CGFloat(sin(Double(side) * angle)) * CGFloat(radius)

            let vertexPoint = CGPoint(x: x, y: y)

            if side == 0 {
                startPoint = vertexPoint
                path.move(to: startPoint)
            } else {
                path.addLine(to: vertexPoint)
            }

            // move back to starting point
            // needed for stroke
            if side == (sides - 1) {
                path.addLine(to: startPoint)
            }
        }

        return path
    }
}

struct RandomShape_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            RandomShape()
                .foregroundColor(Color.red)
                .frame(width: 100)
            RandomShape()
                .foregroundColor(Color.green)
                .frame(width: 100)
            RandomShape()
                .foregroundColor(Color.blue)
                .frame(width: 100)
            RandomShape()
                .foregroundColor(Color.yellow)
                .frame(width: 100)
            RandomShape()
                .foregroundColor(Color.purple)
                .frame(width: 100)
        }.foregroundColor(.red)
    }
}
