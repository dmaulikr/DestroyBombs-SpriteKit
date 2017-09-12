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
    var scoreLabel = SKLabelNode()
    var gameOverLayer = GameOverLayer()
    let textureAtlas = SKTextureAtlas(named: "Sprites.atlas")
    
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
            let gameOverLocation = touch.location(in: gameOverLayer)
            
            // This part handles touches on GameScene
            if let rectNode = atPoint(location).name {
                
                if rectNode == "BombOne" {
                    scoreNumber += 1
                    scoreLabel.text = "Score: \(scoreNumber)"
                    nodeAtLocation.removeFromParent()
                    createSparkEffect(position: location, sparkName: "BombOne")
                }

                else if rectNode == "BombTwo" {
                    scoreNumber += 2
                    scoreLabel.text = "Score: \(scoreNumber)"
                    nodeAtLocation.removeFromParent()
                    createSparkEffect(position: location, sparkName: "BombTwo")
                }
                
            }
            
            // This part handles touches on GameOverLayer
            
            if let gameOverNode = atPoint(gameOverLocation).name {
                
                if gameOverNode == "RetryButton" {
                    let newScene = GameScene(size: self.size)
                    newScene.scaleMode = .aspectFill
                    let animation = SKTransition.crossFade(withDuration: 1.0)
                    self.view?.presentScene(newScene, transition: animation)
                }
            }

            
        }
        
    }

    
    func initialize() {
        
        self.backgroundColor = UIColor.black
        frameWidth = frame.size.width
        frameHeight = frame.size.height
        createCity()
        createScore()
        physicsWorld.contactDelegate = self
        
    }
    
    func createCity() {
        
        let city = City(textureAtlas: textureAtlas)
        city.position = CGPoint(x: frameWidth / 2.0 , y: 0)
        city.size.width = frameWidth
        city.anchorPoint = CGPoint(x: 0.5, y: 0)
        city.zPosition = 4
        city.name = "City"
        self.addChild(city)
    }
    
    func createScore() {
        
        scoreLabel.position = CGPoint(x: 15, y: frameHeight - 30 )
        scoreLabel.fontSize = 25
        scoreLabel.zPosition = 5
        scoreLabel.name = "Score"
        scoreLabel.text = "Score: \(scoreNumber)"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.fontName = "Courier-Bold"
        addChild(scoreLabel)
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
        
        let bombOne = BombOne(textureAtlas: textureAtlas)
        var bombDuration: TimeInterval = 2.2
        bombOne.position = CGPoint(x: xPosition, y: self.frame.height)
        bombOne.name = "BombOne"
        bombOne.zPosition = 5
        bombOne.anchorPoint = CGPoint(x: 0.5, y: 0)

        
        if scoreNumber > 20 {
            bombDuration = 1.8
        }
        
        let actionMove = SKAction.moveTo(y: 0, duration: bombDuration)
        bombOne.run(actionMove)
        self.addChild(bombOne)
    }
    
    func addBombTwo(xPosition: CGFloat) {
        
        let bombTwo = BombTwo(textureAtlas: textureAtlas)
        var bombDuration: TimeInterval = 1.7
        var newX: CGFloat = 0
        var angle: CGFloat = 0
        
        bombTwo.position = CGPoint(x: xPosition, y: self.frame.height)
        bombTwo.name = "BombTwo"
        bombTwo.zPosition = 5
        bombTwo.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        if xPosition <= frameWidth / 2 {
            newX = xPosition + (frameWidth / 2)
            angle = atan2(frameHeight - 100, newX)
            bombTwo.zRotation = angle
            
        }
        else {
            newX = xPosition - (frameWidth / 2)
            angle = atan2(frameHeight - 100, newX)
            bombTwo.zRotation = angle - 90
        }
        
        if scoreNumber > 20 {
            bombDuration = 1.5
        }
        
        let actionMove = SKAction.move(to: CGPoint(x: newX, y: 0), duration: bombDuration)
        bombTwo.run(actionMove)
        self.addChild(bombTwo)
    }
    
    func createSparkEffect(position: CGPoint, sparkName: String) {
        
        let spark: SKEmitterNode?
        let sparkPath = Bundle.main.path(forResource: sparkName, ofType: "sks")
        spark =  NSKeyedUnarchiver.unarchiveObject(withFile: sparkPath!) as? SKEmitterNode
        spark?.zPosition = 5
        spark?.position = position
        addChild(spark!)
        let removeSpark = SKAction.sequence([SKAction.wait(forDuration: 1.5), SKAction.removeFromParent()])
        spark?.run(removeSpark)
        
    }
    
    func createGameOverLayer() {
        
        let gameOverBackgroundColor = UIColor.black.withAlphaComponent(0.4)
        gameOverLayer.size = frame.size
        gameOverLayer.color = gameOverBackgroundColor
        gameOverLayer.displayGameOverLayer(scoreNumber)
        gameOverLayer.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        gameOverLayer.position = CGPoint(x: 0.0, y: 0.0)
        gameOverLayer.zPosition = 7
        addChild(gameOverLayer)
    }
    
    func saveScore() {
        
        if let bestScore = ScoreManager.instance.getBestScore() {
            if bestScore < scoreNumber {
                ScoreManager.instance.setBestScore(bestScore: scoreNumber)
            }
        }
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
            self.removeAllActions()
            for child in self.children {
                if child.name == "BombOne" || child.name == "BombTwo" || child.name == "Score" {
                    child.removeFromParent()
                }
            }
            saveScore()
            
            let fade = SKAction.fadeAlpha(to: 0, duration: 1.5)
            
            run(SKAction.sequence([
                    SKAction.run({self.childNode(withName: "City")?.run(fade)}),
                    SKAction.wait(forDuration: 1.5),
                    SKAction.run({self.childNode(withName: "City")?.removeFromParent()}),
                    SKAction.run(createGameOverLayer)
                    ])
            )
        }
        
    }
}















