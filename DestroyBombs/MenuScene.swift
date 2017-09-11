//
//  MenuScene.swift
//  DestroyBombs
//
//  Created by Ivica Tokic on 11/09/2017.
//  Copyright © 2017 Ivica Tokic. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    let playButton = SKSpriteNode(imageNamed: "PlayGame")
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor.black
        createMenuScene()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if atPoint(location).name == "Play" {
                let gameScene = GameScene(size: size)
                gameScene.scaleMode = .aspectFill
                self.view?.presentScene(gameScene)
            }
        }
    }
    
    func createMenuScene() {
        
        let gameNameLabel = SKLabelNode(text: "DESTROY BOMBS")
        let gameNameLabelX = self.frame.width / 2
        let gameNameLabelY = (self.frame.height / 2) * 1.50
        gameNameLabel.fontName = "Courier-Bold"
        gameNameLabel.fontSize = 45
        gameNameLabel.position = CGPoint(x: gameNameLabelX, y: gameNameLabelY)
        self.addChild(gameNameLabel)
        
        
        let bestScoreLabel = SKLabelNode()
        let bestScoreLabelX = self.frame.width / 2
        let bestScoreLabelY = self.frame.height / 2
        bestScoreLabel.fontName = "Courier-Bold"
        bestScoreLabel.fontSize = 32
        bestScoreLabel.position = CGPoint(x: bestScoreLabelX, y: bestScoreLabelY)
        
        // Get the best score that is saved in user defaults
        if let score = ScoreManager.instance.getBestScore() {
            bestScoreLabel.text = "Best Score: " + String(score)
        }
        else {
            bestScoreLabel.text = "Best Score: Not"
        }
        
        self.addChild(bestScoreLabel)
        
        let playButtonX = self.frame.width / 2
        let playButtonY = (self.frame.height / 2) * 0.7
        playButton.position = CGPoint(x: playButtonX, y: playButtonY)
        playButton.name = "Play"
        self.addChild(playButton)
        
    }
}
