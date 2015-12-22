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
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate // Create reference to the app delegate
    
    var bgImage = SKSpriteNode(imageNamed: "sprites/background2")
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
    
    
    var SIZE_LABEL_HS:CGFloat = 40.0
    var SIZE_LABAL_MODE:CGFloat = 20.0
    var SIZE_LABEL_SCORE:CGFloat = 15.0
    
    var X_POSITION_LABEL_HS:CGFloat = 0.0
    var Y_POSITION_LABEL_HS:CGFloat = 210.0
    
    var X_POSITION_LABEL_MODE:CGFloat = 80.0
    var Y_POSITION_LABEL_MODE:CGFloat = 150.0
    
    
    var DISTANCE_BETWEEN_SCORE:CGFloat = 40.0
    var DISTANCE_X_SEPARATOR:CGFloat =  50.0
    
    var DISTANCE_X_SEPARATOR_RESET:CGFloat = 6.0
    
    var SIZE_RESET_BUTTON_WIDTH:CGFloat = 100.0
    var SIZE_RESET_BUTTON_HEIGHT:CGFloat = 80.0
    
    
    // New format for number 12/20/2015
    // Example:  1234 -> 1,234
    let numberFormatter = NSNumberFormatter()

       override func didMoveToView(view: SKView) {
       
      /*  let y_up_bound:CGFloat = self.appDelegate.screenSize.height/2
        let y_down_bound:CGFloat = -self.appDelegate.screenSize.height/2
        let x_left_bound:CGFloat = -self.appDelegate.screenSize.width/2
        let x_right_bound:CGFloat = self.appDelegate.screenSize.width/2*/
        
        /*     print(y_up_bound)
        print(y_down_bound)
        print(x_left_bound)
        print(x_right_bound)
        print("aspect ratio: \(aspect_ratio)")*/
        
        
        let aspect_ratio:CGFloat = self.appDelegate.screenSize.width/self.appDelegate.screenSize.height
        
        if (aspect_ratio > 0.563){
            fixRatio(aspect_ratio)
        }
        
   
        // Load score from pList
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let fullPathName = documentDirectory.stringByAppendingPathComponent("dodger.plist") as String
        
        let plistFile = NSDictionary(contentsOfFile:fullPathName)
        
        let hs_insane = plistFile!.objectForKey("Highscore_Insane") as! NSArray
        let hs_classic = plistFile!.objectForKey("Highscore_Classic") as! NSArray
        
            self.anchorPoint = CGPointMake(0.5, 0.5)
        
        //load background
        self.bgImage.size = self.frame.size
        self.bgImage.position = CGPointMake( 0, 0)
        self.bgImage.name = "bground"
        self.addChild(bgImage)
        
        // Label HS
        Label_Highscore.text = "Highscores"
        Label_Highscore.fontSize = SIZE_LABEL_HS
        Label_Highscore.fontColor = SKColor.blackColor()
        Label_Highscore.position = CGPoint(x: X_POSITION_LABEL_HS, y: Y_POSITION_LABEL_HS)
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
        reset_classic.size = CGSize(width: SIZE_RESET_BUTTON_WIDTH, height: SIZE_RESET_BUTTON_HEIGHT)
         reset_classic.position = CGPoint(x: -X_POSITION_LABEL_MODE - DISTANCE_X_SEPARATOR_RESET, y: Y_POSITION_LABEL_MODE - DISTANCE_BETWEEN_SCORE * 6)
         addChild(reset_classic)
        // Reset Insane
        let reset_insane = SKSpriteNode(imageNamed: "sprites/reset_button")
        reset_insane.name = "reset_insane"
        reset_insane.size = CGSize(width: SIZE_RESET_BUTTON_WIDTH, height: SIZE_RESET_BUTTON_HEIGHT)
        reset_insane.position = CGPoint(x: X_POSITION_LABEL_MODE + DISTANCE_X_SEPARATOR_RESET, y: Y_POSITION_LABEL_MODE - DISTANCE_BETWEEN_SCORE * 6)
        addChild(reset_insane)
        
        
        let backLabel = SKLabelNode(fontNamed: "Courier")
        backLabel.text = "Back"
        backLabel.name = "restart"
        backLabel.fontSize = 20
        backLabel.fontColor = SKColor.blackColor()
        backLabel.position = CGPoint(x: 0, y: Y_POSITION_LABEL_MODE - DISTANCE_BETWEEN_SCORE * 8)
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
    
    func fixRatio(curr_ratio:CGFloat){
    /*     SIZE_LABEL_HS  = 40.0
        SIZE_LABAL_MODE = 20.0
        SIZE_LABEL_SCORE = 15.0
        
        X_POSITION_LABEL_MODE = 80.0
        Y_POSITION_LABEL_MODE = 150.0
        
        
       DISTANCE_BETWEEN_SCORE = 40.0
        DISTANCE_X_SEPARATOR =  50.0*/
        
        var RATIO:CGFloat = 1.0
        
        if (curr_ratio > 0.6){
           // RATIO = 0.7143
            RATIO =  0.6333
        }
        else{
           // RATIO = 0.61
             RATIO = 0.76
        }
        
        Y_POSITION_LABEL_HS *= RATIO
        X_POSITION_LABEL_MODE *= RATIO
        Y_POSITION_LABEL_MODE *= RATIO
        
        DISTANCE_BETWEEN_SCORE = DISTANCE_BETWEEN_SCORE * RATIO  + 5.0
        
        DISTANCE_X_SEPARATOR_RESET = DISTANCE_X_SEPARATOR_RESET * RATIO
        
        SIZE_RESET_BUTTON_HEIGHT *= RATIO
        SIZE_RESET_BUTTON_WIDTH *= RATIO

  
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