//
//  GameOverLayer.swift
//  DestroyBombs
//
//  Created by Ivica Tokic on 11/09/2017.
//  Copyright © 2017 Ivica Tokic. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverLayer: SKSpriteNode {
    
    let retryButton = SKSpriteNode(imageNamed: "RetryButton")
    
    func displayGameOverLayer(_ score: Int) {
        
        let gameOverLabel = SKLabelNode(text: "GAME OVER")
        let gameOverLabelX = self.frame.width / 2
        let gameOverLabelY = (self.frame.height / 2) * 1.25
        gameOverLabel.position = CGPoint(x: gameOverLabelX, y: gameOverLabelY)
        gameOverLabel.zPosition = 3
        gameOverLabel.fontSize = 25
        gameOverLabel.fontName = "Courier-Bold"
        gameOverLabel.name = "GameOver"
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(text: "Score: \(score)")
        let scoreLabelX = self.frame.width / 2
        let scoreLabelY = self.frame.height / 2
        scoreLabel.position = CGPoint(x: scoreLabelX, y: scoreLabelY)
        scoreLabel.zPosition = 3
        scoreLabel.fontSize = 25
        scoreLabel.fontName = "Courier-Bold"
        scoreLabel.name = "Score"
        self.addChild(scoreLabel)
        
        let retryButtonX = self.frame.width / 2
        let retryButtonY = (self.frame.height / 2) * 0.75
        retryButton.name = "RetryButton"
        retryButton.position = CGPoint(x: retryButtonX, y: retryButtonY)
        retryButton.zPosition = 3
        self.addChild(retryButton)
        
    }

}
