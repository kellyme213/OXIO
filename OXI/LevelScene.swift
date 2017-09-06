//
//  LevelScene.swift
//  OXIO
//
//  Created by Michael Kelly on 2/4/17.
//  Copyright © 2017 Michael Kelly. All rights reserved.
//

import Foundation
import SpriteKit

class LevelScene: SKScene
{
    let backButton = SKLabelNode(text: "Back")
    let cam = SKCameraNode()
    var dot = SKShapeNode()
    var blockArray = [Block]()
    
    var sectionArray = [SKLabelNode]()
    
    override func didMove(to view: SKView)
    {
        view.shouldCullNonVisibleNodes = true
        
        Color.shapeSize = view.bounds.width / CGFloat(Color.numOfColumns)
        self.backgroundColor = Color.white
        
        let scale = Color.shapeSize / 20.0
        
        //var blockArray = [Block]()
        
        cam.xScale = 1
        cam.yScale = 1
        self.camera = cam
        
        cam.position = self.position
        
        self.addChild(cam)
        
        
        
        /*
        for x in 0 ..< 100
        {
            let block = Block(Color.getWeightFromType((x + 1) % 7), x)
            
            let x1 = (Double(x % 5 + 1) - 2.75) /- 6.0
            let y1 = ((5 - (x / 5)) - 3) /- 6.0
            let centerX = position.x
            let centerY = position.y
            
            
            block.position = view.bounds * CGPoint(x: x1, y: y1)
            self.addChild(block)
            block.popIn()
            block.text.text = String(x + 1)
            blockArray.append(block)
            block.setInitialPosition(scale * CGPoint(x: Double(180 *- x1), y: Double(220 *- y1)) + CGPoint(x: centerX, y: centerY))
        }
 
        */
        
        var y = CGFloat(120)
        
        if (Color.isPhone)
        {
            y = CGFloat(160)
        }
        
        #if os(macOS)
            y = CGFloat(160)
        #endif
        /*
        let p = SKShapeNode.init(rectOf: scale * CGSize(width: 180, height: 20))
        p.strokeColor = Color.black
        p.fillColor = Color.lightW
        p.position = scale * CGPoint(x: 0, y: (-y + 10))
        cam.addChild(p)
        */
        
        backButton.fontName = "Avenir"
        backButton.fontColor = Color.black
        backButton.fontSize = scale * 16 / 1.5
        backButton.position = scale * CGPoint(x: -88, y: (-y + 5)) //15
        backButton.horizontalAlignmentMode = .left
        backButton.verticalAlignmentMode = .center
        //self.addChild(backButton)
        cam.addChild(backButton)
        
        /*
        p.zPosition = 2
        backButton.zPosition = 2
        
        dot = SKShapeNode.init(ellipseOf: 0.6 * CGSize(width: Color.shapeSize, height: Color.shapeSize))
        dot.position = scale * CGPoint(x: -80, y: 80)
        dot.fillColor = Color.black
        dot.strokeColor = Color.black
        dot.lineWidth = 1
        cam.addChild(dot)
        
        #if os(iOS)
            
            let linePath = UIBezierPath()
            linePath.move(to: scale * CGPoint(x: -80, y: 80))
            linePath.addLine(to: scale * CGPoint(x: -80, y: -80))
            
        #else
            
            let linePath = NSBezierPath()
            linePath.move(to: scale * CGPoint(x: -80, y: 80))
            linePath.line(to: scale * CGPoint(x: -80, y: -80))
            
        #endif
        
        let line = SKShapeNode()
        line.path = linePath.cgPath
        line.strokeColor = Color.black
        line.lineWidth = 2
        
        cam.addChild(line)
 */
        
        
        
        for x in 0 ..< 7
        {
            let label = SKLabelNode(text: "Section " + (x + 1))
            
            label.fontSize = scale * 16 / 1.5
            label.position = scale * CGPoint(x: 0, y: 20 * (3 - x))
            cam.addChild(label)
            sectionArray.append(label)
            label.alpha = 0
            label.run(SKAction.sequence([SKAction.wait(forDuration: 0.1 * (x + 1)), SKAction.fadeIn(withDuration: 0.5)]))
            
        }
        
        for x in 0 ..< 7
        {
            let block = Block(Color.getWeightFromType((x + 1) % 7), x)
            
            var y = 15
            
            if x % 2 == 1
            {
                y = -15
            }
            
            block.position = scale * CGPoint(x: -15 * (3 - x), y: y)
            
            //self.addChild(block)
            //block.popIn()
            block.text.text = String(x + 1)
            blockArray.append(block)
            //block.setInitialPosition(scale * CGPoint(x: Double(180 *- x1), y: Double(220 *- y1)) + CGPoint(x: centerX, y: centerY))
        }
    }
    
    var onSectionScreen = true
    var sectionSelected = 0
    var sectionNumber = 0
    
    func touchDown(atPoint pos : CGPoint)
    {
        let p2 = pos//convert(pos, to: camera!)
        
        if backButton.contains(p2)
        {
            if onSectionScreen
            {
                
                for label in sectionArray
                {
                    label.run(SKAction.fadeOut(withDuration: 0.5))
                }
                
                backButton.run(SKAction.fadeOut(withDuration: 0.5))
                
                self.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.run({self.view!.presentScene(MainMenuScene(size: self.view!.frame.size, b: false))})]))
                
            }
            else
            {
                onSectionScreen = true
                
                returnToSelectionScreen()
                
                
            }
        }
        
        sectionSelected = -1

        for x in 0 ..< sectionArray.count
        {
            if sectionArray[x].contains(p2) && sectionArray[x].alpha == 1 //shit fix
            {
                sectionSelected = x
                sectionNumber = x
            }
        }
        
        
        if !onSectionScreen
        {
            for x in 0 ..< blockArray.count
            {
                if blockArray[x].contains(p2)
                {
                    goToLevel(section: sectionNumber, level: x)
                    return
                }
            }
        }
        
        let scale = Color.shapeSize -/ 20
        
        if sectionSelected != -1
        {
            onSectionScreen = false
            
            var counter = 0
            
            for x in 0 ..< sectionArray.count
            {
                if x != sectionSelected
                {
                    if counter % 2 == 0
                    {
                        let action1 = SKAction.moveBy(x: scale * 20, y: 0, duration: 1)
                        let action2 = SKAction.fadeOut(withDuration: 1)
                        let action3 = SKAction.group([action1, action2])
                        
                        sectionArray[x].run(action3)
                    }
                    else
                    {
                        let action1 = SKAction.moveBy(x: -scale * 20, y: 0, duration: 1)
                        let action2 = SKAction.fadeOut(withDuration: 1)
                        let action3 = SKAction.group([action1, action2])
                        
                        sectionArray[x].run(action3)
                    }
                    counter += 1
                }
                else
                {
                    let action1 = SKAction.wait(forDuration: 1.0)
                    let action2 = SKAction.move(to: scale * CGPoint(x: 0, y: -80), duration: 1)
                    let action3 = SKAction.run({self.getBlocks()})
                    
                    let action4 = SKAction.sequence([action1, action3])
                    let action5 = SKAction.group([action2, action4])
                    
                    sectionArray[x].run(action5)
                }
            }
            
        }
        

        
        
        
    }
    
    func getBlocks()
    {
        for block in blockArray
        {
            if !cam.children.contains(block) //shit fix
            {
                block.scale(to: 1.2 * CGSize(square: Color.shapeSize))
                cam.addChild(block)
                block.popIn()
            }
            else
            {
                print("ERROR")
            }
        }
    }
    
    var s = 0
    var l = 0
    
    func goToLevel(section: Int, level: Int)
    {
        s = section + 1
        l = level + 1
        
        let fadeAction = SKAction.fadeOut(withDuration: 1)
        
        sectionArray[section].run(fadeAction)
        backButton.run(fadeAction)
        
        for block in blockArray
        {
            block.popOut()
        }
        
        self.run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.run({self.view!.presentScene(GameScene(size: self.view!.frame.size, section: self.s, level: self.l))})]))
    }
    
    func returnToSelectionScreen()
    {
        for block in blockArray
        {
            block.popOut()
        }
        
        let scale = Color.shapeSize -/ 20
        
        
        var counter = 0
        
        
        for x in 0 ..< sectionArray.count
        {
            if x != sectionNumber
            {
                var scalar = -20
                
                if counter % 2 == 1
                {
                    scalar = 20
                }
                
                sectionArray[x].position = scale * CGPoint(x: scalar, y: 20 * (3 - x))
                
                let action1 = SKAction.moveBy(x: scale * -scalar, y: 0, duration: 1)
                let action2 = SKAction.fadeIn(withDuration: 1)
                let action3 = SKAction.group([action1, action2])
                
                sectionArray[x].run(action3)
                
                counter += 1

                
                /*
                if counter % 2 == 0
                {
                    
                    
                    
                    
                    sectionArray[x].position = scale * CGPoint(x: -20, y: 20 * (3 - x))
                    
                    
                    let action1 = SKAction.moveBy(x: scale * 20, y: 0, duration: 1)
                    let action2 = SKAction.fadeIn(withDuration: 1)
                    let action3 = SKAction.group([action1, action2])
                    
                    sectionArray[x].run(action3)
                }
                else
                {
                    sectionArray[x].position = scale * CGPoint(x: 20, y: 20 * (3 - x))

                    let action1 = SKAction.moveBy(x: scale * -20, y: 0, duration: 1)
                    let action2 = SKAction.fadeIn(withDuration: 1)
                    let action3 = SKAction.group([action1, action2])
                    
                    sectionArray[x].run(action3)
                }
                */
                
            }
            else
            {
                let action1 = SKAction.wait(forDuration: 1.0)
                let action2 = SKAction.move(to: scale * CGPoint(x: 0, y: 20 * (3 - x)), duration: 1)
                let action3 = SKAction.run({})
                
                let action4 = SKAction.sequence([action1, action3])
                let action5 = SKAction.group([action2, action4])
                
                sectionArray[x].run(action5)
            }
        }
    }
    
    func touchUp(atPoint pos : CGPoint)
    {
        
    }
    
    func touchMoved(atPoint pos : CGPoint)
    {
        let scale = Color.shapeSize -/ 20
        let p2 = pos//convert(pos, to: camera!)
        
        if p2.x < -70 *- scale
        {
            dot.position = CGPoint(x: -80 *- scale, y: p2.y)
        }
        
        if dot.position.y > 80 *- scale
        {
            dot.position = CGPoint(x: dot.position.x, y: 80 *- scale)
        }
        
        if dot.position.y < -80 *- scale
        {
            dot.position = CGPoint(x: dot.position.x, y: -80 *- scale)
        }
    }
    
    #if os(iOS)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
    self.touchDown(atPoint: touches.first!.location(in: self))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
    self.touchUp(atPoint: touches.first!.location(in: self))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
    self.touchMoved(atPoint: touches.first!.location(in: self))
    }
    
    #else
    
    override func mouseDown(with event: NSEvent)
    {
        self.touchDown(atPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent)
    {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    override func mouseMoved(with event: NSEvent)
    {
        self.touchMoved(atPoint: event.location(in: self))
    }
    
    override func mouseEntered(with event: NSEvent)
    {
        self.touchMoved(atPoint: event.location(in: self))
    }
    
    #endif
}

