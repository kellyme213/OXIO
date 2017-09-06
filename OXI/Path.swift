//
//  Path.swift
//  OXIO
//
//  Created by Michael Kelly on 3/5/17.
//  Copyright © 2017 Michael Kelly. All rights reserved.
//

import Foundation
import SpriteKit

class Path
{
    var id = 0
    var points = [CGPoint]()
    var times = [Double]()
    var repeats = false
    var moving = false
    var string = ""
    var waitTime = 0.0

    init(str: String)
    {
        string = str
        
        let strArray = str.components(separatedBy: "\n")
        
        let newArray = strArray[0].components(separatedBy: ",")
        
        id = Int(newArray[0])!
        
        repeats = newArray[1] == "1"
        
        waitTime = Double(newArray[2])!
        
        let scale = Color.shapeSize -/ 20
        
        
        for x in 1 ..< strArray.count
        {
            let array = strArray[x].components(separatedBy: ",")
            
            if array[0] == ""
            {
                continue
            }
            
            let point = scale * CGPoint(x: Int(array[0])!, y: Int(array[1])!)
            let time = Double(array[2])!
            points.append(point)
            times.append(time)
        }
    }
    
    func runPath(node: SKNode)
    {
        var actions = [SKAction]()
        
        for x in 0 ..< points.count
        {
            let action = SKAction.move(to: points[x], duration: times[x])
            actions.append(action)
        }
        
        if repeats
        {
            node.run(SKAction.sequence([SKAction.wait(forDuration: waitTime), SKAction.repeatForever(SKAction.sequence(actions))]))
            moving = true
        }
        else
        {
            actions.append(SKAction.wait(forDuration: waitTime))
            
            let action = SKAction.run({self.moving = false})
            actions.append(action)
            
            let finalAction = SKAction.sequence(actions)
            node.run(finalAction, withKey: "PathAction")            
        }
    }
    
    func toString() -> String
    {
        return string
    }
}


