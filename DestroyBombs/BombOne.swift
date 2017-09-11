//
//  BombOne.swift
//  DestroyBombs
//
//  Created by Ivica Tokic on 10/09/2017.
//  Copyright © 2017 Ivica Tokic. All rights reserved.
//

import Foundation
import SpriteKit

class BombOne : SKSpriteNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        let texture = SKTexture(imageNamed: "BombOne")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = PhysicsCategory.Bomb
        physicsBody?.contactTestBitMask = PhysicsCategory.City
        physicsBody?.collisionBitMask = 0
        
    }
        
}
