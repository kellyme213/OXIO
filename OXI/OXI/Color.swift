//
//  Color.swift
//  OXIO
//
//  Created by Michael Kelly on 9/15/16.
//  Copyright © 2016 Michael Kelly. All rights reserved.
//

import Foundation
import SpriteKit

class Color
{
    static var numOfColumns = 9
    static var numOfRows = 12
    static var shapeSize = CGFloat(0)
    static var isPhone = false
    
    #if os(iOS)
    
    static let circleImage = (UIImage(named: "circle"))!
    
    static let clear  = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
    
    static let lightR = UIImage(named: "lightRed")!.getPixelColor()
    static let lightO = UIImage(named: "lightOrange")!.getPixelColor()
    static let lightY = UIImage(named: "lightYellow")!.getPixelColor()
    static let lightG = UIImage(named: "lightGreen")!.getPixelColor()
    static let lightB = UIImage(named: "lightBlue")!.getPixelColor()
    static let lightP = UIImage(named: "lightPurple")!.getPixelColor()
    static let lightW = UIImage(named: "lightWhite")!.getPixelColor()
    
    static let red    = UIImage(named: "red")!.getPixelColor()
    static let orange = UIImage(named: "orange")!.getPixelColor()
    static let yellow = UIImage(named: "yellow")!.getPixelColor()
    static let green  = UIImage(named: "green")!.getPixelColor()
    static let blue   = UIImage(named: "blue")!.getPixelColor()
    static let purple = UIImage(named: "purple")!.getPixelColor()
    static let cream  = UIImage(named: "cream")!.getPixelColor()
    static let black  = UIImage(named: "black")!.getPixelColor()
    static let white  = UIImage(named: "white")!.getPixelColor()
    static let gray   = UIImage(named: "gray")!.getPixelColor()
    
    #else
    
    static let circleImage = (NSImage(named: "circle"))!
    
    static let clear  = NSColor(red: 1, green: 1, blue: 1, alpha: 0)
    
    static let lightR = NSImage(named: "lightRed")!.getPixelColor()
    static let lightO = NSImage(named: "lightOrange")!.getPixelColor()
    static let lightY = NSImage(named: "lightYellow")!.getPixelColor()
    static let lightG = NSImage(named: "lightGreen")!.getPixelColor()
    static let lightB = NSImage(named: "lightBlue")!.getPixelColor()
    static let lightP = NSImage(named: "lightPurple")!.getPixelColor()
    static let lightW = NSImage(named: "lightWhite")!.getPixelColor()
    
    static let red    = NSImage(named: "red")!.getPixelColor()
    static let orange = NSImage(named: "orange")!.getPixelColor()
    static let yellow = NSImage(named: "yellow")!.getPixelColor()
    static let green  = NSImage(named: "green")!.getPixelColor()
    static let blue   = NSImage(named: "blue")!.getPixelColor()
    static let purple = NSImage(named: "purple")!.getPixelColor()
    static let cream  = NSImage(named: "cream")!.getPixelColor()
    static let black  = NSImage(named: "black")!.getPixelColor()
    static let white  = NSImage(named: "white")!.getPixelColor()
    static let gray   = NSImage(named: "gray")!.getPixelColor()
    
    #endif
    
    static let textureR = SKTexture(imageNamed: "lightRed")
    static let textureO = SKTexture(imageNamed: "lightOrange")
    static let textureY = SKTexture(imageNamed: "lightYellow")
    static let textureG = SKTexture(imageNamed: "lightGreen")
    static let textureB = SKTexture(imageNamed: "lightBlue")
    static let textureP = SKTexture(imageNamed: "lightPurple")
    static let textureW = SKTexture(imageNamed: "lightWhite")
    static let whtTextr = SKTexture(imageNamed: "white")
    static let blockTexture = SKTexture(imageNamed: "blockTexture")
    static let triangleTexture = SKTexture(imageNamed: "triangleTexture")
    static let starTexture = SKTexture(imageNamed: "starFilled")
    static let starEmptyTexture = SKTexture(imageNamed: "starUnilled")
    
    static let blockRed = SKTexture(imageNamed: "blockRed")
    static let blockOra = SKTexture(imageNamed: "blockOrange")
    static let blockYel = SKTexture(imageNamed: "blockYellow")
    static let blockGre = SKTexture(imageNamed: "blockGreen")
    static let blockBlu = SKTexture(imageNamed: "blockBlue")
    static let blockPur = SKTexture(imageNamed: "blockPurple")
    static let blockWhi = SKTexture(imageNamed: "blockWhite")
    
    static let textureRdark = SKTexture(imageNamed: "red")
    static let textureOdark = SKTexture(imageNamed: "orange")
    static let textureYdark = SKTexture(imageNamed: "yellow")
    static let textureGdark = SKTexture(imageNamed: "green")
    static let textureBdark = SKTexture(imageNamed: "blue")
    static let texturePdark = SKTexture(imageNamed: "purple")
    
    static let RO = red + orange
    static let OY = orange + yellow
    static let YG = yellow + green
    static let GB = green + blue
    static let BP = blue + purple
    static let PW = purple + white
    static let WR = white + red
    static let PR = purple + red
    
    static func getTextureFromWeight(_ w: Int) -> SKTexture
    {
        if (w == 1)
        {
            return textureR
        }
        else if (w == 2)
        {
            return textureO
        }
        else if (w == 3)
        {
            return textureY
        }
        else if (w == -1)
        {
            return textureG
        }
        else if (w == -2)
        {
            return textureB
        }
        else if (w == -3)
        {
            return textureP
        }
        else if (w == 0)
        {
            return textureW
        }
        
        return Color.textureW
    }
    
    static func getDarkTextureFromWeight(_ w: Int) -> SKTexture
    {
        if (w == 1)
        {
            return textureRdark
        }
        else if (w == 2)
        {
            return textureOdark
        }
        else if (w == 3)
        {
            return textureYdark
        }
        else if (w == -1)
        {
            return textureGdark
        }
        else if (w == -2)
        {
            return textureBdark
        }
        else if (w == -3)
        {
            return texturePdark
        }
        else if (w == 0)
        {
            return whtTextr
        }
        
        return whtTextr
    }
    
    static func getBlockTextureFromWeight(_ w: Int) -> SKTexture
    {
        if (w == 1)
        {
            return blockRed
        }
        else if (w == 2)
        {
            return blockOra
        }
        else if (w == 3)
        {
            return blockYel
        }
        else if (w == -1)
        {
            return blockGre
        }
        else if (w == -2)
        {
            return blockBlu
        }
        else if (w == -3)
        {
            return blockPur
        }
        else if (w == 0)
        {
            return blockWhi
        }
        
        return blockWhi
    }

    
    static func getTypeFromWeight(_ w: Int) -> Int
    {
        if (w == 1)
        {
            return 1
        }
        else if (w == 2)
        {
            return 2
        }
        else if (w == 3)
        {
            return 3
        }
        else if (w == -1)
        {
            return 4
        }
        else if (w == -2)
        {
            return 5
        }
        else if (w == -3)
        {
            return 6
        }
        else if (w == 0)
        {
            return 7
        }
        
        return 7
    }
    
    static func getWeightFromType(_ t: Int) -> Int
    {
        if (t == 1)
        {
            return 1
        }
        else if (t == 2)
        {
            return 2
        }
        else if (t == 3)
        {
            return 3
        }
        else if (t == 4)
        {
            return -1
        }
        else if (t == 5)
        {
            return -2
        }
        else if (t == 6)
        {
            return -3
        }
        else if (t == 7)
        {
            return 0
        }
        
        return 0
    }
    
    
    #if os(iOS)
    
    static func getDarkColorFromWeight(_ w: Int) -> UIColor
    {
        if (w == 1)
        {
            return red
        }
        else if (w == 2)
        {
            return orange
        }
        else if (w == 3)
        {
            return yellow
        }
        else if (w == -1)
        {
            return green
        }
        else if (w == -2)
        {
            return blue
        }
        else if (w == -3)
        {
            return purple
        }
        else if (w == 0)
        {
            return white
        }
        
        return black
    }
    
    static func getLightColorFromWeight(_ w: Int) -> UIColor
    {
        if (w == 1)
        {
            return lightR
        }
        else if (w == 2)
        {
            return lightO
        }
        else if (w == 3)
        {
            return lightY
        }
        else if (w == -1)
        {
            return lightG
        }
        else if (w == -2)
        {
            return lightB
        }
        else if (w == -3)
        {
            return lightP
        }
        else if (w == 0)
        {
            return lightW
        }
        
        return lightW
    }
    
    static func generatePath(array: [CGPoint]) -> UIBezierPath
    {
        let path = UIBezierPath()
    
        path.move(to: array.first!)
        
        for x in 1..<array.count
        {
            path.addLine(to: array[x])
        }
        
        return path
    }
    
    #else
    
    static func getDarkColorFromWeight(_ w: Int) -> NSColor
    {
        if (w == 1)
        {
            return red
        }
        else if (w == 2)
        {
            return orange
        }
        else if (w == 3)
        {
            return yellow
        }
        else if (w == -1)
        {
            return green
        }
        else if (w == -2)
        {
            return blue
        }
        else if (w == -3)
        {
            return purple
        }
        else if (w == 0)
        {
            return white
        }
        
        return black
    }
    
    static func getLightColorFromWeight(_ w: Int) -> NSColor
    {
        if (w == 1)
        {
            return lightR
        }
        else if (w == 2)
        {
            return lightO
        }
        else if (w == 3)
        {
            return lightY
        }
        else if (w == -1)
        {
            return lightG
        }
        else if (w == -2)
        {
            return lightB
        }
        else if (w == -3)
        {
            return lightP
        }
        else if (w == 0)
        {
            return lightW
        }
        
        return lightW
    }
    
    static func generatePath(array: [CGPoint]) -> NSBezierPath
    {
        let path = NSBezierPath()
    
        path.move(to: array.first!)
    
        for x in 1..<array.count
        {
            path.line(to: array[x])
        }
    
        return path
    }
    
    #endif
    
    static func getFile(_ str: String, _ b: Bool) -> String
    {
        var path: String?
        
        if b
        {
            let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true)[0] as NSString
            let destinationPath = documentDirectoryPath.appendingPathComponent("Files/Programs/Swift/OXI/OXI/Files/" + str + ".txt")
            path = destinationPath
        }
        else
        {
            path = Bundle.main.path(forResource: "Files/" + str, ofType: "txt")
        }
        
        if path == nil
        {
            fatalError(str + " IS INVALID")
        }
        
        let file = try? String(contentsOfFile: path!)
        
        if file == nil
        {
            fatalError(str + " DOES NOT EXIST")
        }
        
        return file!
    }
    
    static func getLevel() -> String
    {
        var path: String?
        
        #if os(iOS)
            let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] as NSString
            let destinationPath = documentDirectoryPath.appendingPathComponent("Level.txt")
            path = destinationPath
        #else
            path = Bundle.main.path(forResource: "Files/Level.txt", ofType: "")
        #endif
            
        if path == nil
        {
            fatalError("IS INVALID")
        }
        
        let file = try? String(contentsOfFile: path!)
        
        if file == nil
        {
            fatalError("DOES NOT EXIST")
        }
        
        return file!
    }
    
    static func getVersion() -> String
    {
        let path = Bundle.main.path(forResource: "Files/Version.txt", ofType: "")
        
        let file = try? String(contentsOfFile: path!)
        
        if file == nil
        {
            fatalError("DOES NOT EXIST")
        }
        
        return file!
    }
    
    static func writeLevel(section: Int, level: Int)
    {
        let a = getLevel().components(separatedBy: "\n")[0].components(separatedBy: ".")
        
        let s = Int(a[0])!
        let l = Int(a[1])!
        
        if s <= section || (s == section && l < level)
        {
            var path: String?
            
            #if os(iOS)
                let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] as NSString
                let destinationPath = documentDirectoryPath.appendingPathComponent("Level.txt")
                path = destinationPath
            #else
                path = Bundle.main.path(forResource: "Files/Level.txt", ofType: "")
            #endif
            
            
            if path == nil
            {
                return
            }
            
            let str = section + "." + level
            
            try? str.write(toFile: path!, atomically: true, encoding: .utf8)            
        }
    }
    
    static func contains(_ str: String) -> Bool
    {
        let path = Bundle.main.path(forResource: "Files/" + str + "/Block", ofType: "txt")
        
        return path != nil
    }
    
    static func writeFile(_ str: String, _ blockString: String, _ boxString: String, _ lineString: String, _ triangleString: String, _ pathString: String) -> Bool
    {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true)[0] as NSString
        let destinationPath1 = documentDirectoryPath.appendingPathComponent("Files/Programs/Swift/OXI/OXI/Files/Level" + str + "/Block.txt")
        let destinationPath2 = documentDirectoryPath.appendingPathComponent("Files/Programs/Swift/OXI/OXI/Files/Level" + str + "/Box.txt")
        let destinationPath3 = documentDirectoryPath.appendingPathComponent("Files/Programs/Swift/OXI/OXI/Files/Level" + str + "/Line.txt")
        let destinationPath4 = documentDirectoryPath.appendingPathComponent("Files/Programs/Swift/OXI/OXI/Files/Level" + str + "/Triangle.txt")
        let destinationPath5 = documentDirectoryPath.appendingPathComponent("Files/Programs/Swift/OXI/OXI/Files/Level" + str + "/Path.txt")
        
        let path1 = destinationPath1
        let path2 = destinationPath2
        let path3 = destinationPath3
        let path4 = destinationPath4
        let path5 = destinationPath5
        
        let fileManager = FileManager()
        
        if !fileManager.fileExists(atPath: path1)
        {
            let path = documentDirectoryPath.appendingPathComponent("Files/Programs/Swift/OXI/OXI/Files/Level" + str + "/")
            try? fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            fileManager.createFile(atPath: path1, contents: nil, attributes: nil)
            fileManager.createFile(atPath: path2, contents: nil, attributes: nil)
            fileManager.createFile(atPath: path3, contents: nil, attributes: nil)
            fileManager.createFile(atPath: path4, contents: nil, attributes: nil)
            fileManager.createFile(atPath: path5, contents: nil, attributes: nil)
        }
        
        if !fileManager.fileExists(atPath: path5)
        {
            fileManager.createFile(atPath: path5, contents: nil, attributes: nil)
        }
        do
        {
            try blockString.write(toFile: path1, atomically: false, encoding: String.Encoding.utf8)
            try boxString.write(toFile: path2, atomically: false, encoding: String.Encoding.utf8)
            try lineString.write(toFile: path3, atomically: false, encoding: String.Encoding.utf8)
            try triangleString.write(toFile: path4, atomically: false, encoding: String.Encoding.utf8)
            try pathString.write(toFile: path5, atomically: false, encoding: String.Encoding.utf8)

            return true
        }
        catch
        {
            return false
        }
    }
    
    static func lineIntersectsBox(_ goalPoint: CGPoint, endPoint: CGPoint, blockPoint: CGPoint, blockSize: CGSize) -> Bool
    {
        let point1 = CGPoint(x: blockPoint.x + blockSize.width / 2, y: blockPoint.y + blockSize.height / 2 + 0.01)
        let point2 = CGPoint(x: blockPoint.x - blockSize.width / 2 - 0.01, y: blockPoint.y + blockSize.height / 2)
        let point3 = CGPoint(x: blockPoint.x - blockSize.width / 2, y: blockPoint.y - blockSize.height / 2 - 0.01)
        let point4 = CGPoint(x: blockPoint.x + blockSize.width / 2 + 0.01, y: blockPoint.y - blockSize.height / 2)
        
        if linesIntersect(point1, p2: point2, p3: goalPoint, p4: endPoint)
        {
            return true
        }
        if linesIntersect(point2, p2: point3, p3: goalPoint, p4: endPoint)
        {
            return true
        }
        if linesIntersect(point3, p2: point4, p3: goalPoint, p4: endPoint)
        {
            return true
        }
        if linesIntersect(point4, p2: point1, p3: goalPoint, p4: endPoint)
        {
            return true
        }
        
        return false
    }
    
    static func linesIntersect(_ p1: CGPoint, p2: CGPoint, p3: CGPoint, p4: CGPoint) -> Bool
    {
        let p1x1 = p1.x
        let p1y1 = p1.y
        let p1x2 = p2.x
        let p1y2 = p2.y
        
        let p2x1 = p3.x
        let p2y1 = p3.y
        let p2x2 = p4.x
        let p2y2 = p4.y
        var m1 = CGFloat(0)
        var m2 = CGFloat(0)
        
        let dy1 = p1y2 - p1y1
        let dx1 = p1x2 - p1x1
        let dy2 = p2y2 - p2y1
        let dx2 = p2x2 - p2x1
        
        if (dy1 == 0 || dy2 == 0)
        {
            if (dy1 == 0 && dy2 == 0)
            {
                if (p1y1 != p2y1)
                {
                    return false
                }
                return inRange(p1y1, num2: p1y2, num3: p2y1) || inRange(p1y1, num2: p1y2, num3: p2y2)
            }
            else if (dy1 == 0)
            {
                m1 = 0
                m2 = dy2 / dx2
                
                let b1 = p1y1 - (m1 * p1x1)
                let b2 = p2y1 - (m2 * p2x1)
                
                let x = (b2 - b1) / (m1 - m2)
                let y = (m1 * x) + b1
                
                let b = inRange(p1y1, num2: p1y2, num3: y) && inRange(p1x1, num2: p1x2, num3: x) && inRange(p2x1, num2: p2x2, num3: x) && inRange(p2y1, num2: p2y2, num3: y)
                return b
            }
            else if (dy2 == 0)
            {
                m1 = dy1 / dx1
                m2 = 0
                
                let b1 = p1y1 - (m1 * p1x1)
                let b2 = p2y1 - (m2 * p2x1)
                
                let x = (b2 - b1) / (m1 - m2)
                let y = (m1 * x) + b1
                
                let b = inRange(p1y1, num2: p1y2, num3: y) && inRange(p1x1, num2: p1x2, num3: x) && inRange(p2x1, num2: p2x2, num3: x) && inRange(p2y1, num2: p2y2, num3: y)
                return b
            }
        }
        else if (dx1 == 0 || dx2 == 0)
        {
            if (dx1 == 0 && dx2 == 0)
            {
                if (p1x1 != p2x1)
                {
                    return false
                }
                return inRange(p1x1, num2: p1x2, num3: p2x1) || inRange(p1x1, num2: p1x2, num3: p2x2)
            }
            else if (dx1 == 0)
            {
                m1 = 0
                m2 = dy2 / dx2
                
                let b2 = p2y1 - (m2 * p2x1)
                
                let x = p1x1
                let y = (m2 * x) + b2
                
                let b = inRange(p1y1, num2: p1y2, num3: y) && inRange(p1x1, num2: p1x2, num3: x) && inRange(p2x1, num2: p2x2, num3: x) && inRange(p2y1, num2: p2y2, num3: y)
                return b
                
            }
            else if (dx2 == 0)
            {
                m1 = dy1 / dx1
                m2 = 0
                
                let b1 = p1y1 - (m1 * p1x1)
                
                let x = p2x1
                let y = (m1 * x) + b1
                
                let b = inRange(p1y1, num2: p1y2, num3: y) && inRange(p1x1, num2: p1x2, num3: x) && inRange(p2x1, num2: p2x2, num3: x) && inRange(p2y1, num2: p2y2, num3: y)
                return b
            }
        }
        else
        {
            m1 = dy1 / dx1
            m2 = dy2 / dx2
            
            let b1 = p1y1 - (m1 * p1x1)
            let b2 = p2y1 - (m2 * p2x1)
            
            if (m1 == m2)
            {
                return (b1 == b2)
            }
            
            let x = (b2 - b1) / (m1 - m2)
            let y = (m1 * x) + b1
            
            let b = inRange(p1y1, num2: p1y2, num3: y) && inRange(p1x1, num2: p1x2, num3: x) && inRange(p2x1, num2: p2x2, num3: x) && inRange(p2y1, num2: p2y2, num3: y)
            return b
        }
        
        return false
    }
    
    static func inRange(_ num1: CGFloat, num2: CGFloat, num3: CGFloat) -> Bool
    {
        if (num3.isNaN || num3.isInfinite)
        {
            return false
        }
        
        let tolerance = CGFloat(0.0)
        var highest: CGFloat
        var lowest: CGFloat
        
        if (num1 > num2)
        {
            highest = num1
            lowest = num2
        }
        else
        {
            lowest = num1
            highest = num2
        }
        
        return (num3 <= highest + tolerance && num3 >= lowest - tolerance)
    }
    
    static func distanceBetween(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat
    {
        let x = pow(p2.x - p1.x, 2.0)
        let y = pow(p2.y - p1.y, 2.0)
        return pow(x + y, 0.5)
    }
}

/*
 static let cream  = UIColor(red: 239 / 255, green: 228 / 255, blue: 176 / 255, alpha: 1)
 static let red    = UIColor(red: 251 / 255, green: 008 / 255, blue: 006 / 255, alpha: 1)
 static let orange = UIColor(red: 252 / 255, green: 101 / 255, blue: 008 / 255, alpha: 1)
 static let yellow = UIColor(red: 255 / 255, green: 255 / 255, blue: 000 / 255, alpha: 1)
 static let green  = UIColor(red: 028 / 255, green: 212 / 255, blue: 004 / 255, alpha: 1)
 static let blue   = UIColor(red: 000 / 255, green: 075 / 255, blue: 255 / 255, alpha: 1)
 static let purple = UIColor(red: 135 / 255, green: 000 / 255, blue: 137 / 255, alpha: 1)
 static let white  = UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1)
 static let black  = UIColor(red: 000 / 255, green: 000 / 255, blue: 000 / 255, alpha: 1)
 
 static let lightR = UIColor(red: 255 / 255, green: 149 / 255, blue: 149 / 255, alpha: 1)
 static let lightO = UIColor(red: 255 / 255, green: 179 / 255, blue: 108 / 255, alpha: 1)
 static let lightY = UIColor(red: 252 / 255, green: 255 / 255, blue: 164 / 255, alpha: 1)
 static let lightG = UIColor(red: 128 / 255, green: 255 / 255, blue: 128 / 255, alpha: 1)
 static let lightB = UIColor(red: 136 / 255, green: 159 / 255, blue: 255 / 255, alpha: 1)
 static let lightP = UIColor(red: 255 / 255, green: 130 / 255, blue: 255 / 255, alpha: 1)
 static let lightW = UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1)
 */
