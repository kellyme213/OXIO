//
//  Extensions.swift
//  OXIO
//
//  Created by Michael Kelly on 2/10/17.
//  Copyright © 2017 Michael Kelly. All rights reserved.
//

import Foundation
import SpriteKit

infix operator -* : MultiplicationPrecedence
infix operator *- : MultiplicationPrecedence
infix operator -/ : MultiplicationPrecedence
infix operator /- : MultiplicationPrecedence

#if os(iOS)
    
    extension UIImage
    {
        func getPixelColor() -> UIColor
        {
            let point = CGPoint(x: 0, y: self.size.height / 2)
            let pixelData = self.cgImage!.dataProvider!.data
            let pixelArray: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
            
            let counter = 4 * (Int(self.size.width) * Int(point.y) + Int(point.x))
            
            let red = CGFloat(pixelArray[counter]) / 255
            let green = CGFloat(pixelArray[counter + 1]) / 255
            let blue = CGFloat(pixelArray[counter + 2]) / 255
            let alpha = CGFloat(pixelArray[counter + 3]) / 255
            
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
    
#else
    
    extension NSImage
    {
        func getPixelColor() -> NSColor
        {
            let point = CGPoint(x: 0, y: self.size.height / 2)
            let pixelData = self.tiffRepresentation
            let pixelArray: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData as CFData!)
            
            let counter = 4 * (Int(self.size.width) * Int(point.y) + Int(point.x))
            
            let red = CGFloat(pixelArray[counter]) / 255
            let green = CGFloat(pixelArray[counter + 1]) / 255
            let blue = CGFloat(pixelArray[counter + 2]) / 255
            let alpha = CGFloat(pixelArray[counter + 3]) / 255
            
            return NSColor(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
    
#endif

extension SKSpriteNode
{
    func popIn()
    {
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        self.scale(to: CGSize(width: width / 8, height: height / 8))
        
        let a1 = SKAction.scale(by: 12.0, duration: 0.15)
        let a2 = SKAction.scale(by: 8.0 / 12.0, duration: 0.1)
        
        self.run(SKAction.sequence([a1, a2]))
    }
    
    func popOut()
    {
        let a1 = SKAction.scale(by: 12.0 / 8.0, duration: 0.15)
        let a2 = SKAction.scale(by: 1.0 / 12.0, duration: 0.1)
        let a3 = SKAction.removeFromParent()
        
        self.run(SKAction.sequence([a1, a2, a3]))
    }
}

extension SKScene
{
    func moveCamera(_ p: CGPoint)
    {
        camera!.position = p//CGPoint(x: p.x / camera!.xScale, y: p.y / camera!.yScale)
    }
    
    func getInitialCameraPoint() -> CGPoint
    {
        return camera!.position
    }
    
    func getInitialCameraScale() -> CGFloat
    {
        return camera!.xScale
    }
    
    func scaleCamera(_ s: CGFloat)
    {
        camera!.xScale = s
        camera!.yScale = s
    }
    
    func stopCameraMovement()
    {
        
    }
    
    override open func addChild(_ node: SKNode)
    {
        if (!self.children.contains(node))
        {
            super.addChild(node)
        }
        else
        {
            print(node)
            print("ALREADY ON SCENE")
        }
    }
}

extension CGPoint
{
    static func + (left: CGPoint, right: CGPoint) -> CGPoint
    {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func - (left: CGPoint, right: CGPoint) -> CGPoint
    {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static func * (left: CGPoint, right: CGPoint) -> CGPoint
    {
        return CGPoint(x: left.x * right.x, y: left.y * right.y)
    }
    
    static func / (left: CGPoint, right: CGPoint) -> CGPoint
    {
        return CGPoint(x: left.x / right.x, y: left.y / right.y)
    }
    
    static func * (left: CGFloat, right: CGPoint) -> CGPoint
    {
        return CGPoint(x: left *- right.x, y: left *- right.y)
    }
    
    static func / (left: CGFloat, right: CGPoint) -> CGPoint
    {
        return CGPoint(x: left /- right.x, y: left /- right.y)
    }
    
    static func * (left: CGPoint, right: CGFloat) -> CGPoint
    {
        return CGPoint(x: left.x -* right, y: left.y -* right)
    }
    
    static func / (left: CGPoint, right: CGFloat) -> CGPoint
    {
        return CGPoint(x: left.x -/ right, y: left.y -/ right)
    }
    
    static func * (left: Double, right: CGPoint) -> CGPoint
    {
        return CGPoint(x: left *- right.x, y: left *- right.y)
    }
    
    static func / (left: Double, right: CGPoint) -> CGPoint
    {
        return CGPoint(x: left /- right.x, y: left /- right.y)
    }
    
    static func * (left: CGPoint, right: Double) -> CGPoint
    {
        return CGPoint(x: left.x -* right, y: left.y -* right)
    }
    
    static func / (left: CGPoint, right: Double) -> CGPoint
    {
        return CGPoint(x: left.x -/ right, y: left.y -/ right)
    }
    
    static func * (left: Int, right: CGPoint) -> CGPoint
    {
        return CGPoint(x: left *- right.x, y: left *- right.y)
    }
    
    static func / (left: Int, right: CGPoint) -> CGPoint
    {
        return CGPoint(x: left /- right.x, y: left /- right.y)
    }
    
    static func * (left: CGPoint, right: Int) -> CGPoint
    {
        return CGPoint(x: left.x -* right, y: left.y -* right)
    }
    
    static func / (left: CGPoint, right: Int) -> CGPoint
    {
        return CGPoint(x: left.x -/ right, y: left.y -/ right)
    }
    
    static func * (left: CGRect, right: CGPoint) -> CGPoint
    {
        return CGPoint(x: left.width * right.x, y: left.height * right.y)
    }
    
    static func * (left: CGSize, right: CGPoint) -> CGPoint
    {
        return CGPoint(x: left.width * right.x, y: left.height * right.y)
    }
}

#if os(macOS)
    
    extension NSBezierPath
    {
        public var cgPath: CGPath
        {
            let path = CGMutablePath()
            var points = [CGPoint](repeating: .zero, count: 3)
            
            for i in 0 ..< self.elementCount
            {
                let type = self.element(at: i, associatedPoints: &points)
                switch type
                {
                case .moveToBezierPathElement:
                    path.move(to: points[0])
                case .lineToBezierPathElement:
                    path.addLine(to: points[0])
                case .curveToBezierPathElement:
                    path.addCurve(to: points[2], control1: points[0], control2: points[1])
                case .closePathBezierPathElement:
                    path.closeSubpath()
                }
            }
            return path
        }
    }
    
    extension SKView
    {
        override open func magnify(with event: NSEvent)
        {
            self.scene!.magnify(with: event)
        }
        
        override open func mouseMoved(with event: NSEvent) {
            self.scene!.mouseMoved(with: event)
        }
        
        override open func smartMagnify(with event: NSEvent) {
            self.scene!.smartMagnify(with: event)
        }
    }
    
#endif

#if os(macOS)
    
    extension NSColor
    {
        static func + (left: NSColor, right: NSColor) -> NSColor
        {
            return NSColor(red: (left.redComponent + right.redComponent) / 2, green: (left.greenComponent + right.greenComponent) / 2, blue: (left.blueComponent + right.blueComponent) / 2, alpha: 0.1)
        }
    }
    
#else
    
    extension UIColor
    {
        static func + (left: UIColor, right: UIColor) -> UIColor
        {
            return UIColor(red: (left.ciColor.red + right.ciColor.red) / 2, green: (left.ciColor.green + right.ciColor.green) / 2, blue: (left.ciColor.blue + right.ciColor.blue) / 2, alpha: 1)
        }
    }
    
#endif

extension SKNode
{
    func containsTouchPoint(_ point: CGPoint) -> Bool
    {
        let a = self.scene?.children.contains(self)
        let b = contains(point)
        return (a != nil) && a! && b
    }
}

extension Int
{
    static func -* (left: Int, right: CGFloat) -> Int
    {
        return left * Int(right)
    }
    
    static func -* (left: CGFloat, right: Int) -> CGFloat
    {
        return left * CGFloat(right)
    }
    
    static func *- (left: Int, right: CGFloat) -> CGFloat
    {
        return CGFloat(left) * right
    }
    
    static func *- (left: CGFloat, right: Int) -> Int
    {
        return Int(left) * right
    }
    
    static func -/ (left: Int, right: CGFloat) -> Int
    {
        return left / Int(right)
    }
    
    static func -/ (left: CGFloat, right: Int) -> CGFloat
    {
        return left / CGFloat(right)
    }
    
    static func /- (left: Int, right: CGFloat) -> CGFloat
    {
        return CGFloat(left) / right
    }
    
    static func /- (left: CGFloat, right: Int) -> Int
    {
        return Int(left) / right
    }
    
    static func *- (left: Int, right: Int) -> Int
    {
        return left * right
    }
    
    static func -* (left: Int, right: Int) -> Int
    {
        return left * right
    }
    
    static func /- (left: Int, right: Int) -> Int
    {
        return left / right
    }
    
    static func -/ (left: Int, right: Int) -> Int
    {
        return left / right
    }
    
    static func * (left: CGFloat, right: Int) -> CGFloat
    {
        return left -* right
    }
    
    static func * (left: Int, right: CGFloat) -> Int
    {
        return left -* right
    }
    
    static func / (left: CGFloat, right: Int) -> CGFloat
    {
        return left -/ right
    }
    
    static func / (left: Int, right: CGFloat) -> Int
    {
        return left -/ right
    }
}

extension Double
{
    static func -* (left: Double, right: Int) -> Double
    {
        return left * Double(right)
    }
    
    static func -* (left: Int, right: Double) -> Int
    {
        return left * Int(right)
    }
    
    static func *- (left: Double, right: Int) -> Int
    {
        return Int(left) * right
    }
    
    static func *- (left: Int, right: Double) -> Double
    {
        return Double(left) * right
    }
    
    static func -/ (left: Double, right: Int) -> Double
    {
        return left / Double(right)
    }
    
    static func -/ (left: Int, right: Double) -> Int
    {
        return left / Int(right)
    }
    
    static func /- (left: Double, right: Int) -> Int
    {
        return Int(left) / right
    }
    
    static func /- (left: Int, right: Double) -> Double
    {
        return Double(left) / right
    }
    
    static func *- (left: Double, right: Double) -> Double
    {
        return left * right
    }
    
    static func -* (left: Double, right: Double) -> Double
    {
        return left * right
    }
    
    static func /- (left: Double, right: Double) -> Double
    {
        return left / right
    }
    
    static func -/ (left: Double, right: Double) -> Double
    {
        return left / right
    }
    
    static func * (left: Double, right: Int) -> Double
    {
        return left -* right
    }
    
    static func * (left: Int, right: Double) -> Int
    {
        return left -* right
    }
    
    static func / (left: Double, right: Int) -> Double
    {
        return left -/ right
    }
    
    static func / (left: Int, right: Double) -> Int
    {
        return left -/ right
    }
    
    func asRadian() -> Double
    {
        return self -* Double.pi -/ 180
    }
    
    func asDegree() -> Double
    {
        return self -* 180 *- Double.pi
    }
}


extension CGFloat
{
    static func -* (left: Double, right: CGFloat) -> Double
    {
        return left * Double(right)
    }
    
    static func -* (left: CGFloat, right: Double) -> CGFloat
    {
        return left * CGFloat(right)
    }
    
    static func *- (left: Double, right: CGFloat) -> CGFloat
    {
        return CGFloat(left) * right
    }
    
    static func *- (left: CGFloat, right: Double) -> Double
    {
        return Double(left) * right
    }
    
    static func -/ (left: Double, right: CGFloat) -> Double
    {
        return left / Double(right)
    }
    
    static func -/ (left: CGFloat, right: Double) -> CGFloat
    {
        return left / CGFloat(right)
    }
    
    static func /- (left: Double, right: CGFloat) -> CGFloat
    {
        return CGFloat(left) / right
    }
    
    static func /- (left: CGFloat, right: Double) -> Double
    {
        return Double(left) / right
    }
    
    static func *- (left: CGFloat, right: CGFloat) -> CGFloat
    {
        return left * right
    }
    
    static func -* (left: CGFloat, right: CGFloat) -> CGFloat
    {
        return left * right
    }
    
    static func /- (left: CGFloat, right: CGFloat) -> CGFloat
    {
        return left / right
    }
    
    static func -/ (left: CGFloat, right: CGFloat) -> CGFloat
    {
        return left / right
    }
    
    static func * (left: CGFloat, right: Double) -> CGFloat
    {
        return left -* right
    }
    
    static func * (left: Double, right: CGFloat) -> Double
    {
        return left -* right
    }
    
    static func / (left: CGFloat, right: Double) -> CGFloat
    {
        return left -/ right
    }
    
    static func / (left: Double, right: CGFloat) -> Double
    {
        return left -/ right
    }
    
    static func * (left: CGFloat, right: CGSize) -> CGSize
    {
        return CGSize(width: left * right.width, height: left * right.height)
    }
    
    func asRadian() -> CGFloat
    {
        return self -* CGFloat.pi -/ 180
    }
    
    func asDegree() -> CGFloat
    {
        return self -* 180 /- CGFloat.pi
    }
}

extension SKLabelNode
{
    convenience init(text: String)
    {
        self.init()
        self.fontName = "Avenir"
        self.fontColor = Color.black
        self.text = text
    }
}

extension CGSize
{
    init(square: CGFloat)
    {
        self.init(width: square, height: square)
    }
}

extension String
{
    static func + (left: String, right: Int) -> String
    {
        return left + right.description
    }
    
    static func + (left: Int, right: String) -> String
    {
        return left.description + right
    }
}











