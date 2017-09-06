//
//  Track.swift
//  OXIO
//
//  Created by Michael Kelly on 4/1/17.
//  Copyright © 2017 Michael Kelly. All rights reserved.
//

import Foundation
import SpriteKit

class Track: SKShapeNode
{
    var fragments = [Fragment]()
    var id = 0
    
    #if os(macOS)
        var paths = NSBezierPath()
    #else
        var paths = UIBezierPath()
    #endif
    
    override init()
    {
       super.init()
    }
    
    func render()
    {
        self.path = paths.cgPath
        
        self.lineWidth = 1
        self.strokeColor = Color.black
    }
    
    func addFragment(str: String)
    {
        let array = str.components(separatedBy: ",")
     
        let scale = Color.shapeSize -/ 20
        
        if array[0] == "c"
        {
            let fragment = Fragment(x: CGFloat(Int(array[1])!) -* scale, y: CGFloat(Int(array[2])!) -* scale, r: CGFloat(Int(array[3])!) -* scale, startAlpha: CGFloat(Int(array[4])!), endAlpha: CGFloat(Int(array[5])!))
            
            #if os(iOS)
                
                let bp = UIBezierPath()
                bp.addArc(withCenter: CGPoint(x: fragment.x, y: fragment.y), radius: fragment.r, startAngle: (CGFloat.pi -/ 180) -* fragment.startAlpha, endAngle: (CGFloat.pi -/ 180) -* fragment.endAlpha, clockwise: true)
                
            #else
            
                let bp = NSBezierPath()
                bp.appendArc(withCenter: CGPoint(x: fragment.x, y: fragment.y), radius: fragment.r, startAngle: fragment.startAlpha, endAngle: fragment.endAlpha, clockwise: false)
                
                /*
                let dt = (fragment.endAlpha - fragment.startAlpha) / 16
                
                let bp2 = NSBezierPath()
                bp2.appendArc(withCenter: CGPoint(x: fragment.x, y: fragment.y), radius: fragment.r, startAngle: fragment.startAlpha, endAngle: fragment.startAlpha + dt, clockwise: false)
                
                let bp3 = NSBezierPath()
                bp3.appendArc(withCenter: CGPoint(x: fragment.x, y: fragment.y), radius: fragment.r, startAngle: fragment.startAlpha + (dt * 7), endAngle: fragment.startAlpha + (dt * 9), clockwise: false)
                
                let bp4 = NSBezierPath()
                bp4.appendArc(withCenter: CGPoint(x: fragment.x, y: fragment.y), radius: fragment.r, startAngle: fragment.endAlpha - dt, endAngle: fragment.endAlpha, clockwise: false)
                
                let n2 = SKShapeNode()
                n2.path = bp2.cgPath
                n2.strokeColor = Color.black
                n2.lineWidth = 2
                self.addChild(n2)
                
                let n3 = n2.copy() as! SKShapeNode
                n3.path = bp3.cgPath
                self.addChild(n3)
                
                let n4 = n2.copy() as! SKShapeNode
                n4.path = bp4.cgPath
                self.addChild(n4)
                */
                
            #endif
            
            paths.append(bp)
            fragments.append(fragment)
            fragment.tNum = fragments.count
            
            /*
            let dot = SKShapeNode.init(circleOfRadius: 2)
            dot.strokeColor = Color.black
            dot.fillColor = Color.black
            
            dot.position = CGPoint(x: fragment.x, y: fragment.y) + (fragment.r * CGPoint(x: cos((CGFloat.pi -/ 180) -* fragment.startAlpha), y: sin((CGFloat.pi -/ 180) -* fragment.startAlpha)))
            self.addChild(dot)
            
            let dot2 = dot.copy() as! SKShapeNode
            dot2.position = CGPoint(x: fragment.x, y: fragment.y) + (fragment.r * CGPoint(x: cos((CGFloat.pi -/ 180) -* fragment.endAlpha), y: sin((CGFloat.pi -/ 180) -* fragment.endAlpha)))
            self.addChild(dot2)
            */
        }
        else
        {
            let fragment = Fragment(x1: CGFloat(Int(array[1])!) -* scale, y1: CGFloat(Int(array[2])!) -* scale, x2: CGFloat(Int(array[3])!) -* scale, y2: CGFloat(Int(array[4])!) -* scale)
            
            
            #if os(iOS)
                
                let bp = UIBezierPath()
                bp.move(to: CGPoint(x: fragment.x1, y: fragment.y1))
                bp.addLine(to: CGPoint(x: fragment.x2, y: fragment.y2))
                
            #else
                
                let bp = NSBezierPath()
                bp.move(to: CGPoint(x: fragment.x1, y: fragment.y1))
                bp.line(to: CGPoint(x: fragment.x2, y: fragment.y2))
                
                /*
                let dx = (fragment.x2 - fragment.x1) / 16
                let dy = (fragment.y2 - fragment.y1) / 16
                
                let bp2 = NSBezierPath()
                bp2.move(to: CGPoint(x: fragment.x1, y: fragment.y1))
                bp2.line(to: CGPoint(x: fragment.x1 + dx, y: fragment.y1 + dy))
                
                let bp3 = NSBezierPath()
                bp3.move(to: CGPoint(x: fragment.x1, y: fragment.y1) + CGPoint(x: dx * 7, y: dy * 7))
                bp3.line(to: CGPoint(x: fragment.x1, y: fragment.y1) + CGPoint(x: dx * 9, y: dy * 9))

                let bp4 = NSBezierPath()
                bp4.move(to: CGPoint(x: fragment.x2, y: fragment.y2))
                bp4.line(to: CGPoint(x: fragment.x2 - dx, y: fragment.y2 - dy))
                
                let n2 = SKShapeNode()
                n2.path = bp2.cgPath
                n2.strokeColor = Color.black
                n2.lineWidth = 2
                self.addChild(n2)
                
                let n3 = n2.copy() as! SKShapeNode
                n3.path = bp3.cgPath
                self.addChild(n3)
                
                let n4 = n2.copy() as! SKShapeNode
                n4.path = bp4.cgPath
                self.addChild(n4)
                */
                
            #endif
            
            paths.append(bp)
            fragments.append(fragment)
            fragment.tNum = fragments.count
            
            /*
            let dot = SKShapeNode.init(circleOfRadius: 2)
            dot.strokeColor = Color.black
            dot.fillColor = Color.black
            
            dot.position = CGPoint(x: fragment.x1, y: fragment.y1)
            self.addChild(dot)
            
            let dot2 = dot.copy() as! SKShapeNode
            dot2.position = CGPoint(x: fragment.x2, y: fragment.y2)
            self.addChild(dot2)
            */
        }
    }
    
    var currentTrackNum = 0
    
    func findPoint(p: CGPoint, cp: CGPoint) -> CGPoint
    {
        var distance = CGFloat(1000000)
        var point = p
        var trackNum = 0
        
        for f in fragments
        {
            let tuple = f.minimizeDistance(minD: distance, minP: point, p: p, trackNum: trackNum)
            
            distance = tuple.0
            point = tuple.1
            trackNum = tuple.2
        }
        
        
        let distanceTolerance = 25
        
        /*
        if currentTrackNum == 0 || currentTrackNum == trackNum
        {
            distanceTolerance = 25
        }
        else
        {
            distanceTolerance = 10
        }
        */
        
        if Color.distanceBetween(point, cp) < (distanceTolerance *- (Color.shapeSize -/ 20))
        {
            currentTrackNum = trackNum
            return point
        }
        else
        {
            return cp
        }
        
        //return point
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class Fragment
{
    var fragmentType = ""
    var x = CGFloat(0)
    var y = CGFloat(0)
    var r = CGFloat(0)
    var startAlpha = CGFloat(0)
    var endAlpha = CGFloat(0)
    var x1 = CGFloat(0)
    var x2 = CGFloat(0)
    var y1 = CGFloat(0)
    var y2 = CGFloat(0)
    var tNum = 0
    
    init(x: CGFloat, y: CGFloat, r: CGFloat, startAlpha: CGFloat, endAlpha: CGFloat)
    {
        fragmentType = "Curve"
        
        self.x = x
        self.y = y
        self.r = r
        self.startAlpha = startAlpha
        self.endAlpha = endAlpha
    }
    
    
    init(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat)
    {
        fragmentType = "Line"
        
        self.x1 = x1
        self.x2 = x2
        self.y1 = y1
        self.y2 = y2
    }
    
    func minimizeDistance(minD: CGFloat, minP: CGPoint, p: CGPoint, trackNum: Int) -> (CGFloat, CGPoint, Int)
    {
        var minimumDistance = minD
        var minimumPoint = minP
        var trackNumber = trackNum
        let controlPoint = p
        
        var iterations = 0
        
        if fragmentType == "Line"
        {
            iterations = Int(1) -* Color.distanceBetween(CGPoint(x: x1, y: y1), CGPoint(x: x2, y: y2))
        }
        else
        {
            iterations = (endAlpha - startAlpha) *- CGFloat.pi -* r /- Int(180)
        }
        
        iterations /= 5
        
        let dx = (x2 - x1) -/ iterations
        let dy = (y2 - y1) -/ iterations
        let dt = (endAlpha - startAlpha) -/ iterations
        
        for i in 0...iterations
        {
            var testPoint = controlPoint
            
            if fragmentType == "Curve"
            {
                testPoint = r * CGPoint(x: cos((CGFloat.pi -/ 180) -* (startAlpha + (dt -* i))), y: sin((CGFloat.pi -/ 180) -* (startAlpha + (dt -* i))))
                
                testPoint = testPoint + CGPoint(x: x, y: y)
            }
            else
            {
                testPoint = CGPoint(x: x1 + (dx -* i), y: y1 + (dy -* i))
            }
        
        
            let testDistance = Color.distanceBetween(testPoint, controlPoint)
        
            if testDistance < minimumDistance
            {
                minimumDistance = testDistance
                minimumPoint = testPoint
                trackNumber = tNum
            }
        }
        
        return (minimumDistance, minimumPoint, trackNumber)
    }
}



