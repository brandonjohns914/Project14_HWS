//
//  GameScene.swift
//  Project14
//
//  Created by Brandon Johns on 5/2/23.
//

import SpriteKit


class GameScene: SKScene {
    
    var slots = [WhackSlot]()                                                                      // slots for the game
    
    var gameScore: SKLabelNode!
    
    var popupTime = 0.85
    
    var numRounds = 0
    
    var scoreLabel: SKLabelNode!
    
    var score = 0
    {
        didSet
        {
            gameScore.text = "Score: \(score)"
        }//didset
    }//scpre
    
    override func didMove(to view: SKView)
    {
      let background = SKSpriteNode(imageNamed: "whackBackground")                                  //background
        background.position = CGPoint(x: 512, y: 384)                                               // middle of view
        background.blendMode = .replace                                                             // make background over whatever is there
        background.zPosition = -1                                                                   // way back
        
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")                                           // font of score
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)                                                    // bottom left corner
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        
                                                                                                   // slot creation 5 4 5 4
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410 )) }                    //  y = higher on screen
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320 )) }                    // 180 indents
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230 )) }
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140 )) }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1)                                         // waits one second after the game starts 
        { [weak self] in
            self?.createEnemy()
            
        }// queue
        
        
    }//didMove
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch = touches.first else {return}                                                   // cant read touch leave
        
        let location = touch.location(in: self)                                                         // where the screen was tapped
        
        let tappedNodes = nodes(at: location)                                                           //nodes at the location tapped
        
        for node in tappedNodes
        {                                                                                               // find out if the node is the grandparent if that checks out continue
            guard let whackSlot = node.parent?.parent as? WhackSlot else                              // node = where was tapped =.parent? any kind of SKNode
            {
                continue                                                                                // if fails goes to the next tapped node
            }                                                                                          //read the grandparent of what was tapped and if it was a whackslot
            
            if !whackSlot.isVisible {continue}
            if whackSlot.isHit {continue}
            whackSlot.hit()                                                                             // whats hit
            
            if node.name == "charFriend"                                                               // dont whack
            {
                score -= 5
                whackSlot.charNode.xScale = 1.25                                                       // grows
                whackSlot.charNode.yScale = 1.25
                
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
            }// if
            
            else if node.name == "charEnemy"                                                           // whack
            {
                whackSlot.charNode.xScale = 0.85                                                       //shrinks
                whackSlot.charNode.yScale = 0.85
                
                score += 1
                
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                
            }// else if
            
            
        }// for
        
        
    }//touchesBegan
    
    func createSlot(at position: CGPoint)
    {
        let slot = WhackSlot()                                                                                      // calls the WhackSlot class
        slot.configure(at: position)                                                                                // places on screen
        addChild(slot)                                                                                              // add node
        slots.append(slot)                                                                                          // add to array
    }// createSlot
    
    func createEnemy()
    {
        numRounds += 1
        
        if numRounds >= 30                                                                                          // 30 rounds of play
        {
            for slot in slots{
                slot.hide()
            }// for 
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            
            scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
            scoreLabel.text = "Score: 0"
            scoreLabel.horizontalAlignmentMode = .center
            scoreLabel.fontSize = 44
            scoreLabel.fontColor = .brown
            scoreLabel.position = CGPoint(x: 512, y: 580)                                                           // middle 
            addChild(scoreLabel)
            
            return                                                                                                  // tells to stop calling createEnemy
        }// numRounds
        
        
        popupTime *= 0.991                                                                                          // multiple popupTime 0.85 by 0.991
        
        slots.shuffle()                                                                                             // shuffle which slot
        
        slots[0].show(hideTime: popupTime)                                                                          //slot[0] show and hide at the right time
        
        
        if Int.random(in: 0...12) > 4
        {
            slots[1].show(hideTime: popupTime)                                                                     // show more than 4 slots
        }//4 1
        if Int.random(in: 0...12) > 8
        {
            slots[2].show(hideTime: popupTime)                                                                      // 8 slots
        }//8 2
        if Int.random(in: 0...12) > 10
        {
            slots[3].show(hideTime: popupTime)                                                                      // 10 slots
        } // 10 3
        if Int.random(in: 0...12) > 11
        {
            slots[4].show(hideTime: popupTime)
        } // 11 4
        
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        
        let delay = Double.random(in: minDelay...maxDelay)                                                         // the delay times
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay)                                                     // when the program should run
        { [weak self] in
            self?.createEnemy()                                                                                     // create enemy calls it self
            
        }//queue                                                                                                     // main == current thread
                                                                                                                    // run now + the delay
        
        
    }//createEnemy
    
    
}//gameScene
