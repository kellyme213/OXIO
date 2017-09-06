//
//  MainMenuScene.swift
//  OXIO
//
//  Created by Michael Kelly on 2/3/17.
//  Copyright © 2017 Michael Kelly. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene
{
    let beginText = SKLabelNode(text: "Begin")
    let logo = SKSpriteNode()
    let aboutText = SKLabelNode(text: "About")
    let levelText = SKLabelNode(text: "Levels")
    let startText = SKLabelNode(text: "Play")
    var onMain = true
    let cam = SKCameraNode()
    let titleText = SKLabelNode(text: "OXIO")

    convenience init(size: CGSize, b: Bool)
    {
        self.init(size: size)
        onMain = b
    }
    
    override func didMove(to view: SKView)
    {
        Color.shapeSize = view.bounds.width -/ Color.numOfColumns
        self.backgroundColor = Color.white
        let scale = Color.shapeSize / 20
        
        cam.xScale = 1
        cam.yScale = 1
        self.camera = cam
        
        cam.position = self.position
        
        self.addChild(cam)
        
        titleText.position = scale * CGPoint(x: 0, y: 80)
        titleText.fontSize = Color.shapeSize * 2
        
        beginText.position = scale * CGPoint(x: 0, y: -80)
        beginText.fontSize = Color.shapeSize
        
        beginText.run(SKAction.repeatForever(SKAction.sequence([SKAction.fadeOut(withDuration: 2.0), SKAction.wait(forDuration: 0.25), SKAction.fadeIn(withDuration: 2.0), SKAction.wait(forDuration: 0.5)])))
        
        logo.texture = SKTexture(imageNamed: "logo")
        logo.size = 4.0 * CGSize(width: Color.shapeSize, height: Color.shapeSize)
        logo.position = scale * CGPoint(x: 0, y: 0)
        
        aboutText.fontSize = Color.shapeSize
        levelText.fontSize = Color.shapeSize
        startText.fontSize = Color.shapeSize
        
        aboutText.position = scale * CGPoint(x: 0, y: -80)
        levelText.position = scale * CGPoint(x: 0, y: -40)
        startText.position = scale * CGPoint(x: 0, y: 0)
        self.addChild(titleText)
        
        if onMain
        {
            self.addChild(beginText)
            self.addChild(logo)
        }
        else
        {
            transitionToSelection(delay: -0.7)
        }
    }
    
    func transitionToSelection(delay: Double)
    {
        logo.popOut()
        beginText.removeAllActions()
        beginText.alpha = 1
        beginText.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.5), SKAction.removeFromParent()]))
        self.addChild(aboutText)
        self.addChild(levelText)
        self.addChild(startText)
        
        aboutText.alpha = 0
        levelText.alpha = 0
        startText.alpha = 0
        
        aboutText.run(SKAction.sequence([SKAction.wait(forDuration: 1.25 + delay), SKAction.fadeIn(withDuration: 0.5)]))
        levelText.run(SKAction.sequence([SKAction.wait(forDuration: 1.00 + delay), SKAction.fadeIn(withDuration: 0.5)]))
        startText.run(SKAction.sequence([SKAction.wait(forDuration: 0.75 + delay), SKAction.fadeIn(withDuration: 0.5)]))
        
        #if os(iOS)
            
            let action = SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1.2, duration: 2.0), SKAction.wait(forDuration: 0.25), SKAction.scale(to: 1.0, duration: 2.0), SKAction.wait(forDuration: 0.5)]))
            aboutText.run(SKAction.sequence([SKAction.wait(forDuration: 1.75 + delay), action]))
            levelText.run(SKAction.sequence([SKAction.wait(forDuration: 1.5 + delay), action]))
            startText.run(SKAction.sequence([SKAction.wait(forDuration: 1.25 + delay), action]))
            
        #endif
    }
    
    var section = 0
    var level = 1
    func touchDown(atPoint pos : CGPoint)
    {
        if beginText.containsTouchPoint(pos)
        {
            transitionToSelection(delay: 0)
        }
        else if startText.containsTouchPoint(pos)
        {
            levelText.run(SKAction.fadeOut(withDuration: 0.5))
            aboutText.run(SKAction.fadeOut(withDuration: 0.5))
            titleText.run(SKAction.fadeOut(withDuration: 0.5))
            
            let a = Color.getLevel().components(separatedBy: "\n")[0].components(separatedBy: ".")
            
            let s = Int(a[0])!
            let l = Int(a[1])!
            
            section = s
            level = l
            
            self.run(SKAction.sequence([SKAction.wait(forDuration: 0.6), SKAction.run({self.view!.presentScene(GameScene(size: self.view!.frame.size, section: self.section, level: self.level))})]))
        }
        else if levelText.containsTouchPoint(pos)
        {
            startText.run(SKAction.fadeOut(withDuration: 0.5))
            aboutText.run(SKAction.fadeOut(withDuration: 0.5))
            titleText.run(SKAction.fadeOut(withDuration: 0.5))
            
            self.run(SKAction.sequence([SKAction.wait(forDuration: 0.6), SKAction.run({self.view!.presentScene(LevelScene(size: self.view!.frame.size))})]))
        }
        else if aboutText.containsTouchPoint(pos)
        {
            startText.run(SKAction.fadeOut(withDuration: 0.5))
            levelText.run(SKAction.fadeOut(withDuration: 0.5))
            
            self.run(SKAction.sequence([SKAction.wait(forDuration: 0.6), SKAction.run({self.view!.presentScene(AboutScene(size: self.view!.frame.size))})]))
        }
    }
    
    func touchUp(atPoint pos : CGPoint)
    {
        
    }
    
    func touchMoved(atPoint pos : CGPoint)
    {
        if startText.containsTouchPoint(pos)
        {
            startText.run(SKAction.scale(to: 1.2, duration: 0.5))
        }
        else
        {
            startText.run(SKAction.scale(to: 1.0, duration: 0.5))
        }
        
        if levelText.containsTouchPoint(pos)
        {
            levelText.run(SKAction.scale(to: 1.2, duration: 0.5))
        }
        else
        {
            levelText.run(SKAction.scale(to: 1.0, duration: 0.5))
        }
        
        if aboutText.containsTouchPoint(pos)
        {
            aboutText.run(SKAction.scale(to: 1.2, duration: 0.5))
        }
        else
        {
            aboutText.run(SKAction.scale(to: 1.0, duration: 0.5))
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
    
    #endif
}
