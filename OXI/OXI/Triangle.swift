//
//  Triangle.swift
//  OXIO
//
//  Created by Michael Kelly on 2/5/17.
//  Copyright © 2017 Michael Kelly. All rights reserved.
//

import Foundation
import SpriteKit

class Triangle: SKSpriteNode
{
    var weight = CGFloat(1.0)
    var type = 1
    var line = SKShapeNode()
    var id = 0
    var node1 = SKShapeNode()
    var node2 = SKShapeNode()
    var node1Showing = true
    var text = SKLabelNode(text: "0")
    let fadeTime = 1.0
    var initialPoint = CGPoint()
    var initialWeight = 0
    var selected = false
    var debugSelected = false
    var pathNode: Path!
    var pathSet = false
    var track: Track!
    var trackSet = false
    
    init(_ w: Int, _ i: Int)
    {
        super.init(texture: Color.triangleTexture, color: Color.clear, size: CGSize(width: Color.shapeSize * 1.2, height: Color.shapeSize * 1.05))
        
        node2.alpha = 0
        
        type = Color.getTypeFromWeight(w)
        
        weight = CGFloat(w)
        initialWeight = Int(weight)
        
        line.strokeColor = Color.getDarkColorFromWeight(w)
        line.lineWidth = 2
        
        id = i
        
        #if os(iOS)
            let triPath = UIBezierPath()
            triPath.move(to: CGPoint(x: 0, y: -size.height / 2))
            triPath.addLine(to: CGPoint(x: -size.width / 2, y: size.height / 2))
            triPath.addLine(to: CGPoint(x: size.width / 2, y: size.height / 2))
            triPath.addLine(to: CGPoint(x: 0, y: -size.height / 2))
        #else
            let triPath = NSBezierPath()
            triPath.move(to: CGPoint(x: 0, y: -size.height / 2))
            triPath.line(to: CGPoint(x: -size.width / 2, y: size.height / 2))
            triPath.line(to: CGPoint(x: size.width / 2, y: size.height / 2))
            triPath.line(to: CGPoint(x: 0, y: -size.height / 2))
        #endif
        
        let tri = SKShapeNode.init(path: triPath.cgPath)
        tri.strokeColor = Color.getDarkColorFromWeight(w)
        tri.fillColor = Color.getLightColorFromWeight(w)
        tri.lineWidth = 2
        
        node1 = tri.copy() as! SKShapeNode
        node2 = tri.copy() as! SKShapeNode
        
        self.addChild(node1)
        self.addChild(node2)
        
        text.text = String(w)
        text.fontName = "Avenir"
        text.fontColor = Color.black
        text.fontSize = Color.shapeSize * 1.15
        text.horizontalAlignmentMode = .center
        text.verticalAlignmentMode = .center
        //self.addChild(text)
        
        self.lightingBitMask = UInt32(Int(powf(2, Float(type))))
        self.shadowCastBitMask = UInt32(Int(powf(2, Float(type))))
        self.shadowedBitMask = UInt32(Int(powf(2, Float(type))))
        self.colorBlendFactor = 1.0
        
        node1.zPosition = 1.0
        node2.zPosition = 1.0
        
        text.zPosition = 1.0
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
        self.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.run({self.changeType(self.initialWeight)}), SKAction.move(to: self.initialPoint, duration: 0.5)]))
        
        self.selected = false
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
}
