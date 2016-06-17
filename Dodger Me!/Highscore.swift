//
//  Highscore.swift
//  Dodger Me!
//
//  Created by Guan Wong on 12/19/15.
//  Copyright © 2015 Guan Wong. All rights reserved.
//

import SpriteKit

class Highscore: SKScene, MessageMenuDelegate {
    
    //    deinit{
    //        print(" highscore being deInitialized.");
    
    //    }
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate // Create reference to the app delegate
    
    var bgImage = SKSpriteNode(imageNamed: "sprites/background2")
    var label_Classic = SKLabelNode(fontNamed: "Chalkduster")
    var label_Insane = SKLabelNode(fontNamed: "Chalkduster")
    var Label_Highscore = SKLabelNode(fontNamed: "Chalkduster")
    
    var pauseGameViewController = PauseMenuController()
    var messageWindowViewController = MessageMenuController()
    var freeze = false

    
    
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
    
    var curr_mode:String? // for MessageMenu -> used for reseting mode
    
    // New format for number 12/20/2015
    // Example:  1234 -> 1,234
    let numberFormatter = NSNumberFormatter()

       override func didMoveToView(view: SKView) {
        
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
        
        // Using for loop to create labels 4/3/2016
        for nums in 1...5 {
             // Label Classic Scores
            let new_label_classic = SKLabelNode(fontNamed: "Chalkduster")
            new_label_classic.text = "\(nums). \(formatScore(hs_classic.objectAtIndex(nums - 1) as! Int))"
            new_label_classic.fontSize = SIZE_LABEL_SCORE
            new_label_classic.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            new_label_classic.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom;
            new_label_classic.fontColor = SKColor.blackColor()
            new_label_classic.position = CGPoint(x: -X_POSITION_LABEL_MODE - DISTANCE_X_SEPARATOR, y: Y_POSITION_LABEL_MODE - DISTANCE_BETWEEN_SCORE * CGFloat(nums))
            addChild(new_label_classic)
            
             // Label Insane Scores
            let new_label_insane = SKLabelNode(fontNamed: "Chalkduster")
            new_label_insane.text = "\(nums). \(formatScore(hs_insane.objectAtIndex(nums - 1) as! Int))"
            new_label_insane.fontSize = SIZE_LABEL_SCORE
            new_label_insane.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            new_label_insane.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom;
            new_label_insane.fontColor = SKColor.blackColor()
            new_label_insane.position = CGPoint(x: X_POSITION_LABEL_MODE - DISTANCE_X_SEPARATOR, y: Y_POSITION_LABEL_MODE - DISTANCE_BETWEEN_SCORE * CGFloat(nums))
            addChild(new_label_insane)
        }
        
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
        
        if(!self.freeze){
        for touch in touches {
            let location = touch.locationInNode(self)
            let sprite = self.nodeAtPoint(location)
            
            if ( sprite.name == "restart"){
                backGameScene()
            }
            else if (sprite.name == "reset_classic"){
                messageWindow("classic")
            }
            else if (sprite.name == "reset_insane"){
                messageWindow("insane")
            }
            
        }
        }
    }
    
    func fixRatio(curr_ratio:CGFloat){
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
        // remove strong reference
         messageWindowViewController.delegate = nil
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
    
    func messageWindow(mode: String) {
        
        messageWindowViewController.delegate = self
        messageWindowViewController.setMode(mode)
        messageWindowViewController.label.text = "Reset \(mode)\nHighscore?"
        
        let scene = messageWindowViewController.view
        
        curr_mode = mode
        setFreezeMode(true)
        view?.addSubview(scene)
        
    }
    
    func setFreezeMode(f: Bool){
        self.freeze = f
    }
    
    @IBAction func pauseGame() {
        view?.addSubview(pauseGameViewController.view)
    }
    

    
    
}