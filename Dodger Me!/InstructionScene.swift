//
//  InstructionScene.swift
//  Dodger Me!
//
//  Created by Guan Wong on 3/30/16.
//  Copyright © 2016 Guan Wong. All rights reserved.
//


import SpriteKit

class InstructionScene: SKScene{
    
   /* deinit{
        print(" instructionScene being deInitialized.");
        
    }
    */
    // SEMI - CONSTANTS
    var modeOption = 1  // good|bad options
    var BUTTON_WIDTH:CGFloat = 70
    var BUTTON_HEIGHT:CGFloat = 45
    var LETTER_SIZE:CGFloat = 20
    var X_NEXT_PREV_FIX:CGFloat = 70
    var Y_NEXT_PREV_FIX:CGFloat = 150
    var IMAGE_WIDTH:CGFloat = 70
    var IMAGE_HEIGHT:CGFloat = 70
    var IMAGE_Y_POSITION:CGFloat = 420
    var BORDER_WIDTH:CGFloat = 150
    var BORDER_HEIGHT:CGFloat = 150
    var SWITCH_Y_POSITION:CGFloat = 185
    var BACK_BUTTON_X_POSITION:CGFloat = 75
    var BACK_BUTTON_Y_POSITION:CGFloat = 85
    
    var XHelper = 0;
    var YHelper = 0;
    var goodTrack = 0
    var badTrack = 0
    var currType = "good"
    let image = SKSpriteNode()
    
    //Button
    let switchButton = UIButton()
    let previousButton = UIButton()
    let nextButton = UIButton()
    
    // array of good&bad
    var goodArray:[String] = ["sprites/powerUps/life", "sprites/cloud/white_cloud_1", "sprites/powerUps/imuneItem", "sprites/powerUps/right_arrow"]
    var badArray:[String] = ["sprites/fireball/fireBall", "sprites/draggy/d_001", "sprites/cloud/grey_cloud_2"]
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate // Create reference to the app delegate
    var bground = SKSpriteNode(imageNamed: "sprites/background2.png")
    override func didMoveToView(view: SKView){
        
        let aspect_ratio:CGFloat = self.appDelegate.screenSize.width/self.appDelegate.screenSize.height
        
        if (aspect_ratio > 0.563){
            fixRatio(aspect_ratio)
        }
        
        self.backgroundColor = SKColor.lightGrayColor()
        loadBackground()
        loadButtons()
        loadImage()
    }
    
    func loadBackground(){
        bground.size = self.frame.size
        bground.position = CGPoint(x: appDelegate.screenSize.width/2, y: appDelegate.screenSize.height/2)
        self.addChild(bground)
    }
    
    func loadButtons(){
        // back button
        
        let backButton = UIButton (frame: CGRectMake(0,0,CGFloat(BUTTON_WIDTH),CGFloat(BUTTON_HEIGHT)))
        backButton.center = CGPointMake(BACK_BUTTON_X_POSITION, BACK_BUTTON_Y_POSITION)
        backButton.setTitle("BACK", forState: .Normal)
        backButton.titleLabel?.font = UIFont(name: "Chalkduster", size: LETTER_SIZE)
        backButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        backButton.backgroundColor = UIColor.darkGrayColor()
        backButton.addTarget(self, action: "back", forControlEvents: .TouchUpInside)
        backButton.layer.cornerRadius = 5.0
        view!.addSubview(backButton)
        
        // Good/Bad button
        switchButton.frame = CGRect(x: 0, y: 0, width: CGFloat(BUTTON_WIDTH), height: CGFloat(BUTTON_HEIGHT))
        switchButton.center = CGPointMake(view!.center.x, SWITCH_Y_POSITION)
        switchButton.setTitle("GOOD", forState: .Normal)
        switchButton.titleLabel?.font = UIFont(name: "Chalkduster", size: LETTER_SIZE)
        switchButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        switchButton.backgroundColor = UIColor.darkGrayColor()
        switchButton.addTarget(self, action: "switcher", forControlEvents: .TouchDown)
        switchButton.layer.cornerRadius = 5.0
        view!.addSubview(switchButton)
        
        // Previous Button
        previousButton.frame = CGRect(x: 0, y: 0, width: CGFloat(BUTTON_WIDTH), height: CGFloat(BUTTON_HEIGHT))
        previousButton.center = CGPointMake(view!.center.x - X_NEXT_PREV_FIX, view!.center.y + Y_NEXT_PREV_FIX)
        previousButton.setTitle("PREV", forState: .Normal)
        previousButton.titleLabel?.font = UIFont(name: "Chalkduster", size: LETTER_SIZE)
        previousButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        previousButton.backgroundColor = UIColor.darkGrayColor()
        previousButton.addTarget(self, action: "prev", forControlEvents: .TouchDown)
        previousButton.hidden = true
        view!.addSubview(previousButton)
        
        // Next Button
        nextButton.frame = CGRect(x: 0, y: 0, width: CGFloat(BUTTON_WIDTH), height: CGFloat(BUTTON_HEIGHT))
        nextButton.center = CGPointMake(view!.center.x + X_NEXT_PREV_FIX, view!.center.y + Y_NEXT_PREV_FIX)
        nextButton.setTitle("NEXT", forState: .Normal)
        nextButton.titleLabel?.font = UIFont(name: "Chalkduster", size: LETTER_SIZE)
        nextButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        nextButton.backgroundColor = UIColor.darkGrayColor()
        nextButton.addTarget(self, action: "next", forControlEvents: .TouchDown)
        view!.addSubview(nextButton)
        
    
    }
    
    func loadImage(){
        
        image.texture = SKTexture(imageNamed: goodArray[0])
        image.size = CGSize(width: IMAGE_WIDTH, height: IMAGE_HEIGHT)
        image.position = CGPoint(x: view!.center.x, y: IMAGE_Y_POSITION)
        self.addChild(image)
        
        let border = SKSpriteNode()
        border.texture = SKTexture(imageNamed: "sprites/border")
        border.size = CGSize(width: BORDER_WIDTH, height: BORDER_HEIGHT)
        border.position = CGPoint(x: view!.center.x, y: IMAGE_Y_POSITION)
        self.addChild(border)
    }
    
    func updateImage (){
        
        var imgName:String = ""
        
        if (currType == "good"){
            imgName = goodArray[goodTrack]
        }
        else if (currType == "bad"){
            imgName = badArray[badTrack]
        }
        
        image.removeAllActions()
        if ( imgName.containsString("draggy")){
            actionCall("draggy")
        }
        else if( imgName.containsString("white")){
            actionCall("white")
        }
        else if( imgName.containsString("grey")){
            actionCall("grey")
        }
        else if( imgName.containsString("arrow")){
            actionCall("arrow")
        }
        else{
         image.texture = SKTexture(imageNamed: "\(imgName)")
        }
    }
    
    func updateButton(){
        if ( currType == "good"){
            if ( goodTrack == 0){
                previousButton.hidden = true
                nextButton.hidden = false
            }
            else if ( goodTrack == goodArray.count - 1){
                nextButton.hidden = true
                previousButton.hidden = false
            }
            else if ( goodTrack >= 1 && goodTrack <= goodArray.count - 2){
                previousButton.hidden = false
                nextButton.hidden = false
            }
        }
            
        else if(currType == "bad"){
            if ( badTrack == 0){
                previousButton.hidden = true
                nextButton.hidden = false
            }
            else if ( badTrack == badArray.count - 1){
                nextButton.hidden = true
                previousButton.hidden = false
            }
            else if ( badTrack >= 1 && badTrack <= badArray.count - 2){
                previousButton.hidden = false
                nextButton.hidden = false
            }
        }
    }
    
    func actionCall(op:String){
        
        let whiteAnimation = SKAction.animateWithTextures( [SKTexture(imageNamed: "sprites/cloud/white_cloud_1"),SKTexture(imageNamed: "sprites/cloud/white_cloud_2"), SKTexture(imageNamed: "sprites/cloud/grey_cloud_1"), ], timePerFrame: 0.8)
        
        let greyAnimation = SKAction.animateWithTextures( [SKTexture(imageNamed: "sprites/cloud/grey_cloud_2"), SKTexture(imageNamed: "sprites/cloud/grey_cloud_3") ], timePerFrame: 0.8)
        
        let draggyAnimation = SKAction.animateWithTextures( [SKTexture(imageNamed: "sprites/draggy/d_001"),SKTexture(imageNamed: "sprites/draggy/d_002"),SKTexture(imageNamed: "sprites/draggy/d_003"), SKTexture(imageNamed: "sprites/draggy/d_004")], timePerFrame: 0.1)
        
        let arrowAnimation = SKAction.animateWithTextures( [SKTexture(imageNamed: "sprites/powerUps/down_arrow"),SKTexture(imageNamed: "sprites/powerUps/up_arrow"), SKTexture(imageNamed: "sprites/powerUps/left_arrow"), SKTexture(imageNamed: "sprites/powerUps/right_arrow")], timePerFrame: 0.5)
        
        switch (op){
        case "draggy":
            image.runAction(SKAction.repeatActionForever(draggyAnimation), withKey: "draggy")
            break
        case "white":
             image.runAction(SKAction.repeatActionForever(whiteAnimation), withKey: "white")
            break
        case "grey":
            image.runAction(SKAction.repeatActionForever(greyAnimation), withKey: "grey")
            break
        case "arrow":
            image.runAction(SKAction.repeatActionForever(arrowAnimation), withKey: "arrow")
            break
        default:
            break
        }
       
        
        
        
    }
    @IBAction func back(){
        image.removeAllActions()
        
        let scene = GameScene(size: self.size)
        view?.presentScene(scene)
    }
    
    @IBAction func switcher(){
        modeOption *= -1
        
        if ( modeOption == 1){
           switchButton.setTitle("GOOD", forState: .Normal)
            currType = "good"
        }
        else{
            switchButton.setTitle("BAD", forState: .Normal)
            currType = "bad"
        }
         updateButton()
        updateImage()
    }
    
    @IBAction func prev(){
        
        if ( currType == "good"){
            goodTrack--
            if (goodTrack < 0 ){
                goodTrack = 0
                return
            }
        }
        
        else if(currType == "bad"){
            badTrack--
            if (badTrack < 0 ){
                badTrack = 0
                return
            }
        }
        
       updateButton()
       updateImage()
        
    }
    
    @IBAction func next(){
        
        previousButton.hidden = false
        
        if ( currType == "good"){
            goodTrack++
            if (goodTrack > goodArray.count - 1){
                goodTrack = goodArray.count - 1
                return
            }
        }
            
        else if(currType == "bad"){
            badTrack++
            if (badTrack > badArray.count - 1 ){
                badTrack = badArray.count - 1
                return
            }
        }
        
        updateButton()
        updateImage()
    }
    
    
    func fixRatio(curr_ratio:CGFloat){
        //  print("THE RATIO IS: \(curr_ratio)")
        
        var RATIO:CGFloat = 1.0
        
        if (curr_ratio > 0.6){
            RATIO = 0.6333
        }
            
        else if (curr_ratio >= 0.562 && curr_ratio < 0.563){
            RATIO = 0.9
        }
        else{
            RATIO = 0.76
        }
     
        BUTTON_WIDTH *= RATIO
        BUTTON_HEIGHT *= RATIO
        LETTER_SIZE *= RATIO
        X_NEXT_PREV_FIX *= RATIO
        Y_NEXT_PREV_FIX *= RATIO
        
        IMAGE_WIDTH *= RATIO
        IMAGE_HEIGHT *= RATIO
        IMAGE_Y_POSITION *= RATIO
        BORDER_WIDTH *= RATIO
        BORDER_HEIGHT *= RATIO
        SWITCH_Y_POSITION *= RATIO
        
        BACK_BUTTON_X_POSITION *= RATIO
        BACK_BUTTON_Y_POSITION *= RATIO
    }

}

/*
XHelper += 2
switchButton.center.x = CGFloat(XHelper)

print(XHelper)
*/

  