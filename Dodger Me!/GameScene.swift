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
    
    deinit{
        print(" gamescene being deInitialized.");
        
    }

    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate // Create reference to the app delegate
    var score = 0;
    var pointLabel = SKLabelNode()
    override func didMoveToView(view: SKView){
        
        let height = 60
        let width = 250
        
        self.backgroundColor = SKColor.lightGrayColor()
        
        //initialize the virtual plist
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        
        // giving the path?
        let fullPathName = documentDirectory.stringByAppendingPathComponent("dodger.plist") as String
        
        // plistFile is the root ( which is of the type Dictionary )
        let plistFile = NSMutableDictionary(contentsOfFile:fullPathName)
        
        // pointsPlist
        let points_from_plist = plistFile?.valueForKey("Points") as! Int

        let newGameButton = UIButton (frame: CGRectMake(0,0,CGFloat(width),CGFloat(height)))
        newGameButton.center = CGPointMake(view.center.x, view.center.y - 60)
        newGameButton.setTitle("START GAME", forState: .Normal)
        newGameButton.titleLabel?.font = UIFont(name: "Chalkduster", size: 30)
        newGameButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        newGameButton.backgroundColor = UIColor.darkGrayColor()
        newGameButton.addTarget(self, action: "startGame", forControlEvents: .TouchUpInside)
        newGameButton.layer.cornerRadius = 5.0
        view.addSubview(newGameButton)
        
        let HighscoreButton = UIButton (frame: CGRectMake(0,0,CGFloat(width),CGFloat(height)))
        HighscoreButton.center = CGPointMake(view.center.x, view.center.y + 60)
        HighscoreButton.setTitle("HIGHSCORE", forState: .Normal)
        HighscoreButton.titleLabel?.font = UIFont(name: "Chalkduster", size: 30)
        HighscoreButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        HighscoreButton.backgroundColor = UIColor.darkGrayColor()
        HighscoreButton.addTarget(self, action: "highScore_action", forControlEvents: .TouchUpInside)
        HighscoreButton.layer.cornerRadius = 5.0
        view.addSubview(HighscoreButton)
        
        
     
        // SKSprite of points
        let point_image = SKSpriteNode(imageNamed: "sprites/coin")
        point_image.name = "points"
        point_image.size = CGSize(width: 70, height: 70)
        point_image.position = CGPoint(x:  view.center.x + 120, y: view.center.y + 210)
        addChild(point_image)

        
        // Sksprite label points
        pointLabel.text = "\(points_from_plist)"
        pointLabel.name = "scoring"
        pointLabel.fontSize = 20
        pointLabel.fontName = "Arial-BoldMT"
        pointLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        pointLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom;
        pointLabel.fontColor = SKColor.blackColor()
        pointLabel.position = CGPoint(x:view.center.x + 100, y: view.center.y + 200)
        self.addChild(pointLabel)
        
        // Animate Coin
        var tempBool = true
       // point_image.alpha = 0.2
        runAction(SKAction.repeatActionForever(
               SKAction.sequence([ SKAction.runBlock({
                
                        if(tempBool == true){
                           point_image.alpha -= 0.1
                            if (point_image.alpha <= 0.3){
                                tempBool = false
                            }
                        }
                        else{
                            point_image.alpha += 0.1
                            if (point_image.alpha >= 1.0){
                                tempBool = true
                            }
                        }
                    }), SKAction.waitForDuration(NSTimeInterval(0.1))])), withKey: "animate_coin")
        


        
    }

    
    @IBAction func startGame() {
        
    /*    let scene = StartGame(size: self.size)
        scene.highscore = score
        view?.presentScene(scene)*/
        
        let scene = LevelMenu(size: self.size)
        view?.presentScene(scene)
        
        
    }
    
    @IBAction func highScore_action() {
        
        /*    let scene = StartGame(size: self.size)
        scene.highscore = score
        view?.presentScene(scene)*/
        
        let scene = Highscore(size: self.size)
        view?.presentScene(scene)
        
        
    }
    
     override func willMoveFromView(view: SKView) {
        removeAllActions()
        for view in view.subviews {
            view.removeFromSuperview()
        }
    }
    
    }
    
    

