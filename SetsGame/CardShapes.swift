//
//  CardShapes.swift
//  SetsGame
//
//  Created by Hadi Laasi on 15/06/2020.
//  Copyright © 2020 Hadi Laasi. All rights reserved.
//

import SwiftUI

struct Squiggle: Shape {
    func path(in rect: CGRect) -> Path {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let height: CGFloat = 20
        let start = CGPoint (
            x: center.x,
            y: center.y + (height / 2)
        )
        let topRight = CGPoint (
            x: start.x + radius,
            y: start.y
        )
        let bottomRight = CGPoint (
            x: topRight.x,
            y: topRight.y - height
        )
        let bottomLeft = CGPoint(
            x: start.x - radius,
            y: bottomRight.y
        )
        let topLeft = CGPoint (
            x: bottomLeft.x,
            y: bottomLeft.y + height
        )
        
        var p = Path()
        
        p.move(to: start)
        p.addLine(to: topRight)
        p.addLine(to: bottomRight)
        p.addLine(to: bottomLeft)
        p.addLine(to: topLeft)
        p.addLine(to: start)
        
        return p
    }
}

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint (
            x: center.x,
            y: center.y + radius
        )
        let rightPoint = CGPoint (
            x: center.x + radius,
            y: center.y
        )
        let bottomPoint = CGPoint (
            x: center.x,
            y: center.y - radius
        )
        let leftPoint = CGPoint (
            x: center.x - radius,
            y: center.y
        )
        
        
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addLine(to: rightPoint)
        p.addLine(to: bottomPoint)
        p.addLine(to: leftPoint)
        p.addLine(to: start)
        
        return p
    }
}

struct Oval: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius,
            y: center.y + radius
        )
        
        
        var p = Path()
        p.move(to: start)
        p.addArc(center: center, radius: radius, startAngle: .degrees(0), endAngle: .degrees(1), clockwise: true) //TODO: This feels very hacky -- I don't really understand why .degrees(0) as an end point doesn't work
        return p
    }
}
