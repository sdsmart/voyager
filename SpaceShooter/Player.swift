//
//  Player.swift
//  SpaceShooter
//
//  Created by Steve Smart on 6/9/15.
//  Copyright (c) 2015 Steve Smart. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    var velocity: CGFloat = 0
    var acceleration: CGFloat = 0
    
    var canShoot = false
    
    struct Constants {
        static let friction: CGFloat = 0.25
        static let maxSpeed: CGFloat = 7
        static let acceleration: CGFloat = 0.80
        
        static let distanceFromBottomOfScreen: CGFloat = 130
        
        static let zPosition: CGFloat = 3
    }
}