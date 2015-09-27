//
//  GameOver.swift
//  Dodger Me!
//
//  Created by Guan Wong on 2/4/15.
//  Copyright (c) 2015 Guan Wong. All rights reserved.
//

import SpriteKit

class GameOver: SKScene {
    var bgImage = SKSpriteNode(imageNamed: "background2")
    var label = SKLabelNode(fontNamed: "Chalkduster")
    var scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    var score:Int = 0
    var highscore:Int = 0
    var winResult = false
    init(size: CGSize, won:Bool, score:Int, highscore:Int) {
        
        super.init(size: size)
        
        self.score = score
        self.highscore = highscore
        self.winResult = won
    }
    
   override func didMoveToView(view: SKView) {
    
    self.anchorPoint = CGPointMake(0.5, 0.5)
    
    //load background
    self.bgImage.position = CGPointMake( 0, 0)
    self.bgImage.name = "bground"
    self.addChild(bgImage)
    
    scoreLabel.text = String(score)
    scoreLabel.fontSize = 40
    scoreLabel.fontColor = SKColor.blackColor()
    scoreLabel.position = CGPoint(x: 0, y: 100)
    addChild(scoreLabel)
    
    let message = self.winResult ? "You Won!" : "You Lose :["
    
    
    label.text = message
    label.fontSize = 40
    label.fontColor = SKColor.blackColor()
    label.position = CGPoint(x: 0, y: 0)
    addChild(label)
    

    let restartLabel = SKLabelNode(fontNamed: "Courier")
    restartLabel.text = "Continue"
    restartLabel.name = "restart"
    restartLabel.fontSize = 20
    restartLabel.fontColor = SKColor.blackColor()
    restartLabel.position = CGPoint(x: 0, y: -view.center.y/2)
    self.addChild(restartLabel)

    }
    
   
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let location = (touch ).locationInNode(self)
            let sprite = self.nodeAtPoint(location)
            if ( sprite.name == "restart"){
                restartGame()
            }
                
            
        }
    }

    
    func restartGame(){
             //   var reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let scene = GameScene(size: self.size)
                if ( self.score > self.highscore){
                    scene.score = self.score
                }
                else {
                    scene.score = self.highscore
                }
                self.view?.presentScene(scene)
            }
    
    
    
   }