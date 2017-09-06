//
//  GameViewController.swift
//  OXIO
//
//  Created by Michael Kelly on 9/14/16.
//  Copyright © 2016 Michael Kelly. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController
{
    var gameView: SKView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
                
        Color.isPhone = (view.frame.height / view.frame.width) > 1.5
        
        //super.viewDidLoad()
        
        gameView = SKView(frame: view.frame)
        gameView.center = view.center
        
        view.addSubview(gameView)
        let newScene = MainMenuScene(size: gameView.frame.size)
        gameView.presentScene(newScene)
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(GameViewController.screenTouched(_:)))
        gestureRecognizer.minimumNumberOfTouches = 2
        gestureRecognizer.maximumNumberOfTouches = 2
        self.gameView.addGestureRecognizer(gestureRecognizer)
        
        let gestureRecognizer2 = UIPinchGestureRecognizer(target: self, action: #selector(GameViewController.screenZoomed(_:)))
        gestureRecognizer2.requiresExclusiveTouchType = true
        self.gameView.addGestureRecognizer(gestureRecognizer2)
    }
    
    var iPoint = CGPoint()
    
    func screenTouched(_ sender: UIPanGestureRecognizer)
    {
        if sender.state == .began
        {
            iPoint = gameView.scene!.getInitialCameraPoint()
            iScale = gameView.scene!.getInitialCameraScale()
        }
        
        let p1 = sender.translation(in: gameView)
        
        if gameView.scene! is LevelScene
        {
            let p2 = CGPoint(x: iPoint.x, y: iPoint.y + (iScale * p1.y))
            
            gameView.scene!.moveCamera(p2)
        }
        else
        {
            let p2 = CGPoint(x: iPoint.x - (iScale * p1.x), y: iPoint.y + (iScale * p1.y))
            
            gameView.scene!.moveCamera(p2)
        }
        
        if sender.state == .ended
        {
            gameView.scene!.stopCameraMovement()
        }
    }
    
    var iScale = CGFloat(1.0)
    func screenZoomed(_ sender: UIPinchGestureRecognizer)
    {
        if sender.state == .began
        {
            iScale = gameView.scene!.getInitialCameraScale()
        }
        
        gameView.scene!.scaleCamera(iScale / sender.scale)
        
        if sender.state == .ended
        {
            gameView.scene!.stopCameraMovement()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
