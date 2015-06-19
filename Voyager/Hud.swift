//
//  Hud.swift
//
//  Created by Steve Smart on 6/10/15.
//  Copyright (c) 2015 Steve Smart. All rights reserved.
//

import Foundation
import SpriteKit

class Hud: SKSpriteNode {
    
    // MARK: Properties
    private let background: SKSpriteNode
    private let healthHeader: SKSpriteNode
    private let levelHeader: SKSpriteNode
    private let goldHeader: SKSpriteNode
    private let useSpecialHeader: SKSpriteNode
    private let useItemHeader: SKSpriteNode
    private var healthBar: SKSpriteNode
    private var healthBarMaxWidth: CGFloat
    private var levelValue: SKLabelNode
    private var goldValue: SKLabelNode
    private var parentScene: LevelScene
    
    // MARK: Initializers
    init(parentScene: LevelScene) {
        self.parentScene = parentScene
        
        self.background = SKSpriteNode(imageNamed: ImageNames.hudBackground)
        self.background.zPosition = Constants.zPosition
        
        self.healthHeader = SKSpriteNode(imageNamed: ImageNames.hudHealthHeader)
        self.healthHeader.zPosition = Constants.zPosition
        self.healthHeader.position.x = -(parentScene.size.width / 2) + (self.healthHeader.size.width / 2) + Constants.healthHeaderHorizontalOffset
        self.healthHeader.position.y = (self.background.size.height / 2) - (self.healthHeader.size.height / 2) - Constants.healthHeaderVerticalOffset
        
        self.healthBar = SKSpriteNode(imageNamed: ImageNames.hudHealthBar)
        self.healthBar.anchorPoint = CGPointMake(CGFloat(0.0), CGFloat(0.5))
        self.healthBar.zPosition = Constants.zPosition
        self.healthBar.position.x = -(parentScene.size.width / 2) + Constants.healthBarHorizontalOffset
        self.healthBar.position.y = (self.background.size.height / 2) - (self.healthBar.size.height / 2) - Constants.healthBarVerticalOffset
        self.healthBarMaxWidth = healthBar.size.width
        
        self.levelHeader = SKSpriteNode(imageNamed: ImageNames.hudLevelHeader)
        self.levelHeader.zPosition = Constants.zPosition
        self.levelHeader.position.x = -(parentScene.size.width / 2) + (self.levelHeader.size.width / 2) + Constants.levelHeaderHorizontalOffset
        self.levelHeader.position.y = (self.background.size.height / 2) - (self.levelHeader.size.height / 2) - Constants.levelHeaderVerticalOffset
        
        self.levelValue = SKLabelNode(fontNamed: Constants.levelValueFontName)
        self.levelValue.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        self.levelValue.fontSize = Constants.levelValueFontSize
        self.levelValue.fontColor = Constants.levelValueColor
        self.levelValue.zPosition = Constants.zPosition
        self.levelValue.position.x = -(parentScene.size.width / 2) + Constants.levelValueHorizontalOffset
        self.levelValue.position.y = (self.background.size.height / 2) - Constants.levelValueVerticalOffset
        
        self.goldHeader = SKSpriteNode(imageNamed: ImageNames.hudGoldHeader)
        self.goldHeader.zPosition = Constants.zPosition
        self.goldHeader.position.x = -(parentScene.size.width / 2) + (self.goldHeader.size.width / 2) + Constants.goldHeaderHorizontalOffset
        self.goldHeader.position.y = (self.background.size.height / 2) - (self.goldHeader.size.height / 2) - Constants.goldHeaderVerticalOffset
        
        self.goldValue = SKLabelNode(fontNamed: Constants.goldValueFontName)
        self.goldValue.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        self.goldValue.fontSize = Constants.goldValueFontSize
        self.goldValue.fontColor = Constants.goldValueColor
        self.goldValue.zPosition = Constants.zPosition
        self.goldValue.position.x = -(parentScene.size.width / 2) + Constants.goldValueHorizontalOffset
        self.goldValue.position.y = (self.background.size.height / 2) - Constants.goldValueVerticalOffset
        
        self.useSpecialHeader = SKSpriteNode(imageNamed: ImageNames.hudUseSpecialHeader)
        self.useSpecialHeader.zPosition = Constants.zPosition
        self.useSpecialHeader.position.x = (parentScene.size.width / 2) - Constants.useSpecialHeaderHorizontalOffset
        self.useSpecialHeader.position.y = (self.background.size.height / 2) - Constants.useSpecialHeaderVerticalOffset
        
        self.useItemHeader = SKSpriteNode(imageNamed: ImageNames.hudUseItemHeader)
        self.useItemHeader.zPosition = Constants.zPosition
        self.useItemHeader.position.x = (parentScene.size.width / 2) - Constants.useItemHeaderHorizontalOffset
        self.useItemHeader.position.y = (self.background.size.height / 2) - Constants.useItemHeaderVerticalOffset
        
        let texture = SKTexture(imageNamed: ImageNames.hudBackground)
        super.init(texture: texture, color: nil, size: texture.size())
        
        self.zPosition = Constants.zPosition
        self.size = self.background.size
        self.alpha = 0.0
        self.position.y = -((parentScene.size.height / 2) - (self.background.size.height / 2))
        
        self.addChild(background)
        self.addChild(healthHeader)
        self.addChild(healthBar)
        self.addChild(goldHeader)
        self.addChild(goldValue)
        self.addChild(levelHeader)
        self.addChild(levelValue)
        self.addChild(useSpecialHeader)
        self.addChild(useItemHeader)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Utility Methods
    func updateHealthBar(#health: Int) {
        var newHealth = health
        if newHealth < 0 {
            newHealth = 0
        } else if newHealth > Player.Constants.maxHealth {
            newHealth = Player.Constants.maxHealth
        }
        
        healthBar.size.width = healthBarMaxWidth * CGFloat(newHealth) / CGFloat(Player.Constants.maxHealth)
    }
    
    func updateLevelValue(#level: Int) {
        var newLevel = level
        if newLevel < 1 {
            newLevel = 1
        }
        
        levelValue.text = "\(newLevel)"
    }
    
    func updateGoldValue(#gold: Int) {
        var newGold = gold
        if newGold > 99999 {
            newGold = 99999
        } else if newGold < 0 {
            newGold = 0
        }
        
        goldValue.text = "\(newGold)"
    }
    
    // MARK: Enums & Constants
    struct Constants {
        static let healthHeaderHorizontalOffset: CGFloat = 11.0
        static let healthHeaderVerticalOffset: CGFloat = 12.0
        static let healthBarHorizontalOffset: CGFloat = 75.0
        static let healthBarVerticalOffset: CGFloat = 14.0
        static let levelHeaderHorizontalOffset: CGFloat = 10.0
        static let levelHeaderVerticalOffset: CGFloat = 33.0
        static let levelValueHorizontalOffset: CGFloat = 58.0
        static let levelValueVerticalOffset: CGFloat = 44.0
        static let levelValueFontName = "HelveticaNeue-Medium"
        static let levelValueFontSize: CGFloat = 14.0
        static let levelValueColor = UIColor(red: 0, green: 255/255, blue: 255/255, alpha: 1.0)
        static let goldHeaderHorizontalOffset: CGFloat = 77.0
        static let goldHeaderVerticalOffset: CGFloat = 32.5
        static let goldValueHorizontalOffset: CGFloat = 121.0
        static let goldValueVerticalOffset: CGFloat = 44.0
        static let goldValueFontName = "HelveticaNeue-Medium"
        static let goldValueFontSize: CGFloat = 14.0
        static let goldValueColor = UIColor(red: 255/255, green: 185/255, blue: 0, alpha: 1.0)
        static let useSpecialHeaderHorizontalOffset: CGFloat = 39.0
        static let useSpecialHeaderVerticalOffset: CGFloat = 20.0
        static let useItemHeaderHorizontalOffset: CGFloat = 116.0
        static let useItemHeaderVerticalOffset: CGFloat = 20.0
        static let zPosition: CGFloat = 5.0
    }
}