//
//  WhackSlot.swift
//  Project14
//
//  Created by Brandon Johns on 5/3/23.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {
    
    var charNode: SKSpriteNode!                                                                             // holds pengiun image
    
    var isVisible = false
    var isHit = false
    

    
    func configure(at position: CGPoint)
    {
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")                                                  // the hole on the screen
                                                                                                            // hole node
        addChild(sprite)
        
        let cropNode = SKCropNode()                                                                         // crop node hides the pengiun
                                                                                                            // everything with color is visible
                                                                                                            // everything transparent invisible
        
        cropNode.position = CGPoint(x: 0, y: 15)                                                            // 15: makes it line up with core graphics
        cropNode.zPosition = 1                                                                              // bring forward
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")                                           //image to hide the penguin
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")                                                  //penguin
        charNode.position = CGPoint(x: 0, y: -90)                                                           // -90 = off the screen below the hole
        charNode.name = "character"                                                                         //node name
        
        
        cropNode.addChild(charNode)                                                                         // character node added to the child node
        
        
        addChild(cropNode)
    }// configure
    
    func show(hideTime: Double)
    {
        if isVisible{return}                                                                                        // visible = true return
        
        charNode.xScale = 1                                                                                         //returns pengiun back to normal size 
        charNode.yScale = 1
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))                                                  // y:80 up in 0.05
        isVisible = true
        isHit = false
        
        
        if Int.random(in: 0...2) == 0                                                                               // 1/3 chance to be good pengiun
        {
            charNode.texture = SKTexture(imageNamed: "penguinGood")                                                         // SKTexture holds image data without showing it
            charNode.name = "charFriend"                                                                                    //node name
        }//if
        else
        {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")                                                 //2/3 bad pengiun
            charNode.name = "charEnemy"                                                                                     //node name
        }//else
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5))
        { [weak self ] in
            self?.hide()                                                                                            // hides itself after some time
            
        }//DisPatchQueue
        
    }//show
    
    func hide()
    {
        if !isVisible {return}                                                                                      // not visible return
        
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))                                                 // moves -80 to hide to hole
        isVisible = false                                                                                           // hide
    }//hide
    
    func hit()
    {                                                                                                               //SKAction requires closure to run
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)                                                                // wait .25 of a sec
        
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)                                                     //  move -80 to hide
        
        let notVisible = SKAction.run
        { [weak self] in
            self?.isVisible = false                                                                                 // calls it self to hide 
        }// notVisible
        
        let sequence = SKAction.sequence([delay, hide, notVisible])                                                 // order of operations
        
        charNode.run(sequence)                                                                                      // run inm this order
    }//hit
    
}//whackSlot
