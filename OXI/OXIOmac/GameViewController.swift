//
//  ViewController.swift
//  macTest
//
//  Created by Michael Kelly on 1/28/17.
//  Copyright © 2017 Michael Kelly. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {
    
    var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredContentSize = CGSize(width: 405, height: 720)
                
        if let view = self.skView {
            
            view.frame.size = preferredContentSize
            
            
            let scene = MainMenuScene(size: view.frame.size)
            scene.scaleMode = .aspectFill
            
            view.presentScene(scene)
            
            let gestureRecognizer = NSPanGestureRecognizer(target: self, action: #selector(GameViewController.screenTouched(_:)))
            self.view.addGestureRecognizer(gestureRecognizer)
            gestureRecognizer.buttonMask = 0x2
        }
        
    }
    
    override func viewDidAppear() {
        view.window!.acceptsMouseMovedEvents = true
        view.window!.title = "OXIO"
    }
    
    var iPoint = CGPoint()
    var iScale = CGFloat(0)
    
    func screenTouched(_ sender: NSPanGestureRecognizer)
    {
        if sender.state == .began
        {
            iPoint = skView.scene!.getInitialCameraPoint()
            iScale = skView.scene!.getInitialCameraScale()
        }
        
        let p1 = sender.translation(in: skView)
        
        if skView.scene! is LevelScene
        {
            let p2 = CGPoint(x: iPoint.x, y: iPoint.y - (iScale * p1.y))
            
            skView.scene!.moveCamera(p2)
        }
        else
        {
            let p2 = iPoint - (iScale * p1)
            
            skView.scene!.moveCamera(p2)
        }
        
        if sender.state == .ended
        {
            skView.scene!.stopCameraMovement()
        }
    }
}

