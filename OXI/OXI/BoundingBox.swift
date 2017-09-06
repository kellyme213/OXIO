//
//  BoundingBox.swift
//  OXIO
//
//  Created by Michael Kelly on 9/18/16.
//  Copyright © 2016 Michael Kelly. All rights reserved.
//

import Foundation
import SpriteKit

//0 = block changer 1 = dot obstacle 2 = end marker 3 = changing box
class BoundingBox: SKSpriteNode
{
    var idArray = [Int]()
    var rect = CGRect()
    var weight = 0
    var obstacle = 0
    var circleNode = SKShapeNode()
    var boxNode = SKShapeNode()
    var changeNode = SKSpriteNode()
    var activated = false
    var selected = false
    var debugSelected = false
    let fadeAction = SKAction.repeatForever(SKAction.sequence([SKAction.fadeAlpha(to: 0.5, duration: 1), SKAction.fadeAlpha(to: 1.0, duration: 1.0)]))
    var p1 = SKShapeNode()
    var p2 = SKShapeNode()
    var p3 = SKShapeNode()
    var p4 = SKShapeNode()
    var dot = SKShapeNode.init(circleOfRadius: 0.1 * Color.shapeSize)
    var pathNode: Path!
    var id = 0
    var pathSet = false
    var initialPoint = CGPoint(x: 0, y: 0)
    
    init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat)
    {
        super.init(texture: nil, color: Color.clear, size: CGSize(width: w, height: h))
        
        rect = CGRect(x: x, y: y, width: w, height: h)
        position = CGPoint(x: x, y: y)
        
        self.addChild(changeNode)
        
        circleNode = SKShapeNode.init(ellipseOf: self.size)
        
        circleNode.isHidden = true
        self.addChild(circleNode)
        circleNode.lineWidth = 1
        circleNode.strokeColor = Color.black
        
        boxNode = SKShapeNode.init(rectOf: CGSize(width: w, height: h))
        
        boxNode.isHidden = true
        self.addChild(boxNode)
        boxNode.lineWidth = 1
        boxNode.strokeColor = Color.black
        
        initialPoint = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addId(_ array: [Int])
    {
        for p in array
        {
            idArray.append(p)
        }
    }
    
    func containsBlock(_ block: Block) -> Bool
    {
        /*
        if (!idArray.contains(block.id))
        {
            return false
        }
        */
        
        let p = block.position
        let x = block.size.width / 2
        let y = block.size.height / 2
        
        let p1 = CGPoint(x: p.x + x, y: p.y + y)
        let p2 = CGPoint(x: p.x - x, y: p.y + y)
        let p3 = CGPoint(x: p.x + x, y: p.y - y)
        let p4 = CGPoint(x: p.x - x, y: p.y - y)
        
        return self.contains(p1) && self.contains(p2) && self.contains(p3) && self.contains(p4)
    }
    
    func setBoxWeight(_ w: Int)
    {
        weight = w
        
        p1.strokeColor = Color.white
        p2.strokeColor = Color.white
        p3.strokeColor = Color.white
        p4.strokeColor = Color.white
    }
    
    func getWeight() -> CGFloat
    {
        return CGFloat(weight)
    }
    
    func setBoxObstacle(_ o: Int)
    {
        obstacle = o
        
        if obstacle == 0 || obstacle == 3
        {
            
            #if os(macOS)
                let path1 = NSBezierPath()
                path1.move(to: CGPoint(x: size.width / 2, y: -size.height / 8))
                path1.line(to: CGPoint(x: size.width / 2, y: size.height / 8))
                
                let path2 = NSBezierPath()
                path2.move(to: CGPoint(x: -size.width / 8, y: size.height / 2))
                path2.line(to: CGPoint(x: size.width / 8, y: size.height / 2))
                
                let path3 = NSBezierPath()
                path3.move(to: CGPoint(x: -size.width / 2, y: -size.height / 8))
                path3.line(to: CGPoint(x: -size.width / 2, y: size.height / 8))
                
                let path4 = NSBezierPath()
                path4.move(to: CGPoint(x: -size.width / 8, y: -size.height / 2))
                path4.line(to: CGPoint(x: size.width / 8, y: -size.height / 2))
            #else
                let path1 = UIBezierPath()
                path1.move(to: CGPoint(x: size.width / 2, y: -size.height / 8))
                path1.addLine(to: CGPoint(x: size.width / 2, y: size.height / 8))
                
                let path2 = UIBezierPath()
                path2.move(to: CGPoint(x: -size.width / 8, y: size.height / 2))
                path2.addLine(to: CGPoint(x: size.width / 8, y: size.height / 2))
                
                let path3 = UIBezierPath()
                path3.move(to: CGPoint(x: -size.width / 2, y: -size.height / 8))
                path3.addLine(to: CGPoint(x: -size.width / 2, y: size.height / 8))
                
                let path4 = UIBezierPath()
                path4.move(to: CGPoint(x: -size.width / 8, y: -size.height / 2))
                path4.addLine(to: CGPoint(x: size.width / 8, y: -size.height / 2))
            #endif
            
            p1 = SKShapeNode.init(path: path1.cgPath)
            p1.lineWidth = 1
            p1.strokeColor = Color.getDarkColorFromWeight(weight)
            self.addChild(p1)
            
            p2 = SKShapeNode.init(path: path2.cgPath)
            p2.lineWidth = 1
            p2.strokeColor = Color.getDarkColorFromWeight(weight)
            self.addChild(p2)
            
            p3 = SKShapeNode.init(path: path3.cgPath)
            p3.lineWidth = 1
            p3.strokeColor = Color.getDarkColorFromWeight(weight)
            self.addChild(p3)
            
            p4 = SKShapeNode.init(path: path4.cgPath)
            p4.lineWidth = 1
            p4.strokeColor = Color.getDarkColorFromWeight(weight)
            self.addChild(p4)
            
            p1.strokeColor = Color.white
            p2.strokeColor = Color.white
            p3.strokeColor = Color.white
            p4.strokeColor = Color.white
            
            p1.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: 0, y: size.height * 0.375, duration: 1), SKAction.moveBy(x: 0, y: size.height * -0.75, duration: 2), SKAction.moveBy(x: 0, y: size.height * 0.375, duration: 1)])))
            
            p2.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: size.width * -0.375, y: 0, duration: 1), SKAction.moveBy(x: size.width * 0.75, y: 0, duration: 2), SKAction.moveBy(x: size.width * -0.375, y: 0, duration: 1)])))
            
            p3.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: 0, y: size.height * -0.375, duration: 1), SKAction.moveBy(x: 0, y: size.height * 0.75, duration: 2), SKAction.moveBy(x: 0, y: size.height * -0.375, duration: 1)])))
            
            p4.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: size.width * 0.375, y: 0, duration: 1), SKAction.moveBy(x: size.width * -0.75, y: 0, duration: 2), SKAction.moveBy(x: size.width * 0.375, y: 0, duration: 1)])))
            
            //p1.run(SKAction.repeatForever(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 1), SKAction.fadeAlpha(to: 1, duration: 0), SKAction.wait(forDuration: 1)])))
            
            //p2.run(SKAction.repeatForever(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 1), SKAction.fadeAlpha(to: 1, duration: 0), SKAction.wait(forDuration: 1)])))
            
            //p3.run(SKAction.repeatForever(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 1), SKAction.fadeAlpha(to: 1, duration: 0), SKAction.wait(forDuration: 1)])))
            
            //p4.run(SKAction.repeatForever(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 1), SKAction.fadeAlpha(to: 1, duration: 0), SKAction.wait(forDuration: 1)])))
            
            if obstacle == 3
            {
                p1.alpha = 0
                p2.alpha = 0
                p3.alpha = 0
                p4.alpha = 0
            }
        }
        
        
        
        
        
        if obstacle == 0
        {
            boxNode.isHidden = false
            boxNode.lineWidth = 1
            
        }
        else if obstacle == 1
        {
            boxNode.isHidden = false
            boxNode.strokeColor = Color.getDarkColorFromWeight(weight)
            boxNode.lineWidth = 2
            
            self.run(fadeAction)
        }
        else if obstacle == 2
        {
            circleNode.isHidden = false
            
            let shadowAlpha = CGFloat(0.1)
            
            let light1 = SKLightNode()
            light1.shadowColor = Color.red.withAlphaComponent(shadowAlpha)
            light1.isEnabled = true
            light1.categoryBitMask = UInt32(Int(powf(2, Float(1))))
            self.addChild(light1)
            
            let light2 = SKLightNode()
            light2.shadowColor = Color.orange.withAlphaComponent(shadowAlpha)
            light2.isEnabled = true
            light2.categoryBitMask = UInt32(Int(powf(2, Float(2))))
            self.addChild(light2)
            
            let light3 = SKLightNode()
            light3.shadowColor = Color.yellow.withAlphaComponent(shadowAlpha)
            light3.isEnabled = true
            light3.categoryBitMask = UInt32(Int(powf(2, Float(3))))
            self.addChild(light3)
            
            let light4 = SKLightNode()
            light4.shadowColor = Color.green.withAlphaComponent(shadowAlpha)
            light4.isEnabled = true
            light4.categoryBitMask = UInt32(Int(powf(2, Float(4))))
            self.addChild(light4)
            
            let light5 = SKLightNode()
            light5.shadowColor = Color.blue.withAlphaComponent(shadowAlpha)
            light5.isEnabled = true
            light5.categoryBitMask = UInt32(Int(powf(2, Float(5))))
            self.addChild(light5)
            
            let light6 = SKLightNode()
            light6.shadowColor = Color.purple.withAlphaComponent(shadowAlpha)
            light6.isEnabled = true
            light6.categoryBitMask = UInt32(Int(powf(2, Float(6))))
            self.addChild(light6)
            
            let light7 = SKLightNode()
            light7.shadowColor = Color.black.withAlphaComponent(shadowAlpha)
            light7.isEnabled = true
            light7.categoryBitMask = UInt32(Int(powf(2, Float(7))))
            self.addChild(light7)
            
            let light8 = SKLightNode()
            light8.shadowColor = Color.white
            light8.isEnabled = true
            light8.categoryBitMask = UInt32(Int(powf(2, Float(8))))
            //self.addChild(light8)//
            
            light1.ambientColor = Color.white
            light2.ambientColor = Color.white
            light3.ambientColor = Color.white
            light4.ambientColor = Color.white
            light5.ambientColor = Color.white
            light6.ambientColor = Color.white
            light7.ambientColor = Color.white
            
            light1.lightColor = Color.red
            light2.lightColor = Color.orange
            light3.lightColor = Color.yellow
            light4.lightColor = Color.green
            light5.lightColor = Color.blue
            light6.lightColor = Color.purple
            light7.lightColor = Color.white
            
            light1.falloff = 0
            light2.falloff = 0
            light3.falloff = 0
            light4.falloff = 0
            light5.falloff = 0
            light6.falloff = 0
            light7.falloff = 0
            
            let path = CGPath.init(ellipseIn: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height), transform: nil)
            
            dot = SKShapeNode.init(circleOfRadius: 0.1 * Color.shapeSize)
            
            dot.fillColor = Color.black
            dot.strokeColor = Color.black
            
            self.addChild(dot)
            
            dot.run(SKAction.repeatForever(SKAction.follow(path, asOffset: false, orientToPath: true, duration: 2.0)))
        }
        else if obstacle == 3
        {
            changeNode.texture = self.texture
            changeNode.size = self.size
            changeNode.alpha = 0
            boxNode.isHidden = false
            xScale = 0.75
            yScale = 0.75
            zRotation = .pi -/ 4
            texture = nil
            activated = true
        }
    }
    
    func blink()
    {
        self.removeAllActions()
        
        let blinkIn = SKAction.run
            {
                self.alpha = 1
        }
        let blinkOut = SKAction.run
            {
                self.alpha = 0
        }
        
        let blink = SKAction.sequence([blinkOut, SKAction.wait(forDuration: 0.25), blinkIn, SKAction.wait(forDuration: 0.25), blinkOut, SKAction.wait(forDuration: 0.25), blinkIn, SKAction.wait(forDuration: 0.25), fadeAction])
        self.run(blink)
        
        //self.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), ]))
    }
    
    func activate()
    {
        activated = true
        let a1 = SKAction.scale(to: 1, duration: 0.5)
        let a2 = SKAction.rotate(toAngle: 0, duration: 0.5)
        let a3 = SKAction.fadeAlpha(to: 1, duration: 0.5)
        
        self.run(SKAction.group([a1, a2]))
        changeNode.run(a3)
        
        p1.run(a3)
        p2.run(a3)
        p3.run(a3)
        p4.run(a3)
    }
    
    func deactivate()
    {
        activated = false
        let a1 = SKAction.scale(to: 0.75, duration: 0.5)
        let a2 = SKAction.rotate(toAngle: .pi -/ 4, duration: 0.5)
        let a3 = SKAction.fadeAlpha(to: 0, duration: 0.5)
        
        self.run(SKAction.group([a1, a2]))
        changeNode.run(a3)
        
        p1.run(a3)
        p2.run(a3)
        p3.run(a3)
        p4.run(a3)
    }
    
    func returnToInitialPosition()
    {
        self.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.move(to: self.initialPoint, duration: 0.5), SKAction.run({if self.pathSet {self.pathNode.runPath(node: self)}}), SKAction.run({if self.obstacle == 1 {self.run(self.fadeAction)}})]))
    }
    
    func idString() -> String
    {
        var str = ""
        
        for i in idArray
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
        
        var x = position.x
        var y = position.y
        var w = size.width
        var h = size.height
        
        if pathSet
        {
            x = initialPoint.x
            y = initialPoint.y
        }
        
        if obstacle == 3 && !activated
        {
            w *= 4.0 -/ 3
            h *= 4.0 -/ 3
        }
        
        str += String(describing: Int(scale *- x)) + ","
        str += String(describing: Int(scale *- y)) + ","
        str += String(describing: Int(scale *- w)) + ","
        str += String(describing: Int(scale *- h)) + ","
        str += String(describing: Int(weight)) + ","
        str += String(describing: Int(obstacle)) + ","
        str += String(describing: id)
        
        return str
    }
}



