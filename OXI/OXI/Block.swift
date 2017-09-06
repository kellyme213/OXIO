//
//  Block.swift
//  OXIO
//
//  Created by Michael Kelly on 9/16/16.
//  Copyright © 2016 Michael Kelly. All rights reserved.
//

import Foundation
import SpriteKit

class Block: SKSpriteNode
{
    var weight = CGFloat(1.0)
    var type = 1
    var line = SKShapeNode()
    var id = 0
    var node1 = SKShapeNode()
    var node2 = SKShapeNode()
    var node1Showing = true
    var text = SKLabelNode(text: "0")
    let fadeTime = 0.75
    var initialPoint = CGPoint()
    var initialWeight = 0
    var selected = false
    var debugSelected = false
    var pathNode: Path!
    var pathSet = false
    var track: Track!
    var trackSet = false
    var curvedArray = [SKShapeNode]()
    
    init(_ w: Int, _ i: Int)
    {
        super.init(texture: Color.blockTexture, color: Color.clear, size: CGSize(width: Color.shapeSize * 1.2, height: Color.shapeSize * 1.2))
        
        id = i
        weight = CGFloat(w)
        initialWeight = Int(weight)
        type = Color.getTypeFromWeight(w)

        line.strokeColor = Color.getDarkColorFromWeight(w)
        line.lineWidth = 2
        
        let p = SKShapeNode.init(rectOf: self.size, cornerRadius: self.size.width * 0.25)
        p.strokeColor = Color.getDarkColorFromWeight(w)
        p.fillColor = Color.getLightColorFromWeight(w)
        p.lineWidth = 2
        
        node1 = p.copy() as! SKShapeNode
        node2 = p.copy() as! SKShapeNode
        node1.zPosition = 1.0
        node2.zPosition = 1.0
        node2.alpha = 0
        
        text.text = String(w)
        text.fontSize = Color.shapeSize * 1.15
        text.horizontalAlignmentMode = .center
        text.verticalAlignmentMode = .center
        text.zPosition = 1.0
        
        self.addChild(node1)
        self.addChild(node2)
        self.addChild(text)
        
        self.lightingBitMask = UInt32(Int(powf(2, Float(type))))
        self.shadowCastBitMask = UInt32(Int(powf(2, Float(type))))
        self.shadowedBitMask = UInt32(Int(powf(2, Float(type))))
        self.colorBlendFactor = 1.0
        
        #if os(iOS)
            let curvedPath = UIBezierPath()
            curvedPath.move(to: CGPoint(x: -size.width / 6, y: 0))
            curvedPath.addArc(withCenter: CGPoint(x: 0, y: 0), radius: size.width / 6, startAngle: 0, endAngle: CGFloat.pi, clockwise: true)
            curvedPath.addLine(to: CGPoint(x: -size.width / 6, y: 0))

            let curvedPath2 = UIBezierPath()
            curvedPath2.move(to: CGPoint(x: -size.width / 6, y: 0))
            curvedPath2.addArc(withCenter: CGPoint(x: 0, y: 0), radius: size.width / 6, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            curvedPath2.addLine(to: CGPoint(x: -size.width / 6, y: 0))

        #else
            let curvedPath = NSBezierPath()
            curvedPath.move(to: CGPoint(x: -size.width / 6, y: 0))
            curvedPath.appendArc(withCenter: CGPoint(x: 0, y: 0), radius: size.width / 6, startAngle: 0, endAngle: 180)
            curvedPath.line(to: CGPoint(x: -size.width / 6, y: 0))
            
            let curvedPath2 = NSBezierPath()
            curvedPath2.move(to: CGPoint(x: -size.width / 6, y: 0))
            curvedPath2.appendArc(withCenter: CGPoint(x: 0, y: 0), radius: size.width / 6, startAngle: 0, endAngle: 360)
            curvedPath2.line(to: CGPoint(x: -size.width / 6, y: 0))
            
        #endif
        
        let curvedLine = SKShapeNode()
        curvedLine.path = curvedPath.cgPath
        curvedLine.zPosition = 5
        curvedLine.strokeColor = Color.black
        curvedLine.lineWidth = 2
        
        curvedArray.append(curvedLine.copy() as! SKShapeNode)
        curvedArray.append(curvedLine.copy() as! SKShapeNode)
        curvedArray.append(curvedLine.copy() as! SKShapeNode)
        curvedArray.append(curvedLine.copy() as! SKShapeNode)
        curvedArray[3].path = curvedPath2.cgPath
        
        placeCircles()
        
        //node1.alpha = 0
        //node2.alpha = 0
        //text.alpha = 0
    }
    
    func weightedX() -> CGFloat
    {
        return weight * self.position.x
    }
    
    func weightedY() -> CGFloat
    {
        return weight * self.position.y
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeType(_ w: Int)
    {
        let same = weight == CGFloat(w)
        weight = CGFloat(w)
        type = Color.getTypeFromWeight(w)
        line.strokeColor = Color.getDarkColorFromWeight(w)
        text.text = String(w)
        
        if (node1Showing)
        {
            //node2.texture = Color.getBlockTextureFromWeight(w)
            node2.fillColor = Color.getLightColorFromWeight(w)
            node2.strokeColor = Color.getDarkColorFromWeight(w)
            if (same)
            {
                node1.alpha = 0
                node2.alpha = 1
            }
            else
            {
                node1.run(SKAction.fadeAlpha(to: 0, duration: fadeTime))
                node2.run(SKAction.fadeAlpha(to: 1, duration: fadeTime))
            }
        }
        else
        {
            //node1.texture = Color.getBlockTextureFromWeight(w)
            node1.fillColor = Color.getLightColorFromWeight(w)
            node1.strokeColor = Color.getDarkColorFromWeight(w)
            if (same)
            {
                node2.alpha = 0
                node1.alpha = 1
            }
            else
            {
                node2.run(SKAction.fadeAlpha(to: 0, duration: fadeTime))
                node1.run(SKAction.fadeAlpha(to: 1, duration: fadeTime))
            }
        }
        
        node1Showing = !node1Showing
        
        self.lightingBitMask = UInt32(Int(powf(2, Float(type))))
        self.shadowCastBitMask = UInt32(Int(powf(2, Float(type))))
        self.shadowedBitMask = UInt32(Int(powf(2, Float(type))))
        self.colorBlendFactor = 1.0
        
        placeCircles()
    }
    
    func setBlockPosition(_ point: CGPoint)
    {
        
    }
    
    func setInitialPosition(_ point: CGPoint)
    {
        self.position = point
        self.initialPoint = point
    }
    
    func returnToInitialPosition()
    {
        self.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.run({self.changeType(self.initialWeight)}), SKAction.move(to: self.initialPoint, duration: 0.5), SKAction.run({if self.pathSet {self.pathNode.runPath(node: self)}})]))
        
        self.selected = false
    }
    
    func placeCircles()
    {
        return;
            
        self.removeChildren(in: curvedArray)
        
        if weight < 0
        {
            curvedArray[0].zRotation = CGFloat.pi
            curvedArray[1].zRotation = CGFloat.pi
            curvedArray[2].zRotation = CGFloat.pi
        }
        else
        {
            curvedArray[0].zRotation = 0
            curvedArray[1].zRotation = 0
            curvedArray[2].zRotation = 0
        }
        
        if weight == 1 || weight == -1
        {
            curvedArray[0].position = self.frame.size * CGPoint(x: 0, y: 0.0)
            
            self.addChild(curvedArray[0])
        }
        else if weight == 2 || weight == -2
        {
            curvedArray[0].position = self.frame.size * CGPoint(x: -0.2, y: 0.0)
            curvedArray[1].position = self.frame.size * CGPoint(x: 0.2, y: 0.0)
            
            self.addChild(curvedArray[0])
            self.addChild(curvedArray[1])
        }
        else if weight == 3 || weight == -3
        {
            curvedArray[0].position = self.frame.size * CGPoint(x: -0.2, y: 0.15)
            curvedArray[1].position = self.frame.size * CGPoint(x: 0.2, y: 0.15)
            curvedArray[2].position = self.frame.size * CGPoint(x: 0.0, y: -0.15)
            
            self.addChild(curvedArray[0])
            self.addChild(curvedArray[1])
            self.addChild(curvedArray[2])
        }
        else if weight == 0
        {
            curvedArray[3].position = self.frame.size * CGPoint(x: 0, y: 0.0)
            
            self.addChild(curvedArray[3])
        }
    }
    
    func toString() -> String
    {
        let scale = 1 /- (Color.shapeSize -/ 20)
        
        var str = ""
        
        str += String(describing: Int(scale * position.x)) + ","
        str += String(describing: Int(scale * position.y)) + ","
        str += String(describing: Int(weight)) + ","
        str += String(describing: Int(id))
        
        return str
    }
    
    override func contains(_ p: CGPoint) -> Bool
    {
        return self.frame.insetBy(dx: -self.frame.width -/ 2, dy: -self.frame.height -/ 2).contains(p)
    }
}
