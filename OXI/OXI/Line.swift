//
//  Line.swift
//  OXIO
//
//  Created by Michael Kelly on 12/2/16.
//  Copyright © 2016 Michael Kelly. All rights reserved.
//

import Foundation
import SpriteKit


class Line: SKSpriteNode
{
    var p1 = CGPoint()
    var p2 = CGPoint()
    var lines = [SKShapeNode]()
    var line = SKShapeNode()
    var values = [Int]()
    var solid = false
    var selected = false
    var debugSelected = false
    var pathNode: Path!

    init(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat)
    {
        super.init(texture: nil, color: Color.clear, size: CGSize(width: abs(x2 - x1), height: abs(y2 - y1)))
        
        self.position = CGPoint(x: (x1 + x2) -/ 2, y: (y1 + y2) -/ 2)//
    
        p1 = CGPoint(x: x1, y: y1) - self.position//
        p2 = CGPoint(x: x2, y: y2) - self.position//
        values = []
        self.addChild(line)
        
        shadowedBitMask = UInt32(Int(powf(2, Float(8))))//
        shadowCastBitMask = UInt32(Int(powf(2, Float(8))))//
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addValues(_ a: [Int])
    {
        for x in a
        {
            values.append(x)
        }
    }
    
    func render()
    {
        line.strokeColor = Color.black
        line.lineWidth = 5
        line.isAntialiased = false
        line.alpha = 1
        //line.strokeColor = Color.clear
        
        #if os(iOS)
            let p = UIBezierPath()
            p.move(to: p1)
            p.addLine(to: p2)
            line.path = p.cgPath
        #else
            let p = NSBezierPath()
            p.move(to: p1)
            p.line(to: p2)
            line.path = p.cgPath
        #endif
        
        let dx = (p2.x - p1.x) -/ 12
        let dy = (p2.y - p1.y) -/ 12
        
        if values.count == 0
        {
            values = [4]
        }
        
        for x in 0 ..< 12
        {
            let v = values[x % values.count]
            let l = SKShapeNode()
            l.lineWidth = 3
            l.strokeColor = Color.getDarkColorFromWeight(v)
            
            #if os(iOS)
                let path = UIBezierPath()
                path.move(to: p1 + (x * CGPoint(x: dx, y: dy)))
                path.addLine(to: p1 + ((x + 1) * CGPoint(x: dx, y: dy)))
                l.path = path.cgPath
            #else
                let path = NSBezierPath()
                path.move(to: p1 + (x * CGPoint(x: dx, y: dy)))
                path.line(to: p1 + ((x + 1) * CGPoint(x: dx, y: dy)))
                l.path = path.cgPath
            #endif
            
            lines.append(l)
            self.addChild(l)
        }
        
        for x in 0...12
        {
            let v = values[x % values.count]

            let newL = SKShapeNode()
            newL.lineWidth = 1
            newL.strokeColor = Color.getDarkColorFromWeight(v)
            
            var ndx = CGFloat(0)
            var ndy = CGFloat(0)
            
            if dx != 0
            {
                ndx = 5
            }
            if dy != 0
            {
                ndy = 5
            }
            
            #if os(iOS)
                let newPath = UIBezierPath()
                let newP = p1 + (x * CGPoint(x: dx, y: dy))
                newPath.move(to: CGPoint(x: newP.x - ndy, y: newP.y + ndx))
                newPath.addLine(to: CGPoint(x: newP.x + ndy, y: newP.y - ndx))
                newL.path = newPath.cgPath
            #else
                let newPath = NSBezierPath()
                let newP = p1 + (x * CGPoint(x: dx, y: dy))
                newPath.move(to: CGPoint(x: newP.x - ndy, y: newP.y + ndx))
                newPath.line(to: CGPoint(x: newP.x + ndy, y: newP.y - ndx))
                newL.path = newPath.cgPath
            #endif
            
            //lines.append(newL)
            //self.addChild(newL)
        }
        
        let dot1 = SKShapeNode.init(circleOfRadius: 2)
        dot1.position = p1
        dot1.fillColor = Color.black
        dot1.strokeColor = Color.black
        dot1.lineWidth = 1
        dot1.zPosition = -1
        dot1.isAntialiased = false
        self.addChild(dot1)
        
        let dot2 = SKShapeNode.init(circleOfRadius: 2)
        dot2.position = p2
        dot2.fillColor = Color.black
        dot2.strokeColor = Color.black
        dot2.lineWidth = 1
        dot2.zPosition = -1
        dot2.isAntialiased = false
        self.addChild(dot2)
    }
    
    func valueString() -> String
    {
        var str = ""
        
        for i in values
        {
            if i == 0
            {
                str += "00"
            }
            else if i == 1
            {
                str += "01"
            }
            else if i == 2
            {
                str += "02"
            }
            else if i == 3
            {
                str += "03"
            }
            else if i == 4
            {
                str += "04"
            }
            else if i == -1
            {
                str += "-1"
            }
            else if i == -2
            {
                str += "-2"
            }
            else if i == -3
            {
                str += "-3"
            }
        }
        
        return str
    }
    
    func toString() -> String
    {
        let scale = 1 /- (Color.shapeSize -/ 20)
        
        var str = ""
        
        str += String(describing: Int(scale -* (p1.x + position.x))) + ","
        str += String(describing: Int(scale -* (p1.y + position.y))) + ","
        str += String(describing: Int(scale -* (p2.x + position.x))) + ","
        str += String(describing: Int(scale -* (p2.y + position.y))) + ","
        str += valueString()
        
        return str
    }
    
    
    
}
