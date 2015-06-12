//
//  LevelScene.swift
//  SpaceShooter
//
//  Created by Steve Smart on 6/9/15.
//  Copyright (c) 2015 Steve Smart. All rights reserved.
//

import SpriteKit

class LevelOneScene: SKScene {
    
    var parallaxBackground: ParallaxBackground!
    var hud: Hud!
    var player: Player!
    var beginMessage: SKSpriteNode!
    var instructionsMessage: SKSpriteNode!
    
    var currentPhase = Phase.One
    
    var userReady = false
    var movingRight = false
    var movingLeft = false
    
    var moveRightTouch: UITouch?
    var moveLeftTouch: UITouch?
    
    override func didMoveToView(view: SKView) {
        self.anchorPoint = CGPointMake(CGFloat(0.5), CGFloat(0.5))
        
        initializeParallaxBackground()
        initializeOverlayMessages()
        initializePlayer()
        initializeHud()
    }
    
    private func initializeParallaxBackground() {
        if parallaxBackground != nil {
            for bg in parallaxBackground.backgrounds! {
                self.addChild(bg)
                bg.zPosition = ParallaxBackground.Constants.zPosition
            }
        }
    }
    
    private func initializeOverlayMessages() {
        beginMessage = SKSpriteNode(imageNamed: ImageNames.beginMessageImageName)
        beginMessage.position.y = 100
        
        instructionsMessage = SKSpriteNode(imageNamed: ImageNames.instructionsMessageImageName)
        instructionsMessage.position.y = -75
        
        self.addChild(beginMessage)
        self.addChild(instructionsMessage)
    }
    
    private func initializePlayer() {
        player = Player(imageNamed: ImageNames.playerImageName)
        
        player.position.y = -(self.size.height / 2) + Player.Constants.distanceFromBottomOfScreen
        player.alpha = CGFloat(0)
        player.zPosition = Player.Constants.zPosition
        
        self.addChild(player)
        
        let initialFadeInAction = SKAction.fadeInWithDuration(MenuScene.Constants.transitionAnimationDuration)
        player.runAction(initialFadeInAction)
    }
    
    private func initializeHud() {
        hud = Hud(backgroundImageName: ImageNames.hudBackgroundImageName)
        hud.background.zPosition = Hud.Constants.zPosition
        hud.background.position.y = -((self.size.height / 2) + (hud.background.size.height / 2))
        hud.background.alpha = Hud.Constants.backgroundAlpha
        
        for node in hud.spriteNodes {
            self.addChild(hud.background)
            
            let action = SKAction.moveToY(-((self.size.height / 2) - (hud.background.size.height / 2)), duration: MenuScene.Constants.transitionAnimationDuration)
            node.runAction(action)
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            let touchLocation = touch.locationInView(self.view)
            
            let hudBoundary = (self.size.height) - hud.size.height
            
            if touchLocation.x >= (self.size.width / 2) && touchLocation.y <= hudBoundary {
                movingRight = true
                moveRightTouch = touch
            } else if touchLocation.x < (self.size.width / 2) && touchLocation.y <= hudBoundary {
                movingLeft = true
                moveLeftTouch = touch
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            if userReady == false && touch.tapCount == 2 {
                beginPlayng()
            }
            
            if touch === moveRightTouch {
                movingRight = false
                moveRightTouch = nil
            } else if touch === moveLeftTouch {
                movingLeft = false
                moveLeftTouch = nil
            }
        }
    }
    
    private func beginPlayng() {
        beginMessage.removeFromParent()
        instructionsMessage.removeFromParent()
        
        userReady = true
        player.canShoot = true
        AlienFighter.canSpawn = true
    }
    
    override func update(currentTime: NSTimeInterval) {
        if userReady {
            updatePlayer()
            updateLasers()
            updateEnemies()
        }
    }
    
    private func updatePlayer() {
        updatePlayerPosition()
        updatePlayerVelocity()
        applyFrictionToPlayer()
    }
    
    private func updatePlayerPosition() {
        player.position.x += player.velocity
        if player.position.x < -((self.size.width / 2) - (player.size.width / 3)) {
            player.position.x = -((self.size.width / 2) - (player.size.width / 3))
        } else if player.position.x > ((self.size.width / 2) - (player.size.width / 3)) {
            player.position.x = ((self.size.width / 2) - (player.size.width / 3))
        }
    }
    
    private func updatePlayerVelocity() {
        if movingRight {
            player.velocity += Player.Constants.acceleration
        }
        if movingLeft {
            player.velocity -= Player.Constants.acceleration
        }
        
        if player.velocity > Player.Constants.maxSpeed {
            player.velocity = Player.Constants.maxSpeed
        } else if player.velocity < -(Player.Constants.maxSpeed) {
            player.velocity = -(Player.Constants.maxSpeed)
        }
    }
    
    private func applyFrictionToPlayer() {
        if player.velocity > Player.Constants.friction {
            player.velocity -= Player.Constants.friction
        } else if player.velocity < -(Player.Constants.friction) {
            player.velocity += Player.Constants.friction
        } else {
            player.velocity = 0
        }
    }
    
    private func updateLasers() {
        if player.canShoot {
            player.canShoot = false
            
            let laser = Laser(imageNamed: ImageNames.laserImageName, player: player, containerSize: self.size)
            
            self.addChild(laser)
            
            laser.fire()
            
            let fireRateTimer = NSTimer.scheduledTimerWithTimeInterval(laser.fireRateTimeInterval, target: self,
                selector: Selector("fireRateTimerEnded"), userInfo: nil, repeats: false)
        }
    }
    
    func fireRateTimerEnded() {
        player.canShoot = true
    }
    
    private func updateEnemies() {
        switch currentPhase {
        case .One:
            updateEnemiesForPhaseOne()
        case .Two:
            break
        case .Three:
            break
        }
    }
    
    private func updateEnemiesForPhaseOne() {
        if AlienFighter.canSpawn {
            AlienFighter.canSpawn = false
            
            let alienFighter = AlienFighter(imageNamed: ImageNames.alienFighter, player: player, containerSize: self.size, velocity: AlienFighter.Constants.baseVelocity)
            
            self.addChild(alienFighter)
            
            alienFighter.animate(AlienFighter.AnimationType.Down)
            
            let alienFighterSpawnRateTimer = NSTimer.scheduledTimerWithTimeInterval(AlienFighter.Constants.spawnRate, target: self,
                selector: Selector("alienFighterSpawnRateTimerEnded"), userInfo: nil, repeats: false)
        }
    }
    
    func alienFighterSpawnRateTimerEnded() {
        AlienFighter.canSpawn = true
    }
    
    enum Phase {
        case One
        case Two
        case Three
    }
}