//
//  AboutScene.swift
//  OXIO
//
//  Created by Michael Kelly on 2/18/17.
//  Copyright © 2017 Michael Kelly. All rights reserved.
//

import Foundation
import SpriteKit


class AboutScene: SKScene
{
    let logo = SKSpriteNode()
    let labelText = SKLabelNode(text: "Created By Michael Kelly")
    let titleText = SKLabelNode(text: "OXIO")
    let versionText = SKLabelNode(text: "v" + Color.getVersion())
    let backButton = SKLabelNode(text: "Back")
    let cam = SKCameraNode()
    
    override func didMove(to view: SKView)
    {
        let scale = Color.shapeSize / 20
        
        cam.xScale = 1
        cam.yScale = 1
        self.camera = cam
        
        cam.position = self.position
        
        self.addChild(cam)
        
        self.backgroundColor = Color.white
        
        logo.texture = SKTexture(imageNamed: "logo")
        logo.size = 4.0 * CGSize(width: Color.shapeSize, height: Color.shapeSize)
        logo.position = scale * CGPoint(x: 0, y: -50)
        logo.popIn()
        self.addChild(logo)
        
        labelText.position = scale * CGPoint(x: 0, y: 60)
        labelText.fontSize = Color.shapeSize / 2
        self.addChild(labelText)
        
        titleText.position = scale * CGPoint(x: 0, y: 80)
        titleText.fontSize = Color.shapeSize * 2
        self.addChild(titleText)
        
        versionText.position = scale * CGPoint(x: 0, y: -100)
        versionText.fontSize = Color.shapeSize / 4
        self.addChild(versionText)
        
        var y = CGFloat(120)
        
        if (Color.isPhone)
        {
            y = CGFloat(160)
        }
        
        #if os(macOS)
            y = CGFloat(160)
        #endif
        
        backButton.fontSize = scale * 16 / 1.5
        backButton.position = scale * CGPoint(x: -88, y: (-y + 5)) //15
        backButton.horizontalAlignmentMode = .left
        backButton.verticalAlignmentMode = .center
        self.addChild(backButton)
    }
    func touchDown(atPoint pos : CGPoint)
    {
        let p = pos
        
        if backButton.contains(p)
        {
            
            backButton.run(SKAction.fadeOut(withDuration: 0.5))
            labelText.run(SKAction.fadeOut(withDuration: 0.5))
            versionText.run(SKAction.fadeOut(withDuration: 0.5))

            logo.popOut()
            
            self.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.run({self.view!.presentScene(MainMenuScene(size: self.view!.frame.size, b: false))})]))
            
        }
    }
    
    func touchUp(atPoint pos : CGPoint)
    {
        
    }
    
    func touchMoved(atPoint pos : CGPoint)
    {
        
    
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




