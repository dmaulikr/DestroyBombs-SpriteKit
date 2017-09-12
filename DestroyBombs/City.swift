//
//  City.swift
//  DestroyBombs
//
//  Created by Ivica Tokic on 10/09/2017.
//  Copyright © 2017 Ivica Tokic. All rights reserved.
//


import Foundation
import SpriteKit

class City : SKSpriteNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textureAtlas: SKTextureAtlas) {
        
        let texture = textureAtlas.textureNamed("City")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = PhysicsCategory.City
        physicsBody?.contactTestBitMask = PhysicsCategory.Bomb
        physicsBody?.collisionBitMask = 0
        
    }
    
}
