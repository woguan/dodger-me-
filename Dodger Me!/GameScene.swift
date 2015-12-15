//
//  GameScene.swift
//  Dodger Me!
//
//  Created by Guan Wong on 2/3/15.
//  Copyright (c) 2015 Guan Wong. All rights reserved.
//

/*

 THIS IS THE MAIN MENU

*/

import SpriteKit

class GameScene: SKScene{
    
  //  deinit{
  //      print(" gamescene being deInitialized.");
        
 //   }
    
    var score = 0;
    var scoreBoard = SKLabelNode()
    override func didMoveToView(view: SKView){
        
        let height = 60
        let width = 250
        
        self.backgroundColor = SKColor.lightGrayColor()
        
        
        
        let newGameButton = UIButton (frame: CGRectMake(0,0,CGFloat(width),CGFloat(height)))
        newGameButton.center = CGPointMake(view.center.x, view.center.y)
        newGameButton.setTitle("START GAME", forState: .Normal)
        newGameButton.titleLabel?.font = UIFont(name: "Chalkduster", size: 30)
        newGameButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        newGameButton.backgroundColor = UIColor.darkGrayColor()
        newGameButton.addTarget(self, action: "startGame", forControlEvents: .TouchUpInside)
        newGameButton.layer.cornerRadius = 5.0
        view.addSubview(newGameButton)
        
        scoreBoard.text = "High Score: \(score)"
        scoreBoard.name = "scoring"
        scoreBoard.fontSize = 20
        scoreBoard.fontColor = SKColor.blackColor()
        scoreBoard.position = CGPoint(x:150, y:150)
        self.addChild(scoreBoard)

        
    }
    
    @IBAction func startGame() {
        
    /*    let scene = StartGame(size: self.size)
        scene.highscore = score
        view?.presentScene(scene)*/
        
        let scene = LevelMenu(size: self.size)
        view?.presentScene(scene)
        
        
    }
    
     override func willMoveFromView(view: SKView) {
        for view in view.subviews {
            view.removeFromSuperview()
        }
    }
    
    }
    
    

