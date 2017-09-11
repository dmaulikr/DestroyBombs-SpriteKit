//
//  GameScene.swift
//  DestroyBombs
//
//  Created by Ivica Tokic on 10/09/2017.
//  Copyright © 2017 Ivica Tokic. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var frameWidth : CGFloat = 0.0
    var frameHeight : CGFloat = 0.0
    var scoreNumber: Int = 0
    
    override func didMove(to view: SKView) {
        
        initialize()
        
        //action that puts bomb on screen every 0.8 seconds
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addBomb),
                SKAction.wait(forDuration: 0.8)
                ])
        ))
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        for touch in touches {
            let location = touch.location(in: self)
            let nodeAtLocation = atPoint(location)
            
            if let rectNode = atPoint(location).name {
                
                if rectNode == "BombOne" {
                    scoreNumber += 1
                    nodeAtLocation.removeFromParent()
                }

                else if rectNode == "BombTwo" {
                    scoreNumber += 2
                    nodeAtLocation.removeFromParent()
                }
                
            }
            
        }
        
    }

    
    func initialize() {
        
        frameWidth = frame.size.width
        frameHeight = frame.size.height
        createCity()
        createScore()
        physicsWorld.contactDelegate = self
        
    }
    
    func createCity() {
        let city = City()
        city.position = CGPoint(x: frameWidth / 2.0 , y: 0)
        city.size.width = frameWidth
        city.anchorPoint = CGPoint(x: 0.5, y: 0)
        city.zPosition = 4
        city.name = "City"
        self.addChild(city)
    }
    
    func createScore() {
        
    }
    
    
    func addBomb() {
        
        let randomNumber = Int(arc4random_uniform(2))
        
        let min = UInt32(20)
        let max = UInt32(frameWidth - 20)
        
        let randomX = CGFloat(arc4random_uniform(max - min) + min)
        
        switch randomNumber {
        case 0:
            addBombOne(xPosition: randomX)
        case 1:
            addBombTwo(xPosition: randomX)
        default:
            print("Not a valid number")
        }
        
    }
    
    func addBombOne(xPosition: CGFloat) {
        
        let bombOne = BombOne()
        var bombDuration: TimeInterval = 2.0
        bombOne.position = CGPoint(x: xPosition, y: self.frame.height)
        bombOne.name = "BombOne"
        bombOne.zPosition = 5
        bombOne.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        let actionMove = SKAction.moveTo(y: 0, duration: bombDuration)
        bombOne.run(actionMove)
        self.addChild(bombOne)
    }
    
    func addBombTwo(xPosition: CGFloat) {
        
        let bombTwo = BombTwo()
        var bombDuration: TimeInterval = 1.7
        bombTwo.position = CGPoint(x: xPosition, y: self.frame.height)
        bombTwo.name = "BombTwo"
        bombTwo.zPosition = 5
        bombTwo.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        let actionMove = SKAction.moveTo(y: 0, duration: bombDuration)
        bombTwo.run(actionMove)
        self.addChild(bombTwo)
    }
    
    func gameOverLabel() {
        
        let gameOver = SKLabelNode(text: "GAME OVER")
        gameOver.position = CGPoint(x: frameWidth / 2, y: frameHeight / 2)
        gameOver.zPosition = 5
        gameOver.fontSize = 25
        gameOver.fontName = "Courier-Bold"
        gameOver.name = "GameOver"
        self.addChild(gameOver)
    }
    
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.node?.name == "BombOne" || contact.bodyA.node?.name == "BombTwo"{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if firstBody.node?.name == "BombOne" || firstBody.node?.name == "BombTwo" && secondBody.node?.name == "City" {
            print("dodoir")
            self.removeAllActions()
            for child in self.children {
                if child.name == "BombOne" || child.name == "BombTwo" {
                    child.removeFromParent()
                    gameOverLabel()
                }
            }
            
            
        }
        
    }
}















