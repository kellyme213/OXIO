//
//  WindowController.swift
//  OXIO
//
//  Created by Michael Kelly on 2/12/17.
//  Copyright © 2017 Michael Kelly. All rights reserved.
//

import Foundation
import Cocoa

class DebugController: NSViewController
{
    @IBOutlet var xText: NSTextField!
    @IBOutlet var yText: NSTextField!
    @IBOutlet var wText: NSTextField!
    @IBOutlet var iText: NSTextField!
    
    @IBOutlet var widthText: NSTextField!
    @IBOutlet var heightText: NSTextField!
    @IBOutlet var typeText: NSTextField!
    
    @IBOutlet var fileText: NSTextField!
    
    @IBOutlet var x1Text: NSTextField!
    @IBOutlet var x2Text: NSTextField!
    @IBOutlet var y1Text: NSTextField!
    @IBOutlet var y2Text: NSTextField!
    
    @IBOutlet var picker: NSButton!
    
    let controller = (NSApplication.shared().windows[0].contentViewController as! GameViewController)
    
    var debugMode = false
    var endEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func toggleDebug(check: NSButton)
    {
        if (controller.skView.scene! is GameScene)
        {
            let scene = (controller.skView.scene! as! GameScene)
            
            if check.title == "ON"
            {
                debugMode = check.state == 1
                scene.debugMode = debugMode
            }
            else
            {
                endEnabled = check.state == 1
                scene.endEnabled = endEnabled
            }
        }
    }
    
    var selectedType = 0
    
    @IBAction func typeSelected(button: NSPopUpButton)
    {
        selectedType = (button.indexOfSelectedItem)
        clear(0)
    }
    
    @IBAction func newObject(button: NSButton)
    {
        if !(controller.skView.scene! is GameScene) || !debugMode
        {
            return
        }
        
        let scene = (controller.skView.scene! as! GameScene)

        if selectedType == 0 //block
        {
            let array = [xText.stringValue, yText.stringValue, wText.stringValue, iText.stringValue]
            
            for a in array
            {
                if a == "" || Int(a) == nil
                {
                    return
                }
            }
            
            scene.createBlock(blockTextValues: array)
        }
        else if selectedType == 1 //bb
        {
            let array = [xText.stringValue, yText.stringValue, widthText.stringValue, heightText.stringValue, wText.stringValue, typeText.stringValue, iText.stringValue]
            
            for a in array
            {
                if a == "" || Int(a) == nil
                {
                    return
                }
            }
            
            scene.createBox(boxTextValues: array)
        }
        else if selectedType == 2 //line
        {
            let array = [x1Text.stringValue, y1Text.stringValue, x2Text.stringValue, y2Text.stringValue, iText.stringValue]
            
            for a in array
            {
                if a == "" || Int(a) == nil
                {
                    return
                }
            }
            
            scene.createLine(lineTextValues: array)
        }
        else if selectedType == 3 //triangle
        {
            let array = [xText.stringValue, yText.stringValue, wText.stringValue, iText.stringValue]
            
            for a in array
            {
                if a == "" || Int(a) == nil
                {
                    return
                }
            }
            
            scene.createTriangle(triangleTextValues: array)
        }
    }
    
    @IBAction func resetLevel(button: NSButton)
    {
        if !(controller.skView.scene! is GameScene) || !debugMode
        {
            return
        }
        
        let scene = (controller.skView.scene! as! GameScene)

        scene.resetLevel()
        
        
    }
    
    @IBAction func importLevel(button: NSButton)
    {
        if !(controller.skView.scene! is GameScene) || !debugMode
        {
            return
        }
        
        if Color.contains("Level" + fileText.stringValue)
        {
            let scene = (controller.skView.scene! as! GameScene)
            
            var textArray = fileText.stringValue.components(separatedBy: ".")
            if fileText.stringValue == "0"
            {
                textArray[0] = "0"
                textArray.append("0")
            }
        
            scene.section = Int(textArray[0])!
            scene.level = Int(textArray[1])!
            scene.generateLevel()
        }
    }
    
    @IBAction func exportLevel(button: NSButton)
    {
        if !(controller.skView.scene! is GameScene) || !debugMode
        {
            return
        }
        
        let scene = (controller.skView.scene! as! GameScene)

        var triangleString = ""
        
        for triangle in scene.triangleArray
        {
            triangleString += triangle.toString() + "\n"
        }
        
        var blockString = ""
        
        for block in scene.blockArray
        {
            blockString += block.toString() + "\n"
        }
        
        var boxString = ""
        
        for box in scene.boundingBoxArray
        {
            boxString += box.toString() + "\n"
        }
        
        var lineString = ""
        
        for line in scene.lineArray
        {
            lineString += line.toString() + "\n"
        }
        
        var pathString = ""
        
        for path in scene.pathArray
        {
            pathString += path.toString() + "\n" + "*" + "\n"
        }
        
        
        if !Color.writeFile(fileText.stringValue, blockString, boxString, lineString, triangleString, pathString)
        {
            print("Level" + fileText.stringValue + " not written. :(")
        }
    }
    
    @IBAction func newLevel(button: NSButton)
    {
        if !(controller.skView.scene! is GameScene) || !debugMode
        {
            return
        }
        
        let scene = (controller.skView.scene! as! GameScene)
        scene.levelCounter = 0
        scene.generateLevel()
        
    }
    
    @IBAction func delete(button: NSButton)
    {
        if !(controller.skView.scene! is GameScene) || !debugMode
        {
            return
        }
        let scene = (controller.skView.scene! as! GameScene)
        scene.delete()
    }
    
    @IBAction func update(button: NSButton)
    {
        if !(controller.skView.scene! is GameScene) || !debugMode
        {
        return
        }
        let scene = (controller.skView.scene! as! GameScene)
        scene.delete()
    
    if selectedType == 0 //block
    {
    let array = [xText.stringValue, yText.stringValue, wText.stringValue, iText.stringValue]
    scene.createBlock(blockTextValues: array)
        scene.blockArray.last!.debugSelected = true
        scene.blockArray.last!.selected = true

    }
    else if selectedType == 1 //bb
    {
    let array = [xText.stringValue, yText.stringValue, widthText.stringValue, heightText.stringValue, wText.stringValue, typeText.stringValue, iText.stringValue]
    scene.createBox(boxTextValues: array)
        scene.boundingBoxArray.last!.debugSelected = true
        scene.boundingBoxArray.last!.selected = true
    }
    else if selectedType == 2 //line
    {
    let array = [x1Text.stringValue, y1Text.stringValue, x2Text.stringValue, y2Text.stringValue, iText.stringValue]
    scene.createLine(lineTextValues: array)
        scene.lineArray.last!.debugSelected = true
        scene.lineArray.last!.selected = true
    }
    else if selectedType == 3 //triangle
    {
    let array = [xText.stringValue, yText.stringValue, wText.stringValue, iText.stringValue]
    scene.createTriangle(triangleTextValues: array)
        scene.triangleArray.last!.debugSelected = true
        scene.triangleArray.last!.selected = true
    }
    }
    
    func recieveBlock(block: Block)
    {
        xText.stringValue = String(describing: block.position.x / 2.25 /- Int(1))
        yText.stringValue = String(describing: block.position.y / 2.25 /- Int(1))
        wText.stringValue = String(describing: block.weight /- Int(1))
        iText.stringValue = String(block.id)
        selectedType = 0
    }
    
    func recieveBox(bBox: BoundingBox)
    {
        xText.stringValue = String(describing: bBox.position.x / 2.25 /- Int(1))
        yText.stringValue = String(describing: bBox.position.y / 2.25 /- Int(1))
        wText.stringValue = String(describing: bBox.weight /- Int(1))
        iText.stringValue = String(describing: bBox.idString())
        typeText.stringValue = String(bBox.obstacle)
        widthText.stringValue = String(describing: bBox.size.width / 2.25 /- Int(1))
        heightText.stringValue = String(describing: bBox.size.height / 2.25 /- Int(1))
        iText.stringValue = String(bBox.id)
        selectedType = 1
    }
    
    func recieveLine(line: Line)
    {
        x1Text.stringValue = String(describing: (line.p1.x + line.position.x) / 2.25 /- Int(1))
        y1Text.stringValue = String(describing: (line.p1.y + line.position.y) / 2.25 /- Int(1))
        x2Text.stringValue = String(describing: (line.p2.x + line.position.x) / 2.25 /- Int(1))
        y2Text.stringValue = String(describing: (line.p2.y + line.position.y) / 2.25 /- Int(1))
        iText.stringValue = String(describing: line.valueString())
        selectedType = 2
    }
    
    func recieveTriangle(triangle: Triangle)
    {
        xText.stringValue = String(describing: triangle.position.x / 2.25 /- Int(1))
        yText.stringValue = String(describing: triangle.position.y / 2.25 /- Int(1))
        wText.stringValue = String(describing: triangle.weight /- Int(1))
        iText.stringValue = String(triangle.id)
        selectedType = 3
    }
    
    func clear(_ num: Int)
    {
        /*
        xText.isEnabled = false
        yText.isEnabled = false
        wText.isEnabled = false
        iText.isEnabled = false

        widthText.isEnabled = false
        heightText.isEnabled = false
        typeText.isEnabled = false
        
        x1Text.isEnabled = false
        x2Text.isEnabled = false
        y1Text.isEnabled = false
        y2Text.isEnabled = false
        */
        
        xText.stringValue = ""
        yText.stringValue = ""
        wText.stringValue = ""
        iText.stringValue = ""
        
        widthText.stringValue = ""
        heightText.stringValue = ""
        typeText.stringValue = ""
        
        x1Text.stringValue = ""
        x2Text.stringValue = ""
        y1Text.stringValue = ""
        y2Text.stringValue = ""
        
        /*
        if num == 0
        {
            xText.isEnabled = true
            yText.isEnabled = true
            wText.isEnabled = true
            iText.isEnabled = true
        }
        if num == 1
        {
            xText.isEnabled = true
            yText.isEnabled = true
            wText.isEnabled = true
            iText.isEnabled = true
            typeText.isEnabled = true
            widthText.isEnabled = true
            heightText.isEnabled = true
        }
        if num == 2
        {
            x1Text.isEnabled = true
            y1Text.isEnabled = true
            x2Text.isEnabled = true
            y2Text.isEnabled = true
            iText.isEnabled = true
        }
        if num == 3
        {
            xText.isEnabled = true
            yText.isEnabled = true
            wText.isEnabled = true
            iText.isEnabled = true
        }
        */
        
    }
}
