//
//  GameScene.swift
//  OXIO
//
//  Created by Michael Kelly on 9/14/16.
//  Copyright © 2016 Michael Kelly. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioToolbox

#if os(iOS)
    import UIKit
#else
    import AppKit
#endif

class GameScene: SKScene {
    
    var blockArray = [Block]()
    var boundingBoxArray = [BoundingBox]()
    var lineArray = [Line]()
    var triangleArray = [Triangle]()
    var pathArray = [Path]()
    var trackArray = [Track]()
    var debugMode = false
    
    var dot = SKShapeNode()
    var debugDot = SKShapeNode()
    var point = CGPoint(x: 0, y: 0)
    var enabled = true
    var endEnabled = true
    var transition = false
    
    let cam = SKCameraNode()
    let backButton = SKLabelNode(text: "Back")
    
    let levelText = SKLabelNode(text: "Level 1")
    let completeText = SKLabelNode(text: "Level Complete")
    
    var moves = 0
    var starCount = 3
    let moveText = SKLabelNode(text: "Moves: 0")
    
    var star1 = SKShapeNode()
    var star2 = SKShapeNode()
    var star3 = SKShapeNode()
    var s1 = SKShapeNode()
    var s2 = SKShapeNode()
    var s3 = SKShapeNode()
    
    let track = Track()
    
    var runTrack = false
    var section = 1
    var level = 1
    
    var zooming = false
    
    convenience init(size: CGSize, section: Int, level: Int)
    {
        self.init(size: size)
        
        self.section = section
        self.level = level
    }
    
    override func didMove(to view: SKView)
    {
        view.shouldCullNonVisibleNodes = false
        
        Color.shapeSize = view.bounds.width -/ Color.numOfColumns
        
        self.backgroundColor = Color.white
        
        cam.xScale = 1
        cam.yScale = 1
        self.camera = cam
        
        dot = SKShapeNode.init(ellipseOf: 0.6 * CGSize(width: Color.shapeSize, height: Color.shapeSize))
        
        debugDot = SKShapeNode.init(circleOfRadius: 0.15 * Color.shapeSize)
        debugDot.zPosition = 5
        debugDot.strokeColor = Color.red
                
        /*
         let littleDot = SKShapeNode.init(ellipseOf: 0.2 * CGSize(width: Color.shapeSize, height: Color.shapeSize))
         littleDot.fillColor = Color.white
         littleDot.strokeColor = Color.white
         littleDot.position = CGPoint(x: 0, y: Color.shapeSize -* 0.2)
         dot.addChild(littleDot)
         */
        
        cam.position = self.position
        generateLevel()
        
        self.addChild(cam)
        //180 by 240 ipad 180 by 320 iphone
        let scale = Color.shapeSize -/ 20.0
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
        cam.addChild(backButton)
        
        moveText.fontSize = scale * 16 / 1.5
        moveText.position = scale * CGPoint(x: -88, y: (-y + 5))
        moveText.horizontalAlignmentMode = .left
        moveText.verticalAlignmentMode = .center
        //cam.addChild(moveText)
        
        backButton.zPosition = 2
        moveText.zPosition = 2
        dot.zPosition = 1.5
        
        completeText.fontSize = Color.shapeSize
        completeText.position = scale * CGPoint(x: 0, y: 80)
        completeText.alpha = 0
        completeText.zPosition = 5
        //cam.addChild(completeText)
        
        levelText.fontSize = Color.shapeSize
        levelText.position = scale * CGPoint(x: 0, y: -80)
        levelText.alpha = 0
        levelText.zPosition = 5
        //cam.addChild(levelText)
        
        let r1 = Color.shapeSize -* 0.18 * 0.75
        let r2 = Color.shapeSize -* 0.45 * 0.75
        
        var starPointArray = [CGPoint]()
        
        for x in 0..<11
        {
            var r = r1
            
            if x % 2 == 0
            {
                r = r2
            }
            
            if x == 0
            {
                starPointArray.append(r * CGPoint(x: cos(CGFloat.pi -/ 5 -* x), y: sin(CGFloat.pi -/ 5 -* x)))
            }
            else
            {
                starPointArray.append(r * CGPoint(x: cos(CGFloat.pi -/ 5 -* x), y: sin(CGFloat.pi -/ 5 -* x)))
            }
        }
        
        let star = SKShapeNode()
        star.position = scale * CGPoint(x: 50, y: (-y + 7))
        star.zPosition = 2
        star.path = Color.generatePath(array: starPointArray).cgPath
        star.strokeColor = Color.black
        star.fillColor = Color.lightY
        star.zRotation = .pi -/ 2
        
        star1 = star.copy() as! SKShapeNode
        star1.position = scale * CGPoint(x: 50, y: (-y + 7))
        //cam.addChild(star1)
        
        star2 = star1.copy() as! SKShapeNode
        star2.position = scale * CGPoint(x: 65, y: (-y + 7))
        //cam.addChild(star2)
        
        star3 = star1.copy() as! SKShapeNode
        star3.position = scale * CGPoint(x: 80, y: (-y + 7))
        //cam.addChild(star3)
        
        s1 = star1.copy() as! SKShapeNode
        s1.fillColor = Color.clear
        s1.position = scale * CGPoint(x: -15, y: -30)
        
        s2 = s1.copy() as! SKShapeNode
        s2.position = scale * CGPoint(x: 0, y: -30)
        
        s3 = s1.copy() as! SKShapeNode
        s3.position = scale * CGPoint(x: 15, y: -30)
        
        //cam.addChild(s1)
        //cam.addChild(s2)
        //cam.addChild(s3)
        
        s1.alpha = 0
        s2.alpha = 0
        s3.alpha = 0
        
        debugDot.fillColor = Color.red
        debugDot.isHidden = true
        self.addChild(debugDot)
        
        
        if runTrack
        {
            track.addFragment(str: "l,-30,200,30,200")
            track.addFragment(str: "c,0,200,30,0,180")
            track.addFragment(str: "c,60,200,30,180,360")
            track.addFragment(str: "l,-60,260,60,200")

            track.render()
        
            self.addChild(track)
            
            /*
            blockArray.first!.track = track
            blockArray.first!.trackSet = true
            
            
            triangleArray.first!.track = track
            triangleArray.first!.trackSet = true
            
            */
            //debugDot.position = Color.shapeSize -/ 20 * CGPoint(x: -30, y: 200)
        }
        
        self.addChild(node)

    }
    
    override func update(_ currentTime: TimeInterval)
    {
        
        debugDot.isHidden = !debugMode
        
        view!.showsFPS = true
        view!.showsNodeCount = debugMode
        view!.showsDrawCount = debugMode
        
        if !endEnabled
        {
            backButton.fontColor = Color.red
        }
        else
        {
            backButton.fontColor = Color.black
        }
        
        
        
        #if os(iOS)
            view!.showsFPS = true
            view!.showsNodeCount = true
            view!.showsDrawCount = true
            
            
            
            
            if !transition
            {
                var rotationNum = 0
                let num = UIDevice.current.orientation.rawValue
                
                if num != 5
                {
                    
                    if num == 2
                    {
                        rotationNum = 2
                    }
                    if num == 3
                    {
                        rotationNum = 3
                    }
                    if num == 4
                    {
                        rotationNum = 1
                    }
                    
                    for block in blockArray
                    {
                        block.text.run(SKAction.rotate(toAngle: CGFloat.pi -* 0.5 -* rotationNum, duration: 0.1))
                    }
                    
                    completeText.run(SKAction.rotate(toAngle: CGFloat.pi -* 0.5 -* rotationNum, duration: 0.1))
                    levelText.run(SKAction.rotate(toAngle: CGFloat.pi -* 0.5 -* rotationNum, duration: 0.1))
                    moveText.run(SKAction.rotate(toAngle: CGFloat.pi -* 0.5 -* rotationNum, duration: 0.1))
                    backButton.run(SKAction.rotate(toAngle: CGFloat.pi -* 0.5 -* rotationNum, duration: 0.1))
                    
                    s1.run(SKAction.rotate(toAngle: CGFloat.pi -* 0.5 -* (rotationNum + 1), duration: 0.1))
                    s2.run(SKAction.rotate(toAngle: CGFloat.pi -* 0.5 -* (rotationNum + 1), duration: 0.1))
                    s3.run(SKAction.rotate(toAngle: CGFloat.pi -* 0.5 -* (rotationNum + 1), duration: 0.1))
                    star1.run(SKAction.rotate(toAngle: CGFloat.pi -* 0.5 -* (rotationNum + 1), duration: 0.1))
                    star2.run(SKAction.rotate(toAngle: CGFloat.pi -* 0.5 -* (rotationNum + 1), duration: 0.1))
                    star3.run(SKAction.rotate(toAngle: CGFloat.pi -* 0.5 -* (rotationNum + 1), duration: 0.1))
                    
                    let scale = Color.shapeSize -/ 20.0
                    
                    var y = CGFloat(120)
                    
                    if (Color.isPhone)
                    {
                        y = CGFloat(160)
                    }
                    
                    if num == 1
                    {
                        completeText.position = scale * CGPoint(x: 0, y: 80)
                        levelText.position = scale * CGPoint(x: 0, y: -80)
                        
                        backButton.position = scale * CGPoint(x: -88, y: (-y + 5)) //15
                        moveText.position = scale * CGPoint(x: -88, y: (-y + 5))
                        
                        s1.position = scale * CGPoint(x: -15, y: -30)
                        s2.position = scale * CGPoint(x: 0, y: -30)
                        s3.position = scale * CGPoint(x: 15, y: -30)
                        
                        star1.position = scale * CGPoint(x: 50, y: (-y + 7))
                        star2.position = scale * CGPoint(x: 65, y: (-y + 7))
                        star3.position = scale * CGPoint(x: 80, y: (-y + 7))
                    }
                    
                    if num == 2
                    {
                        completeText.position = scale * CGPoint(x: 0, y: -80)
                        levelText.position = scale * CGPoint(x: 0, y: 80)
                        
                        backButton.position = scale * CGPoint(x: 88, y: (y - 5)) //15
                        moveText.position = scale * CGPoint(x: 88, y: (y - 5))
                        
                        s1.position = scale * CGPoint(x: 15, y: 30)
                        s2.position = scale * CGPoint(x: 0, y: 30)
                        s3.position = scale * CGPoint(x: -15, y: 30)
                        
                        star1.position = scale * CGPoint(x: -50, y: (y - 7))
                        star2.position = scale * CGPoint(x: -65, y: (y - 7))
                        star3.position = scale * CGPoint(x: -80, y: (y - 7))
                    }
                    //180
                    if num == 3
                    {
                        completeText.position = scale * CGPoint(x: 60, y: 0)
                        levelText.position = scale * CGPoint(x: -60, y: 0)
                        
                        backButton.position = scale * CGPoint(x: -85, y: y) //75
                        moveText.position = scale * CGPoint(x: -85, y: y)
                        
                        s1.position = scale * CGPoint(x: -20, y: 15)
                        s2.position = scale * CGPoint(x: -20, y: 0)
                        s3.position = scale * CGPoint(x: -20, y: -15)
                        
                        star1.position = scale * CGPoint(x: -83, y: (40 - y))
                        star2.position = scale * CGPoint(x: -83, y: (25 - y))
                        star3.position = scale * CGPoint(x: -83, y: (10 - y))
                    }
                    
                    if num == 4
                    {
                        completeText.position = scale * CGPoint(x: -60, y: 0)
                        levelText.position = scale * CGPoint(x: 60, y: 0)
                        
                        backButton.position = scale * CGPoint(x: 85, y: -y) //75
                        moveText.position = scale * CGPoint(x: 85, y: -y)
                        
                        s1.position = scale * CGPoint(x: 20, y: -15)
                        s2.position = scale * CGPoint(x: 20, y: 0)
                        s3.position = scale * CGPoint(x: 20, y: 15)
                        
                        star1.position = scale * CGPoint(x: 83, y: (y - 40))
                        star2.position = scale * CGPoint(x: 83, y: (y - 25))
                        star3.position = scale * CGPoint(x: 83, y: (y - 10))
                    }
                }
            }
            
        #endif
        
        /*
         var goal: BoundingBox!
         
         for box in boundingBoxArray
         {
         if box.obstacle == 2
         {
         goal = box
         break
         }
         }
         
         let distance = dot.position - convert(goal.dot.position, from: goal)
         
         
         if distance.y != 0
         {
         dot.zRotation = atan(distance.y / distance.x) + CGFloat.pi -* 0.5
         
         if distance.x < 0
         {
         dot.zRotation -= CGFloat(M_PI)
         }
         }
         */
        
        
        #if os(macOS)
            
            if debugMode
            {
                
                var found = false
                
                if !found
                {
                    for triangle in triangleArray
                    {
                        if found
                        {
                            continue
                        }
                        
                        if triangle.debugSelected
                        {
                            debugDot.position = triangle.position
                            found = true
                        }
                    }
                }
                
                if !found
                {
                    for block in blockArray
                    {
                        if found
                        {
                            continue
                        }
                        
                        if block.debugSelected
                        {
                            debugDot.position = block.position
                            found = true
                        }
                    }
                }
                
                if !found
                {
                    for line in lineArray
                    {
                        if found
                        {
                            continue
                        }
                        
                        if line.debugSelected
                        {
                            debugDot.position = line.position + (line.p1 + line.p2) / 2
                            found = true
                        }
                    }
                }
                
                if !found
                {
                    for bBox in boundingBoxArray
                    {
                        if found
                        {
                            continue
                        }
                        
                        if bBox.debugSelected
                        {
                            debugDot.position = bBox.position
                            found = true
                        }
                    }
                }
            }
            
        #endif
        
        
        
        if !transition
        {
            calculatePostition()
        }
        if enabled
        {
            var goal = BoundingBox(x: 0, y: 0, w: 0, h: 0)
            for bBox in boundingBoxArray
            {
                if bBox.obstacle == 2
                {
                    goal = bBox
                }
            }
            
            for bBox in boundingBoxArray
            {
                if bBox.obstacle != 3
                {
                    continue
                }
                
                //needs to look at distance from block
                var hasIntersected = false
                var intersectedBlock = Block(0, 0)
                var distance = Color.distanceBetween(goal.position, bBox.position)
                
                
                for block in blockArray
                {
                    if hasIntersected
                    {
                        //continue
                    }
                    
                    if Color.lineIntersectsBox(goal.position, endPoint: bBox.position, blockPoint: block.position, blockSize: block.size) && Color.distanceBetween(bBox.position, block.position) < distance && !bBox.intersects(block)
                    {
                        hasIntersected = true
                        intersectedBlock = block
                        distance = Color.distanceBetween(bBox.position, block.position)
                    }
                }
                
                if hasIntersected
                {
                    bBox.setBoxWeight(Int(intersectedBlock.weight))
                    bBox.changeNode.texture = Color.getTextureFromWeight(Int(intersectedBlock.weight))
                    
                    if !bBox.activated
                    {
                        bBox.activate()
                    }
                }
                if !hasIntersected && bBox.activated
                {
                    bBox.deactivate()
                }
            }
            
            for block in blockArray
            {
                for bBox in boundingBoxArray
                {
                    if (bBox.containsBlock(block) && (bBox.obstacle == 0 || (bBox.obstacle == 3 && bBox.activated)))
                    {
                        if (block.weight != bBox.getWeight())
                        {
                            block.changeType(bBox.weight)
                            
                            #if os(iOS)
                                
                                AudioServicesPlaySystemSound(1003)
                                
                                //UIImpactFeedbackGenerator.init().impactOccurred()
                                
                            #else
                                NSHapticFeedbackManager.defaultPerformer().perform(NSHapticFeedbackManager.FeedbackPattern.alignment, performanceTime: NSHapticFeedbackManager.PerformanceTime.default)
                            #endif
                        }
                    }
                }
            }
            

        }
        
        if !debugMode && !transition
        {
            for bBox in boundingBoxArray
            {
                
                if bBox.obstacle == 2 && endEnabled
                {
                    if Color.distanceBetween(dot.position, bBox.position) < 0.5 *- (dot.frame.width + bBox.frame.width)
                    {
                        moveToNextLevel()
                    }
                }
                
                if enabled
                {
                    if bBox.obstacle == 1
                    {
                        if bBox.intersects(dot)
                        {
                            //make camera move over thing if not on screen
                            resetLevel()
                        }
                    }
                }
            }
        }
        
        //loadAssets()
    }
    
    
    let node = SKShapeNode()
    
    func loadAssets()
    {
        if debugMode
        {
            return
        }
        

        
        var s = camera!.xScale
        
        if s < 1
        {
            s = 1
        }
        
        let f = view!.frame.size
        let p = camera!.position
        
        //s = (20 *- s /- Color.shapeSize)
        
        var x5 = CGPoint()
        for box in boundingBoxArray
        {
            if box.obstacle == 2
            {
                x5 = s * (box.position)
                break
            }
        }
        
        //let f = (camera!.xScale * 20 -/ Color.shapeSize) * view!.frame.maxY
        
        //print(camera!.position)
        
//(20 *- s /- Color.shapeSize) *
        
        
        
        let q = scene!.convert(camera!.position, from: self)
        
        let r = scene!.frame.offsetBy(dx: scene!.frame.width / 2 - q.x, dy: scene!.frame.height / 2 - q.y)

        //print(view!.frame.origin)
        
        
        let x1 = s * r.origin//s * CGPoint(x: -f.width / 2, y: -f.height / 2) + p
        let x2 = s * CGPoint(x: r.origin.x + r.width, y: r.origin.y)//s * CGPoint(x: -f.width / 2, y: f.height / 2) + p
        let x3 = s * CGPoint(x: r.origin.x + r.width, y: r.origin.y + r.height)//s * CGPoint(x: f.width / 2, y: f.height / 2) + p
        let x4 = s * CGPoint(x: r.origin.x, y: r.origin.y + r.height)//s * CGPoint(x: f.width / 2, y: -f.height / 2) + p

        //print(x1, x2, x3, x4)
        
        var minX = CGFloat(10000)
        var minY = CGFloat(10000)
        var maxX = CGFloat(-10000)
        var maxY = CGFloat(-10000)

        let pArray = [x1, x2, x3, x4]//, x5]
        
        for p in pArray
        {
            if p.x > maxX
            {
                maxX = p.x
            }
            if p.y > maxY
            {
                maxY = p.y
            }
            if p.x < minX
            {
                minX = p.x
            }
            if p.y < minY
            {
                minY = p.y
            }
        }
        
        let frame = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        
        
        node.lineWidth = 2
        node.strokeColor = Color.black
        
        
        #if os(iOS)
            let path = UIBezierPath()
            path.move(to: CGPoint(x: minX, y: minY))
            path.addLine(to: CGPoint(x: maxX, y: minY))
            path.addLine(to: CGPoint(x: maxX, y: maxY))
            path.addLine(to: CGPoint(x: minX, y: maxY))
            path.addLine(to: CGPoint(x: minX, y: minY))
        #else
            let path = NSBezierPath()
            path.move(to: CGPoint(x: minX, y: minY))
            path.line(to: CGPoint(x: maxX, y: minY))
            path.line(to: CGPoint(x: maxX, y: maxY))
            path.line(to: CGPoint(x: minX, y: maxY))
            path.line(to: CGPoint(x: minX, y: minY))
        #endif
        


        node.path = path.cgPath
        
        
        //print(frame)
        
        for block in blockArray
        {
            if !block.frame.intersects(frame)
            {
                block.removeFromParent()
            }
            else if !self.children.contains(block)
            {
                self.addChild(block)
            }
        }
        
        
    }
    
    
    
    
    func calculatePostition()
    {
        //need for triangles and if wieghts = 0
        var x = CGFloat(0.0)
        var y = CGFloat(0.0)
        var w = CGFloat(0.0)
        
        for block in blockArray
        {
            x += block.weightedX()
            y += block.weightedY()
            w += block.weight
        }
        
        if (w == 0)
        {
            x = 0
            y = 0
        }
        else
        {
            x = x /- w
            y = y /- w
        }
        
        dot.position = CGPoint(x: x, y: y)
        
        for block in blockArray
        {
            generatePath(block)
        }
    }
    
    func generatePath(_ block: Block)
    {
        block.line.path = Color.generatePath(array: [block.position, dot.position]).cgPath
    }
    
    func touchMoved(toPoint pos: CGPoint)
    {
        if !enabled
        {
            return
        }
        
        debugDot.isHidden = false
        
        /*
        if runTrack
        {
            //debugDot.position = track.findPoint(p: pos, cp: debugDot.position)
        }
        
        
        if wasSelected
        {
            //first change the was selected so it actually moves add in the starcount thing here
            wasSelected = false
            moves += 1
            moveText.text = "Moves: " + moves
        }
        */
        
        var p = pos
        
        /*
        for triangle in triangleArray
        {
            if !triangle.selected
            {
                continue
            }
            
            if triangle.trackSet
            {
                p = triangle.track.findPoint(p: p, cp: triangle.position)
            }
            
            triangle.position = p
            
            #if os(macOS)
                
                if debugMode && triangle.debugSelected
                {
                    triangle.position = p
                    
                    let controller = (NSApplication.shared().windows[1].contentViewController as! DebugController)
                    controller.clear(3)
                    controller.recieveTriangle(triangle: triangle)
                    
                    continue
                }
                
            #endif
        }
        */
        
        //fix this so it doesnt loop check for debug
        for line in lineArray
        {
            if !line.selected
            {
                continue
            }
            
            #if os(macOS)
                
                if debugMode && line.debugSelected
                {
                    line.position = p - (line.p1 + line.p2) / 2
                    
                    let controller = (NSApplication.shared().windows[1].contentViewController as! DebugController)
                    controller.clear(2)
                    controller.recieveLine(line: line)
                    
                    continue
                }
            #endif
            
        }
        
        for bBox in boundingBoxArray
        {
            if !bBox.selected
            {
                continue
            }
            
            #if os(macOS)
                
                if debugMode && bBox.debugSelected
                {
                    bBox.position = p
                    
                    let controller = (NSApplication.shared().windows[1].contentViewController as! DebugController)
                    controller.clear(1)
                    controller.recieveBox(bBox: bBox)
                    
                    continue
                }
            #endif
            
        }
        
        for block in blockArray
        {
            if !block.selected
            {
                continue
            }
            
            #if os(macOS)
                
                if debugMode && block.debugSelected
                {
                    block.position = p
                    
                    let controller = (NSApplication.shared().windows[1].contentViewController as! DebugController)
                    controller.clear(0)
                    controller.recieveBlock(block: block)
                    
                    continue
                }
            #endif
            
            let p1 = block.position
            
            if block.trackSet
            {
                p = block.track.findPoint(p: p, cp: block.position)
            }
            
            var iterations = Color.distanceBetween(p, p1) /- Int(10)
            if iterations < 15
            {
                iterations = 15
            }
            
            let dx = (p.x - p1.x) -/ iterations
            let dy = (p.y - p1.y) -/ iterations
            var done = false
            
            for x in 0 ..< iterations
            {
                if done
                {
                    continue
                }
                let lastPoint = block.position
                block.position = CGPoint(x: p1.x + (x *- dx), y: p1.y)
                for line in lineArray
                {
                    if done
                    {
                        continue
                    }
                    if block.intersects(line.line)
                    {
                        if !line.solid && !line.values.contains(Int(block.weight))
                        {
                            block.position = lastPoint
                            done = true
                            
                            #if os(iOS)
                                
                                //AudioServicesPlaySystemSound(1003)
                                
                                //UIImpactFeedbackGenerator.init().impactOccurred()
                                
                            #else
                                if x > 2
                                {
                                    NSHapticFeedbackManager.defaultPerformer().perform(NSHapticFeedbackManager.FeedbackPattern.alignment, performanceTime: NSHapticFeedbackManager.PerformanceTime.default)
                                }
                            #endif
                        }
                    }
                }
                
            }
            
            let p2 = block.position
            
            done = false
            for x in 0 ..< iterations
            {
                if done
                {
                    continue
                }
                let lastPoint = block.position
                block.position = CGPoint(x: p2.x, y: p2.y + (x *- dy))
                for line in lineArray
                {
                    if done
                    {
                        continue
                    }
                    if block.intersects(line.line)
                    {
                        if !line.solid && !line.values.contains(Int(block.weight))
                        {
                            block.position = lastPoint
                            done = true
                            
                            #if os(iOS)
                                
                                //AudioServicesPlaySystemSound(1003)
                                
                                //UIImpactFeedbackGenerator.init().impactOccurred()
                                
                            #else
                                
                                if x > 2
                                {
                                    NSHapticFeedbackManager.defaultPerformer().perform(NSHapticFeedbackManager.FeedbackPattern.alignment, performanceTime: NSHapticFeedbackManager.PerformanceTime.default)
                                }
                            #endif
                        }
                    }
                }
            }
        }
    }
    
    func touchDown(atPoint pos : CGPoint)
    {
        if !enabled
        {
            return
        }
        let p = pos
        
        var selected = false
        
        if zooming
        {
            camera!.removeAllActions()
            camera!.xScale = 1
            camera!.yScale = 1
            camera!.position = CGPoint()
            zooming = false
        }
        
        
        /*
        for triangle in triangleArray
        {
            triangle.debugSelected = false
            
            if triangle.pathSet
            {
                continue
            }
            
            if triangle.contains(p)
            {
                triangle.selected = true
                wasSelected = true
                
                #if os(macOS)
                    
                    if !selected && debugMode
                    {
                        triangle.debugSelected = true
                        
                        let controller = (NSApplication.shared().windows[1].contentViewController as! DebugController)
                        controller.recieveTriangle(triangle: triangle)
                        
                        selected = true
                    }
                    
                #endif
                
                break
            }
        }
        */
        
        for block in blockArray
        {
            block.debugSelected = false
            
            if block.pathSet
            {
                continue
            }
        
            if block.contains(p)
            {
                block.selected = true
                
                if !wasSelected
                {
                    self.run(SKAction.playSoundFileNamed("Sounds/bigPop.wav", waitForCompletion: true))
                }
                
                wasSelected = true
                
                #if os(macOS)
                    
                    if !selected && debugMode
                    {
                        block.debugSelected = true
                        
                        let controller = (NSApplication.shared().windows[1].contentViewController as! DebugController)
                        controller.recieveBlock(block: block)
                        
                        selected = true
                    }
                    
                #endif
                
                break
            }
        }
        
        if debugMode
        {
            for line in lineArray
            {
                line.debugSelected = false
                
                if line.contains(p)
                {
                    line.selected = true
                    
                    #if os(macOS)
                        
                        if !selected && debugMode
                        {
                            line.debugSelected = true
                            
                            let controller = (NSApplication.shared().windows[1].contentViewController as! DebugController)
                            controller.recieveLine(line: line)
                            
                            selected = true
                        }
                        
                    #endif
                    
                    break
                }
            }
            
            for bBox in boundingBoxArray
            {
                bBox.debugSelected = false
                
                if bBox.contains(p)
                {
                    bBox.selected = true
                    
                    #if os(macOS)
                        
                        if !selected && debugMode
                        {
                            bBox.debugSelected = true
                            
                            let controller = (NSApplication.shared().windows[1].contentViewController as! DebugController)
                            controller.recieveBox(bBox: bBox)
                            
                            selected = true
                        }
                        
                    #endif
                    break
                }
            }
        }
        
        let p2 = convert(p, to: camera!)
        
        if backButton.contains(p2)
        {
            if backButton.text == "Go back"
            {
                view!.presentScene(MainMenuScene(size: view!.frame.size, b: false))
            }
            else
            {
                backButton.text = "Go back"
            }
        }
        else
        {
            backButton.text = "Back"
        }
    }
    
    var wasSelected = false
    
    func touchUp(atPoint pos : CGPoint)
    {
        if !enabled
        {
            return
        }
        
        wasSelected = false
        
        for block in blockArray
        {
            if block.selected
            {
                self.run(SKAction.playSoundFileNamed("Sounds/smallPop.wav", waitForCompletion: true))
                block.selected = false
            }
        }
        
        /*
        for triangle in triangleArray
        {
            if triangle.selected
            {
                wasSelected = true
                triangle.selected = false
            }
        }
        */
        
        if debugMode
        {
            for line in lineArray
            {
                line.selected = false
            }
            
            for bBox in boundingBoxArray
            {
                bBox.selected = false
            }
        }
        
    }
    
    override func stopCameraMovement()
    {
        if !enabled
        {
            return
        }
        for block in blockArray
        {
            block.selected = false
        }
        for triangle in triangleArray
        {
            triangle.selected = false
        }
    }
    
    func resetLevel()
    {
        enabled = false
        for bBox in boundingBoxArray
        {
            bBox.removeAllActions()
            
            if bBox.obstacle == 1 && bBox.intersects(dot)
            {
                bBox.blink()
            }
            
            bBox.returnToInitialPosition()
        }
        
        for block in blockArray
        {
            block.removeAllActions()
            block.returnToInitialPosition()
        }
        
        dot.run(SKAction.sequence([SKAction.wait(forDuration: 1.5), SKAction.run({self.enabled = true})]))
    }
    
    func moveToNextLevel()
    {
        transition = true
        enabled = false
        
        Color.writeLevel(section: section, level: level)
        
        for b in blockArray
        {
            b.popOut()
            b.line.run(SKAction.fadeAlpha(to: 0, duration: 0.0))
        }
        
        for l in lineArray
        {
            l.run(SKAction.fadeAlpha(to: 0, duration: 0.0))
        }
        
        for b in boundingBoxArray
        {
            if b.obstacle != 2
            {
                b.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.run({b.popOut()})]))
            }
            else
            {
                b.run(SKAction.sequence([SKAction.wait(forDuration: 2.0), SKAction.run({b.popOut()})]))
                dot.run(SKAction.move(to: b.position, duration: 1.0))
                delta = b.position - camera!.position
                camera!.run(SKAction.scale(to: 5, duration: 2.0))
            }
        }
        
        dot.run(SKAction.sequence([SKAction.wait(forDuration: 3.0), SKAction.wait(forDuration: 1.0), SKAction.run({self.generateLevel()})]))
        completeText.run(SKAction.sequence([SKAction.fadeIn(withDuration: 0.5), SKAction.fadeOut(withDuration: 2.5)]))
        
        let m1 = SKAction.move(to: s1.position, duration: 0.5)
        let m2 = SKAction.move(to: s2.position, duration:0.5)
        let m3 = SKAction.move(to: s3.position, duration: 0.5)
        
        let r = SKAction.rotate(byAngle: 2 *- CGFloat.pi, duration: 0.5)
        
        let g1 = SKAction.group([m1, r])
        let g2 = SKAction.group([m2, r])
        let g3 = SKAction.group([m3, r])
        
        let t1 = SKAction.wait(forDuration: 0)
        let t2 = SKAction.wait(forDuration: 0.5)
        let t3 = SKAction.wait(forDuration: 1)
        
        //awful fix
        star1.run(SKAction.sequence([t1, g1, SKAction.run({self.star1.zRotation = self.star3.zRotation})]))
        star2.run(SKAction.sequence([t2, g2]))
        star3.run(SKAction.sequence([t3, g3]))
        
        s1.run(SKAction.fadeIn(withDuration: 0.25))
        s2.run(SKAction.fadeIn(withDuration: 0.25))
        s3.run(SKAction.fadeIn(withDuration: 0.25))
        
        s1.run(SKAction.sequence([SKAction.wait(forDuration: 0.55), SKAction.fadeOut(withDuration: 0.0)]))
        s2.run(SKAction.sequence([SKAction.wait(forDuration: 1.05), SKAction.fadeOut(withDuration: 0.0)]))
        s3.run(SKAction.sequence([SKAction.wait(forDuration: 1.55), SKAction.fadeOut(withDuration: 0.0)]))
        
        if starCount == 3
        {
            let up = SKAction.moveBy(x: 0, y: (Color.shapeSize -/ 20) * 25, duration: 0.18)
            let down = SKAction.moveBy(x: 0, y: (Color.shapeSize -/ 20) * -25, duration: 0.18)
            
            let jump = SKAction.repeat(SKAction.sequence([up, down]), count: 2)
            
            let spin = SKAction.sequence([SKAction.rotate(byAngle: -2 *- CGFloat.pi, duration: 0.36), SKAction.rotate(byAngle: 2 *- CGFloat.pi, duration: 0.36)])
            
            let action = SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.group([jump, spin])])
            
            star1.run(action)
            star2.run(action)
            star3.run(action)
        }
    }
    
    var delta = CGPoint()
    func generateLevel()
    {
        for block in blockArray
        {
            block.removeFromParent()
            block.line.removeFromParent()
        }
        for box in boundingBoxArray
        {
            box.removeFromParent()
        }
        for line in lineArray
        {
            line.removeFromParent()
        }
        
        blockArray.removeAll()
        boundingBoxArray.removeAll()
        lineArray.removeAll()
        pathArray.removeAll()
        
        if !Color.contains("Level" + section + "." + level)
        {
            section = 1
            level = 1
        }
        
        readInLevel("Level" + section + "." + level)
        
        levelText.text = "Level" + section + "." + level
        
        level += 1
        
        if level == 8
        {
            level = 1
            section += 1
        }
        
        dot.fillColor = Color.black
        dot.strokeColor = Color.black
        dot.lineWidth = 1
        calculatePostition()
        dot.isHidden = false
        
        if !self.children.contains(dot)
        {
            self.addChild(dot)
            camera!.xScale = 5
            camera!.yScale = 5
        }
        
        transition = false
        enabled = true
        
        camera!.position = dot.position - delta
        
        let a = SKAction.sequence([SKAction.run({self.zooming = true}), SKAction.wait(forDuration: 3), SKAction.run({self.zooming = false})])
        let b = SKAction.group([SKAction.scale(to: 1, duration: 3), SKAction.move(to: CGPoint(), duration: 3), a])
        
        camera!.run(SKAction.sequence([b]))
        
        levelText.run(SKAction.sequence([SKAction.fadeIn(withDuration: 0.5), SKAction.fadeOut(withDuration: 2.5)]))
        moves = 0
        moveText.text = "Moves: 0"
        
        let scale = Color.shapeSize -/ 20
        var y = CGFloat(120)
        
        if (Color.isPhone)
        {
            y = CGFloat(160)
        }
        
        #if os(macOS)
            y = CGFloat(160)
        #endif
        
        star1.position = scale * CGPoint(x: 50, y: (-y + 7))
        star2.position = scale * CGPoint(x: 65, y: (-y + 7))
        star3.position = scale * CGPoint(x: 80, y: (-y + 7))
        
        star1.zRotation = CGFloat.pi -/ 2
        star2.zRotation = CGFloat.pi -/ 2
        star3.zRotation = CGFloat.pi -/ 2
        
        matchPaths()
    }
    
    func delete()
    {
        for block in blockArray
        {
            if block.debugSelected
            {
                block.removeFromParent()
                blockArray.remove(at: blockArray.index(of: block)!)
                break
            }
        }
        
        for box in boundingBoxArray
        {
            if box.debugSelected
            {
                box.removeFromParent()
                boundingBoxArray.remove(at: boundingBoxArray.index(of: box)!)
                break
            }
        }
        
        for line in lineArray
        {
            if line.debugSelected
            {
                line.removeFromParent()
                lineArray.remove(at: lineArray.index(of: line)!)
                break
            }
        }
        
        for triangle in triangleArray
        {
            if triangle.debugSelected
            {
                triangle.removeFromParent()
                triangleArray.remove(at: triangleArray.index(of: triangle)!)
                break
            }
        }
    }
    
    var levelCounter = 1
    
    //180 by 220
    func readInLevel(_ str: String)
    {
        let lineText = Color.getFile(str + "/Line", debugMode).components(separatedBy: "\n")
        let boxText = Color.getFile(str + "/Box", debugMode).components(separatedBy: "\n")
        let blockText = Color.getFile(str + "/Block", debugMode).components(separatedBy: "\n")
        let pathText = Color.getFile(str + "/Path", debugMode).components(separatedBy: "\n*\n")
        let triangleText = Color.getFile(str + "/Triangle", debugMode).components(separatedBy: "\n")
        
        //x1,y1,x2,y2,values
        for x in 0 ..< lineText.count
        {
            if lineText[x] == ""
            {
                continue
            }
            let lineTextValues = lineText[x].components(separatedBy: ",")
            createLine(lineTextValues: lineTextValues)
        }
        
        //x,y,w,h,color/weight,type,id
        for x in 0 ..< boxText.count
        {
            if boxText[x] == ""
            {
                continue
            }
            let boxTextValues = boxText[x].components(separatedBy: ",")
            createBox(boxTextValues: boxTextValues)
        }
        
        //x,y,weight,id
        for x in 0 ..< blockText.count
        {
            if blockText[x] == ""
            {
                continue
            }
            let blockTextValues = blockText[x].components(separatedBy: ",")
            createBlock(blockTextValues: blockTextValues)
        }
        
        for path in pathText
        {
            if path == ""
            {
                continue
            }
            pathArray.append(Path(str: path))
        }
        
        //x,y,weight,id
        for x in 0 ..< triangleText.count
        {
            if triangleText[x] == ""
            {
                continue
            }
            let triangleTextValues = triangleText[x].components(separatedBy: ",")
            createTriangle(triangleTextValues: triangleTextValues)
        }
    }
    
    func createLine(lineTextValues: [String])
    {
        let scale = Color.shapeSize -/ 20.0
        
        let centerX = self.position.x
        let centerY = self.position.y
        
        let newLine = Line(x1: (Double(lineTextValues[0])! *- scale) + centerX, y1: (Double(lineTextValues[1])! *- scale) + centerY, x2: (Double(lineTextValues[2])! *- scale) + centerX, y2: (Double(lineTextValues[3])! *- scale) + centerY)
        
        newLine.addValues(splitValues(lineTextValues[4]))
        newLine.render()
        
        lineArray.append(newLine)
        
        self.addChild(newLine)
    }
    
    func createBox(boxTextValues: [String])
    {
        let scale = Color.shapeSize -/ 20.0
        
        let centerX = self.position.x
        let centerY = self.position.y
        
        let newBox = BoundingBox(x: (Double(boxTextValues[0])! *- scale) + centerX, y: (Double(boxTextValues[1])! *- scale) + centerY, w: (Double(boxTextValues[2])! *- scale), h: (Double(boxTextValues[3])! *- scale))
        
        let value = Int(boxTextValues[5])!
        
        if Int(boxTextValues[6]) != nil
        {
            newBox.id = Int(boxTextValues[6])!
        }
        
        if value == 0 || value == 3
        {
            //newBox.addId(splitValues(boxTextValues[6]))
        }
        if value != 2
        {
            newBox.setBoxWeight(Int(boxTextValues[4])!)
            newBox.texture = Color.getTextureFromWeight(Int(boxTextValues[4])!)
        }
        if value != 1
        {
            newBox.zPosition = -0.2
        }
        
        newBox.setBoxObstacle(value)
        
        boundingBoxArray.append(newBox)
        self.addChild(newBox)
    }
    
    
    func createBlock(blockTextValues: [String])
    {
        let scale = Color.shapeSize -/ 20.0
        
        let centerX = self.position.x
        let centerY = self.position.y
        
        let newBlock = Block(Int(blockTextValues[2])!, Int(blockTextValues[3])!)
        
        newBlock.setInitialPosition(scale * CGPoint(x: Double(blockTextValues[0])!, y: Double(blockTextValues[1])!) + CGPoint(x: centerX, y: centerY))
        
        blockArray.append(newBlock)
        self.addChild(newBlock.line)
        self.addChild(newBlock)
        newBlock.popIn()
        //newBlock.changeType(Int(newBlock.weight))
        newBlock.line.zPosition = -0.1
    }
    
    func createTriangle(triangleTextValues: [String])
    {
        let scale = Color.shapeSize -/ 20.0
        
        let centerX = self.position.x
        let centerY = self.position.y
        
        let newTriangle = Triangle(Int(triangleTextValues[2])!, Int(triangleTextValues[3])!)
        
        newTriangle.setInitialPosition(scale * CGPoint(x: Double(triangleTextValues[0])!, y: Double(triangleTextValues[1])!) + CGPoint(x: centerX, y: centerY))
        
        triangleArray.append(newTriangle)
        self.addChild(newTriangle)
        newTriangle.popIn()
        newTriangle.changeType(Int(newTriangle.weight))
    }
    
    func splitValues(_ str: String) -> [Int]
    {
        var array = [Int]()
        let myNSString = str as NSString
        
        for x in 0 ..< myNSString.length / 2
        {
            array.append(Int(myNSString.substring(with: NSRange(location: 2 * x, length: 2)))!)
        }
        
        return array
    }
    
    func matchPaths()
    {
        if levelCounter == 10
        {
            //pathArray.append(Path(strArray: Color.getFile("Path", false).components(separatedBy: "\n")))
        }
                
        for path in pathArray
        {
            for block in blockArray
            {
                if path.id == block.id
                {
                    block.pathNode = path
                    block.pathSet = true
                    path.runPath(node: block)
                }
            }
            
            for box in boundingBoxArray
            {
                if path.id == box.id
                {
                    box.pathNode = path
                    box.pathSet = true
                    path.runPath(node: box)
                }
            }
            /*
            for line in lineArray
            {
                if path.id == line.id
                {
                    line.pathNode = path
                }
            }
            
            for triangle in triangleArray
            {
                if path.id == triangle.id
                {
                    triangle.pathNode = path
                }
            }
            */
        }
    }
    
    func matchTracks()
    {
        for track in trackArray
        {
            for block in blockArray
            {
                if block.id == track.id
                {
                    block.track = track
                    block.trackSet = true
                }
            }
        }
    }
    
    #if os(iOS)
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
    self.touchMoved(toPoint: touches.first!.location(in: self))
    }
    
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
    
    override func mouseDragged(with event: NSEvent)
    {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent)
    {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    var iScale = CGFloat(1.0)
    var iPoint = CGPoint()
    
    override func magnify(with event: NSEvent)
    {
        scaleCamera(camera!.xScale / (event.magnification + 1.0))
        
        if event.phase == .ended
        {
            stopCameraMovement()
        }
    }
    
    override func keyDown(with event: NSEvent)
    {
        let key = Int(event.keyCode)
        
        //123 l 124 r 125 d 126 u
        //0 a 1 s 2 d 13 w
        //27 - 24 + 53 esc
        
        if key == 123 || key == 0
        {
            camera!.run(SKAction.moveBy(x: -(Color.shapeSize / 5) * camera!.xScale, y: 0, duration: 0.085))
        }
        if key == 124 || key == 2
        {
            camera!.run(SKAction.moveBy(x: (Color.shapeSize / 5) * camera!.xScale, y: 0, duration: 0.085))
        }
        if key == 125 || key == 1
        {
            camera!.run(SKAction.moveBy(x: 0, y: -(Color.shapeSize / 5) * camera!.xScale, duration: 0.085))
        }
        if key == 126 || key == 13
        {
            camera!.run(SKAction.moveBy(x: 0, y: (Color.shapeSize / 5) * camera!.xScale, duration: 0.085))
        }
        if key == 27
        {
            camera!.run(SKAction.scale(to: camera!.xScale - 0.1, duration: 0.085))
        }
        if key == 24
        {
            camera!.run(SKAction.scale(to: camera!.xScale + 0.1, duration: 0.085))
        }
        if key == 53
        {
            view!.presentScene(MainMenuScene(size: frame.size))
        }
    }
    
    override func smartMagnify(with event: NSEvent)
    {
        
    }
    
    #endif
}
