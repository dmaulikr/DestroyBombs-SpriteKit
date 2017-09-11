//
//  ScoreManager.swift
//  DestroyBombs
//
//  Created by Ivica Tokic on 11/09/2017.
//  Copyright © 2017 Ivica Tokic. All rights reserved.
//

import Foundation

class ScoreManager {
    
    static let instance  = ScoreManager()
    private init() {}
    
    func setBestScore(bestScore: Int) {
        UserDefaults.standard.set(bestScore, forKey: "BestScore")
    }
    
    func getBestScore() -> Int? {
        return UserDefaults.standard.integer(forKey: "BestScore")
    }
}
