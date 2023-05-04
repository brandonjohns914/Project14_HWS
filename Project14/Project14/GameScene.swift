//
//  GameScene.swift
//  Project14
//
//  Created by Brandon Johns on 5/2/23.
//

import SpriteKit


class GameScene: SKScene {
    
    var slots = [WhackSlot]()
    
    var gameScore: SKLabelNode!
    
    var popupTime = 0.85
    
    var numRounds = 0
    
    
    var score = 0
    {
        didSet
        {
            gameScore.text = "Score: \(score)"
        }//didset
    }//scpre
    
    override func didMove(to view: SKView)
    {
      let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace                                                             // make background replace whatever was there
        background.zPosition = -1                                                                   // behind other stuff
        
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410 )) }                    // higher y = higher on screen
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320 )) }
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230 )) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140 )) }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1)
        { [weak self] in
            self?.createEnemy()
            
        }// queue
        
        
    }//didMove
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch = touches.first else {return}
        
        let location = touch.location(in: self)                                                         // where they tapped screen
        
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes
        {
            guard let whackSlot = node.parent?.parent as? WhackSlot else                              // find out if the node is the grandparent if that checks out continue
            {
                continue
            }
            if !whackSlot.isVisible {continue}
            if whackSlot.isHit {continue}
            whackSlot.hit()
            
            if node.name == "charFriend"                                                               // dont whack
            {
                score -= 5
                
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            }// if
            else if node.name == "charEnemy"                                                           // whack
            {
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                
                score += 1
                
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                
            }// else if
            
            
        }// for
        
        
    }//touchesBegan
    
    func createSlot(at position: CGPoint)
    {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }// createSlot
    
    func createEnemy()
    {
        numRounds += 1
        
        if numRounds >= 30
        {
            for slot in slots{
                slot.hit()
            }
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            return
        }
        
        
        popupTime *= 0.991
        
        slots.shuffle()
        
        slots[0].show(hideTime: popupTime)
        
        
        if Int.random(in: 0...12) > 4
        {
            slots[1].show(hideTime: popupTime)
        }//4 1
        if Int.random(in: 0...12) > 8
        {
            slots[2].show(hideTime: popupTime)
        }//8 2
        if Int.random(in: 0...12) > 10
        {
            slots[3].show(hideTime: popupTime)
        } // 10 3
        if Int.random(in: 0...12) > 11
        {
            slots[4].show(hideTime: popupTime)
        } // 11 4
        
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay)
        { [weak self] in
            self?.createEnemy()
            
        }//queue
        
    }//createEnemy
    
    
}//gameScene
