//
//  Highscore.swift
//  Dodger Me!
//
//  Created by Guan Wong on 12/19/15.
//  Copyright © 2015 Guan Wong. All rights reserved.
//

import SpriteKit

class Highscore: SKScene {
    
    //    deinit{
    //        print(" highscore being deInitialized.");
    
    //    }
    
    var bgImage = SKSpriteNode(imageNamed: "sprites/background")
    var label_Classic = SKLabelNode(fontNamed: "Chalkduster")
    var label_Insane = SKLabelNode(fontNamed: "Chalkduster")
    var Label_Highscore = SKLabelNode(fontNamed: "Chalkduster")
    
    var label_classic_1 = SKLabelNode(fontNamed: "Chalkduster")
    var label_classic_2 = SKLabelNode(fontNamed: "Chalkduster")
    var label_classic_3 = SKLabelNode(fontNamed: "Chalkduster")
    var label_classic_4 = SKLabelNode(fontNamed: "Chalkduster")
    var label_classic_5 = SKLabelNode(fontNamed: "Chalkduster")
    
    var label_insane_1 = SKLabelNode(fontNamed: "Chalkduster")
    var label_insane_2 = SKLabelNode(fontNamed: "Chalkduster")
    var label_insane_3 = SKLabelNode(fontNamed: "Chalkduster")
    var label_insane_4 = SKLabelNode(fontNamed: "Chalkduster")
    var label_insane_5 = SKLabelNode(fontNamed: "Chalkduster")
    
    
    let SIZE_LABEL_HS:CGFloat = 40.0
    let SIZE_LABAL_MODE:CGFloat = 20.0
    let SIZE_LABEL_SCORE:CGFloat = 15.0
    
    let X_POSITION_LABEL_MODE:CGFloat = 80.0
    let Y_POSITION_LABEL_MODE:CGFloat = 150.0
    
    
    let DISTANCE_BETWEEN_SCORE:CGFloat = 40.0
    let DISTANCE_X_SEPARATOR:CGFloat =  50.0
    
    // New format for number 12/20/2015
    // Example:  1234 -> 1,234
    let numberFormatter = NSNumberFormatter()

       override func didMoveToView(view: SKView) {
       
        // Load score from pList
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let fullPathName = documentDirectory.stringByAppendingPathComponent("dodger.plist") as String
        
        let plistFile = NSDictionary(contentsOfFile:fullPathName)
        
        let hs_insane = plistFile!.objectForKey("Highscore_Insane") as! NSArray
        let hs_classic = plistFile!.objectForKey("Highscore_Classic") as! NSArray
        
                self.anchorPoint = CGPointMake(0.5, 0.5)
        
        //load background
        self.bgImage.position = CGPointMake( 0, 0)
        self.bgImage.name = "bground"
        self.addChild(bgImage)
        
        // Label HS
        Label_Highscore.text = "Highscores"
        Label_Highscore.fontSize = SIZE_LABEL_HS
        Label_Highscore.fontColor = SKColor.blackColor()
        Label_Highscore.position = CGPoint(x: 0, y: 210)
        addChild(Label_Highscore)
        
        // Label Mode
        label_Classic.text = "Classic"
        label_Classic.fontSize = SIZE_LABAL_MODE
        label_Classic.fontColor = SKColor.blackColor()
        label_Classic.position = CGPoint(x: -X_POSITION_LABEL_MODE, y: Y_POSITION_LABEL_MODE)
        addChild(label_Classic)
        
        label_Insane.text = "Insane"
        label_Insane.fontSize = SIZE_LABAL_MODE
        label_Insane.fontColor = SKColor.blackColor()
        label_Insane.position = CGPoint(x: X_POSITION_LABEL_MODE, y: Y_POSITION_LABEL_MODE)
        addChild(label_Insane)
        
        // Label Classic Scores
        label_classic_1.text = "1. \(formatScore(hs_classic.objectAtIndex(0) as! Int))"
        label_classic_1.fontSize = SIZE_LABEL_SCORE
        label_classic_1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        label_classic_1.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom;
        label_classic_1.fontColor = SKColor.blackColor()
        label_classic_1.position = CGPoint(x: -X_POSITION_LABEL_MODE - DISTANCE_X_SEPARATOR, y: Y_POSITION_LABEL_MODE - DISTANCE_BETWEEN_SCORE)
        addChild(label_classic_1)
        
        label_classic_2.text = "2. \(formatScore(hs_classic.objectAtIndex(1) as! Int))"
        label_classic_2.fontSize = SIZE_LABEL_SCORE
        label_classic_2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        label_classic_2.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom;
        label_classic_2.fontColor = SKColor.blackColor()
        label_classic_2.position = CGPoint(x: -X_POSITION_LABEL_MODE - DISTANCE_X_SEPARATOR, y: Y_POSITION_LABEL_MODE - DISTANCE_BETWEEN_SCORE * 2)
        addChild(label_classic_2)
        
        
        label_classic_3.text = "3. \(formatScore(hs_classic.objectAtIndex(2) as! Int))"
        label_classic_3.fontSize = SIZE_LABEL_SCORE
        label_classic_3.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        label_classic_3.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom;
        label_classic_3.fontColor = SKColor.blackColor()
        label_classic_3.position = CGPoint(x: -X_POSITION_LABEL_MODE - DISTANCE_X_SEPARATOR, y: Y_POSITION_LABEL_MODE - DISTANCE_BETWEEN_SCORE * 3)
        addChild(label_classic_3)
        
        label_classic_4.text = "4. \(formatScore(hs_classic.objectAtIndex(3) as! Int))"
        label_classic_4.fontSize = SIZE_LABEL_SCORE
        label_classic_4.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        label_classic_4.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom;
        label_classic_4.fontColor = SKColor.blackColor()
        label_classic_4.position = CGPoint(x: -X_POSITION_LABEL_MODE - DISTANCE_X_SEPARATOR, y: Y_POSITION_LABEL_MODE - DISTANCE_BETWEEN_SCORE * 4)
        addChild(label_classic_4)
        
        label_classic_5.text = "5. \(formatScore(hs_classic.objectAtIndex(4) as! Int))"
        label_classic_5.fontSize = SIZE_LABEL_SCORE
        label_classic_5.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        label_classic_5.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom;
        label_classic_5.fontColor = SKColor.blackColor()
        label_classic_5.position = CGPoint(x: -X_POSITION_LABEL_MODE - DISTANCE_X_SEPARATOR, y: Y_POSITION_LABEL_MODE - DISTANCE_BETWEEN_SCORE * 5)
        addChild(label_classic_5)
        
        // Label Insane Scores
        label_insane_1.text = "1. \(formatScore(hs_insane.objectAtIndex(0) as! Int))"
        label_insane_1.fontSize = SIZE_LABEL_SCORE
        label_insane_1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        label_insane_1.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom;
        label_insane_1.fontColor = SKColor.blackColor()
        label_insane_1.position = CGPoint(x: X_POSITION_LABEL_MODE - DISTANCE_X_SEPARATOR, y: Y_POSITION_LABEL_MODE - DISTANCE_BETWEEN_SCORE)
        addChild(label_insane_1)
        
        label_insane_2.text = "2. \(formatScore(hs_insane.objectAtIndex(1) as! Int))"
        label_insane_2.fontSize = SIZE_LABEL_SCORE
        label_insane_2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        label_insane_2.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom;
        label_insane_2.fontColor = SKColor.blackColor()
        label_insane_2.position = CGPoint(x: X_POSITION_LABEL_MODE - DISTANCE_X_SEPARATOR, y: Y_POSITION_LABEL_MODE - DISTANCE_BETWEEN_SCORE * 2)
        addChild(label_insane_2)
        
        
        label_insane_3.text = "3. \(formatScore(hs_insane.objectAtIndex(2) as! Int))"
        label_insane_3.fontSize = SIZE_LABEL_SCORE
        label_insane_3.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        label_insane_3.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom;
        label_insane_3.fontColor = SKColor.blackColor()
        label_insane_3.position = CGPoint(x: X_POSITION_LABEL_MODE - DISTANCE_X_SEPARATOR, y: Y_POSITION_LABEL_MODE - DISTANCE_BETWEEN_SCORE * 3)
        addChild(label_insane_3)
        
        label_insane_4.text = "4. \(formatScore(hs_insane.objectAtIndex(3) as! Int))"
        label_insane_4.fontSize = SIZE_LABEL_SCORE
        label_insane_4.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        label_insane_4.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom;
        label_insane_4.fontColor = SKColor.blackColor()
        label_insane_4.position = CGPoint(x: X_POSITION_LABEL_MODE - DISTANCE_X_SEPARATOR, y: Y_POSITION_LABEL_MODE - DISTANCE_BETWEEN_SCORE * 4)
        addChild(label_insane_4)
        
        label_insane_5.text = "5. \(formatScore(hs_insane.objectAtIndex(4) as! Int))"
        label_insane_5.fontSize = SIZE_LABEL_SCORE
        label_insane_5.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        label_insane_5.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom;
        label_insane_5.fontColor = SKColor.blackColor()
        label_insane_5.position = CGPoint(x: X_POSITION_LABEL_MODE - DISTANCE_X_SEPARATOR, y: Y_POSITION_LABEL_MODE - DISTANCE_BETWEEN_SCORE * 5)
        addChild(label_insane_5)
        
        // Reset Classic
        let reset_classic = SKSpriteNode(imageNamed: "sprites/reset_button")
        reset_classic.name = "reset_classic"
        reset_classic.size = CGSize(width: 100, height: 80)
         reset_classic.position = CGPoint(x: -X_POSITION_LABEL_MODE - 15, y: Y_POSITION_LABEL_MODE - DISTANCE_BETWEEN_SCORE * 6)
         addChild(reset_classic)
        // Reset Insane
        let reset_insane = SKSpriteNode(imageNamed: "sprites/reset_button")
        reset_insane.name = "reset_insane"
        reset_insane.size = CGSize(width: 100, height: 80)
        reset_insane.position = CGPoint(x: X_POSITION_LABEL_MODE - 15, y: Y_POSITION_LABEL_MODE - DISTANCE_BETWEEN_SCORE * 6)
        addChild(reset_insane)
        
        
        let backLabel = SKLabelNode(fontNamed: "Courier")
        backLabel.text = "Back"
        backLabel.name = "restart"
        backLabel.fontSize = 20
        backLabel.fontColor = SKColor.blackColor()
        backLabel.position = CGPoint(x: 0, y: -view.center.y/2)
        self.addChild(backLabel)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let location = (touch ).locationInNode(self)
            let sprite = self.nodeAtPoint(location)
            if ( sprite.name == "restart"){
                backGameScene()
            }
            else if (sprite.name == "reset_classic"){
                reset_score("classic")
            }
            else if (sprite.name == "reset_insane"){
                reset_score("insane")
            }
            
        }
    }
    
    func formatScore(value:Int) -> String{
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        if (value > 0){
        return String(numberFormatter.stringFromNumber(value as NSNumber)!)
        }
        else{
            return "-"
        }
    }
    
    func backGameScene(){
        let scene = GameScene(size: self.size)
            self.view?.presentScene(scene)
    }
    
    func reset_score(mode:String){
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let fullPathName = documentDirectory.stringByAppendingPathComponent("dodger.plist") as String
        let virtualPlist = NSMutableDictionary(contentsOfFile:fullPathName)
         let sourceFilePath = NSBundle.mainBundle().pathForResource("dodger", ofType: "plist")
          let originalPlist = NSMutableDictionary(contentsOfFile:sourceFilePath!)
        
        var game_mode:String?
        
        if (mode == "classic"){
            game_mode = "Highscore_Classic"
        }
        else if (mode == "insane"){
            game_mode = "Highscore_Insane"
        }
        
        let originalFile_Object = originalPlist?.objectForKey(game_mode!)
        
        virtualPlist?.setObject(originalFile_Object!, forKey: game_mode!)
        
        if !virtualPlist!.writeToFile(fullPathName, atomically: false){
            print("FILE FAILED TO SAVE THE CHANGES ---- PLEASE FIX IT IN GameViewController")
        }

        // to update
        restart_scene()
    }
    
    func restart_scene(){
        let scene = Highscore(size: self.size)
        self.view?.presentScene(scene)
    }
    
    
    
}