//
//  GameScene.swift
//
//  Created by Steve Smart on 6/6/15.
//  Copyright (c) 2015 Steve Smart. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScene: SKScene {
    
    // MARK: Properties
    var parallaxBackground: ParallaxBackground?
    
    private var playButton: UIButton!
    private var highscoresButton: UIButton!
    private var optionsButton: UIButton!
    
    // MARK: Initialization Methods
    override func didMoveToView(view: SKView) {
        self.anchorPoint = CGPointMake(CGFloat(0.5), CGFloat(0.5))
        
        initializeParallaxBackground()
        initializeMenuButtons()
    }
    
    private func initializeParallaxBackground()
    {
        if parallaxBackground == nil {
            parallaxBackground = ParallaxBackground(imageNames: ImageNames.parallaxBackgrounds, containerHeight: self.size.height, scrollDown: true)
            parallaxBackground!.beginScrolling()
        }
        
        self.addChild(parallaxBackground!)
    }
    
    private func initializeMenuButtons()
    {
        let playButtonFrame = CGRectMake(((self.size.width / 2) - (MenuScene.Constants.playButtonWidth / 2)), (((self.size.height / 2) - (MenuScene.Constants.playButtonHeight / 2)) + MenuScene.Constants.playButtonVerticalOffset), MenuScene.Constants.playButtonWidth, MenuScene.Constants.playButtonHeight)
        playButton = UIButton(frame: playButtonFrame)
        playButton.alpha = 0.0
        playButton.setImage(UIImage(named: ImageNames.playButton), forState: UIControlState.Normal)
        playButton.addTarget(self, action: Selector("playButtonPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let highscoresButtonFrame = CGRectMake(((self.size.width / 2) - (MenuScene.Constants.highscoresButtonWidth / 2)), ((self.size.height / 2) - (MenuScene.Constants.highscoresButtonHeight / 2)), MenuScene.Constants.highscoresButtonWidth, MenuScene.Constants.highscoresButtonHeight)
        highscoresButton = UIButton(frame: highscoresButtonFrame)
        highscoresButton.alpha = 0.0
        highscoresButton.setImage(UIImage(named: ImageNames.highscoresButton), forState: UIControlState.Normal)
        highscoresButton.addTarget(self, action: Selector("highscoresButtonPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let optionsButtonFrame = CGRectMake(((self.size.width / 2) - (MenuScene.Constants.optionsButtonWidth / 2)), (((self.size.height / 2) - (MenuScene.Constants.optionsButtonHeight / 2)) + MenuScene.Constants.optionsButtonVerticalOffset), MenuScene.Constants.optionsButtonWidth, MenuScene.Constants.optionsButtonHeight)
        optionsButton = UIButton(frame: optionsButtonFrame)
        optionsButton.alpha = 0.0
        optionsButton.setImage(UIImage(named: ImageNames.optionsButton), forState: UIControlState.Normal)
        optionsButton.addTarget(self, action: Selector("optionsButtonPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view!.addSubview(playButton)
        self.view!.addSubview(highscoresButton)
        self.view!.addSubview(optionsButton)
        
        UIView.animateWithDuration(Constants.transitionAnimationDuration) {
            self.playButton.alpha = 1.0
            self.highscoresButton.alpha = 1.0
            self.optionsButton.alpha = 1.0
        }
    }
    
    // MARK: Observer Methods
    func playButtonPressed() {
        playButton.removeFromSuperview()
        highscoresButton.removeFromSuperview()
        optionsButton.removeFromSuperview()
        
        let levelScene = LevelScene(size: self.size)
        levelScene.scaleMode = .AspectFill
        
        parallaxBackground!.removeFromParent()
        levelScene.parallaxBackground = parallaxBackground!
        
        self.view!.presentScene(levelScene)
    }
    
    func highscoresButtonPressed() {
        println("highscores button pressed!")
    }
    
    func optionsButtonPressed() {
        println("options button pressed!")
    }
    
    // MARK: Enums & Constants
    struct Constants {
        static let transitionAnimationDuration = 0.5
        
        static let playButtonWidth: CGFloat = 150.0
        static let playButtonHeight: CGFloat = 30.0
        static let playButtonVerticalOffset: CGFloat = -75.0
        
        static let highscoresButtonWidth: CGFloat = 250.0
        static let highscoresButtonHeight: CGFloat = 30.0
        
        static let optionsButtonWidth: CGFloat = 200.0
        static let optionsButtonHeight: CGFloat = 30.0
        static let optionsButtonVerticalOffset: CGFloat = 75.0
    }
}