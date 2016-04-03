//
//  StartGame.swift
//  Dodger Me!
//
//  Created by Guan Wong on 2/3/15.
//  Copyright (c) 2015 Guan Wong. All rights reserved.
//


/*
THIS IS WHEN THE GAME START


*/


import SpriteKit
import iAd
//import UIKit


/*
**  For colision detection
**
*/
struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let Imune       : UInt32 = UInt32.max
    static let Player   :UInt32 = 0b1
    static let Fire   : UInt32 = 0b100
    static let Dragon : UInt32 = 0b100
    static let Food : UInt32 = 0b1000
    static let Cloud : UInt32 = 0b10000
    static let Wall : UInt32 = 0b11
    
}

/*  NEW ADDED 11/29/2015
**
** Now the player has a struct
** Easier to manage the player
*/
struct Player{
    var HP:Int?
    var isInvincible:Bool?
    var playerImage:SKSpriteNode
   // var isTouched:Bool = false -> removed
    var isTouchable:Bool = true
    var initPosition:CGPoint?
}

/*
**  Extension is to extend the struct
** Added to practice it.. since it might be useful in later apps
*/
extension Player{
    init (playerImage:SKSpriteNode){
        self.playerImage = SKSpriteNode()
    }
    func load(){
        // in the future... i can use like load("name of image")
        self.playerImage.size = CGSize(width: 30, height: 30)
        self.playerImage.texture = SKTexture(imageNamed: "sprites/player/player_full")
        self.playerImage.name = "player"
        self.playerImage.position = CGPointMake( 0, 0)
    }
    func materializeBody(){
        // Setting a physical body to the player
       // playerImage.physicsBody = SKPhysicsBody(rectangleOfSize: playerImage.size)
     //   playerImage.physicsBody = SKPhysicsBody(circleOfRadius: playerImage.size.width/2 + 2, center: CGPoint(x: playerImage.position.x, y: playerImage.position.y - 1))
       
        playerImage.physicsBody =  SKPhysicsBody(texture: playerImage.texture!, size: playerImage.size)
        playerImage.physicsBody?.dynamic = true // allow physic simulation to move it
        playerImage.physicsBody!.allowsRotation = false // not allow it to rotate
       playerImage.physicsBody?.categoryBitMask = PhysicsCategory.Player
     //   playerImage.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
}


struct Object{
   
    var objImage:SKSpriteNode = SKSpriteNode()
    var type:Int?;
    var delay:CGFloat = 0.0  // delay for spawining the object
    var current_speed_rate:CGFloat = 1   // initial/current speed
    var max_speed_rate:CGFloat = 0.4
    
    
  /*  init (imgName:String){
        self.objImage.size = CGSize(width: 20, height: 20)
        self.objImage.texture = SKTexture(imageNamed: "\(imgName)")
        self.objImage.name = "unknownForNow"
        self.objImage.position = CGPointMake( 0, 0)
    }*/
    
    mutating func incDelay(amount:CGFloat){
        delay += amount
    }
    mutating func resetDelay(){
        delay = 0.0
    }
}

struct PowerUPS{
    var object:Object
    var isRightArrowEnabled = false
    var isLeftArrowEnabled = false
    var isUpArrowEnabled = false
    var isDownArrowEnabled = false
    var isImuneItemEnabled = false
    
    var buffTime_Up:CGFloat = 0
    var buffTime_Down:CGFloat = 0
    var buffTime_Left:CGFloat = 0
    var buffTime_Right:CGFloat = 0
    var buffTime_imune:CGFloat = 0
  
    
    
    init (){
 object = Object()
    }
    
    mutating func update(){
        if (buffTime_Up <= 0){
            isUpArrowEnabled = false
        }
        else{
            isUpArrowEnabled = true
        }
        
        if (buffTime_Down <= 0 ){
            isDownArrowEnabled = false
        }
        else{
            isDownArrowEnabled = true
        }
        if (buffTime_Left <= 0 ){
            isLeftArrowEnabled = false
        }
        else{
            isLeftArrowEnabled = true
        }
        if (buffTime_Right <= 0 ){
            isRightArrowEnabled = false
        }
        else{
            isRightArrowEnabled = true
        }
        if (buffTime_imune <= 0 ){
            isImuneItemEnabled = false
        }
        else{
            isImuneItemEnabled = true
        }
    }
    
}
/*
** Below I am using the mutating function
** Struct is a value type, and itself is immutable, thus, if we want to
** change the value we have to use the mutating func
** Note: Class = reference type ,  Struct = Value type
*/
struct Scorelabel{
    var node:SKLabelNode =  SKLabelNode(fontNamed: "Courier")  // score board
    var score = 0
    
    func load(x: CGFloat, y: CGFloat){
        // load score
        node.text = "Score: \(score)"
        node.name = "scoring"
        node.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        node.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom;
        node.fontSize = 20
        node.fontColor = SKColor.blackColor()
        node.position = CGPoint(x: -x, y: y)
    }
    
    mutating func setScore(){
        //set score and display it
        score = score + 11
        node.text = "Score: \(score)"
    }

}


class StartGame: SKScene, SKPhysicsContactDelegate, ADBannerViewDelegate, PauseMenuDelegate, ReplayMenuDelegate, ADInterstitialAdDelegate{
    
  /* deinit{
        print("STARTGAME is being deInitialized. REMOVE THIS FUNCTION WHEN IT IS SENDING TO APPSTORE");
    }*/
    
    // Handling case when going to background/foreground
    let notificationCenter = NSNotificationCenter.defaultCenter()
    var movingToBackground:Bool = false
    var isPauseGameCalled:Bool = false
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate // Create reference to the app delegate
    var replayGameViewController = ReplayMenuController()
    var pauseGameViewController = PauseMenuController()
    
    var adBannerView: ADBannerView = ADBannerView()
    var interstitialAds:ADInterstitialAd = ADInterstitialAd()
    var interstitialAdView: UIView = UIView()
    var bgImage = SKSpriteNode(imageNamed: "sprites/background2.png")
    var startCountLabel = SKLabelNode(fontNamed: "Courier")
    let point_image = SKSpriteNode(imageNamed: "sprites/coin")
    var labelCountPoint = SKLabelNode()
    
    // This is to check if the "pausemenu" is open. This avoids creating multiple instances of it when spamming homebotton
   // var isPauseMenuActive:Bool = false
    
    // This will fix the BUG from interstitial ads when not clicked
    var gameover:Bool = false
    
    var gameMode:String? = nil;   // current Level -> this is set up by level selector
  //  var scorePass:Int? = nil;    // minumum score to pass to next level
    var currHighscore:Int?
    var highscore:Int = 0
    var timerCount:Int = 3
    
    
    // Implemented Scorelabel Class
    var scoreBoard = Scorelabel()
    
    // Implemented Player class
    var player = Player(playerImage: SKSpriteNode()) // using extension way
    
    // Implemented Object class 12/15/2015
    var fire = Object()
    var dragon = Object()
    var powerUp = PowerUPS()
    
    // Implemented "constant" values for differents modes 12/18/2015
    var CHANCE_OF_POWERUP:CGFloat? // Percentage of respawing each second
    var MAX_FIRE_RATE:CGFloat?
    var MAX_DRAGON_RATE:CGFloat?
    var RESPAWN_DRAGON_SCORE:Int?
    var INITIAL_FIRE_SPEED_RATE:CGFloat?
    var INITIAL_DRAGON_SPEED_RATE:CGFloat?
    var RATE_SPEED_GROWTH:CGFloat?
    var SPEED_OF_BALL:Double?  // added 12/21/2015
    var SPEED_OF_CLOUD:Double? // added 01/21/2015
   
    
    // Implemented "constants" values to fix the ratio between different iPhones
    var X_POSITION_TOP_LABEL:CGFloat = 150.0
    var Y_POSITION_TOP_LABEL:CGFloat = 300.0
    let FIX_LABEL_Y:CGFloat = 5.0
    
    // Implemented "constants" values to fix the spawn powerups
    var X_MIN_IN_SUBSCREEN: CGFloat = -141
    var X_MAX_IN_SUBSCREEN: CGFloat = 146
    var Y_MAX_IN_SUBSCREEN: CGFloat = 272
    var Y_MIN_IN_SUBSCREEN: CGFloat = -300
    
    
    override func didMoveToView(view: SKView){
        
       
        
   
        view.showsPhysics = false
      //  print("screen width: \(self.appDelegate.screenSize.width)\n")
      //  print("screen height: \(self.appDelegate.screenSize.height)")
               notificationCenter.addObserver(self, selector: "appMovedToBackground", name: UIApplicationWillResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: "appMovedToForeground", name: UIApplicationWillEnterForegroundNotification, object: nil)
        let aspect_ratio:CGFloat = self.appDelegate.screenSize.width/self.appDelegate.screenSize.height
        
        // delete subviews if previous didnt called
        for view in view.subviews {
            view.removeFromSuperview()
        }
        
        self.anchorPoint = CGPointMake(0.5, 0.5)
     
    
        
        //load stage settings
        
        // 1.Classic
        if(gameMode! == "classic"){
            
            CHANCE_OF_POWERUP = 10
            MAX_FIRE_RATE = 0.4 // how often is called
            MAX_DRAGON_RATE = 1.5
            RESPAWN_DRAGON_SCORE = 40000 // default is 40000
            RATE_SPEED_GROWTH = 0.001
            SPEED_OF_BALL = 140
            SPEED_OF_CLOUD = 140
            INITIAL_FIRE_SPEED_RATE = 1.0
            INITIAL_DRAGON_SPEED_RATE = 1.5
            
        }
        // 2.Insane
        else if(gameMode! == "insane"){
            CHANCE_OF_POWERUP = 15  // default is 15
            MAX_FIRE_RATE = 0.2
            MAX_DRAGON_RATE = 1.0
            RESPAWN_DRAGON_SCORE = 30000
            RATE_SPEED_GROWTH = 0.1  // default is 0.003
             SPEED_OF_BALL = 140
            SPEED_OF_CLOUD = 140
            INITIAL_FIRE_SPEED_RATE = 1.0
            INITIAL_DRAGON_SPEED_RATE = 1.5
        }
        
        // fix ratios
        if (aspect_ratio != 0.5625){
            fixRatio(aspect_ratio)
        }
       
        // load delegates
        // delegate for Unpause scene
        pauseGameViewController.delegate = self

        // load ads
        loadiAd()
        // load objects and other stuff

    
   
        load();

        
        // Counts from 3 to 0 and starts showing enemies
      startCountLabel.runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(startCount),
                SKAction.waitForDuration(NSTimeInterval(1)), SKAction.scaleTo(1.0, duration: 0.2)
                ])
            ), withKey: "start_count")
    
    }
    
    func appMovedToBackground (){
     //   print("appMovedToBackground CALLED")
   //     view?.paused = true
        movingToBackground = true
    }
    
    func appMovedToForeground(){
       // print("appMovedToForeground CALLED")
        
          self.movingToBackground = false
        
        if (!isPauseGameCalled && !gameover){
            
        runAction(SKAction.runBlock({
            self.pauseGame()
            sleep(1)
        }))}
        
       /* runAction(SKAction.sequence([
            SKAction.waitForDuration(NSTimeInterval(0.01)),   SKAction.runBlock(pauseGame),
            ]))*/
        
    }
    
    func getValuesInPlistFile(){
    
        // this works -- RETRIEVING STUFF FROM THE DEFAULT PLIST ( CAN BE USED FOR RESET )
        /*
        let filePath = NSBundle.mainBundle().pathForResource("dodger", ofType: "plist")!
        let stylesheet = NSDictionary(contentsOfFile:filePath)
        let filename = "Highscore_Classic"
        let hs:Double = stylesheet!.valueForKeyPath(filename) as! Double
        print("finally we got this: \(hs)")*/
        
    }
        
    
    
    func loadiAd(){
       
        
        /*
        ** Remove this function and put in another place.
        ** So it can be used multiple times in a single game
        */
        
        adBannerView = ADBannerView(frame: CGRect.zero)
        adBannerView.delegate = self
        adBannerView.center = CGPoint(x: adBannerView.center.x, y: view!.bounds.size.height - adBannerView.frame.size.height / 2)
        view!.addSubview(adBannerView)
         adBannerView.hidden = true
    
    }
    func load(){
        
        //load background
        self.bgImage.size = self.frame.size
        self.bgImage.position = CGPointMake( 0, 0)
        self.bgImage.name = "bground"
        self.addChild(bgImage)
        
        // load startTimeLabel
        startCountLabel.hidden = true
        startCountLabel.text = "\(timerCount)"
        startCountLabel.name = "scoring"
        startCountLabel.fontSize = 200
        startCountLabel.fontColor = SKColor.blackColor()
        startCountLabel.position = CGPoint(x:0, y:50)
        self.addChild(startCountLabel)
        
        // load score

        scoreBoard.load(X_POSITION_TOP_LABEL, y: Y_POSITION_TOP_LABEL  - FIX_LABEL_Y)
        self.addChild(scoreBoard.node)
        
        // load player
        player.HP = 3
        player.load()
        player.materializeBody()
        player.isInvincible = false
        self.addChild(player.playerImage)
        
        // applying physics
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        // Load coins/points 12/21/2015
        
        // load score from plist
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let fullPathName = documentDirectory.stringByAppendingPathComponent("dodger.plist") as String
        let virtualPlist = NSMutableDictionary(contentsOfFile:fullPathName)
        let the_points:Int = virtualPlist?.valueForKey("Points") as! Int
        // label
        labelCountPoint.text = "\(the_points)"
        labelCountPoint.fontName = "Courier"
        labelCountPoint.name = "points_label"
        labelCountPoint.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        labelCountPoint.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom;
        labelCountPoint.fontSize = 20
        labelCountPoint.fontColor = SKColor.blackColor()
        labelCountPoint.position = CGPoint(x: X_POSITION_TOP_LABEL - 15.0, y: Y_POSITION_TOP_LABEL - FIX_LABEL_Y)
        self.addChild(labelCountPoint)
        
        // image
        point_image.name = "points_image"
        point_image.size = CGSize(width: 70, height: 70)
        point_image.position = CGPoint(x: X_POSITION_TOP_LABEL, y: Y_POSITION_TOP_LABEL)
        self.addChild(point_image)
        
        // Animate Coin
        var alphaBool = true
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([ SKAction.runBlock({
                
                if(alphaBool == true){
                    self.point_image.alpha -= 0.1
                    if (self.point_image.alpha <= 0.3){
                        alphaBool = false
                    }
                }
                else{
                    self.point_image.alpha += 0.1
                    if (self.point_image.alpha >= 1.0){
                        alphaBool = true
                    }
                }
            }), SKAction.waitForDuration(NSTimeInterval(0.1))])), withKey: "animate_coin")
        
        // Assign value for currHighscore for Classic and Insane modes
       
        let hsClassicArray = virtualPlist?.objectForKey("Highscore_Classic") as! NSArray
        let hsInsaneArray = virtualPlist?.objectForKey("Highscore_Insane") as! NSArray
       let currClassicHighscore = hsClassicArray.objectAtIndex(0) as! Int
       let currInsaneHighscore = hsInsaneArray.objectAtIndex(0) as! Int
        
        if (self.gameMode == "classic"){
            self.currHighscore = currClassicHighscore
        }
        else{
            self.currHighscore = currInsaneHighscore
        }
    }
    
    func dragonMoving() -> [SKTexture]{
  
        return [SKTexture(imageNamed: "sprites/draggy/d_001"), SKTexture(imageNamed: "sprites/draggy/d_002"), SKTexture(imageNamed: "sprites/draggy/d_003"), SKTexture(imageNamed: "sprites/draggy/d_004")]
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
        for touch in touches {
            
            let location = touch.locationInNode(self)
                player.initPosition = location
            if (self.player.isInvincible == false){
                let liftUp = SKAction.scaleTo(1.2, duration: 0.2)
                player.playerImage.runAction(liftUp)
        }
    }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = (touch ).locationInNode(self)
                player.playerImage.position.x += (location.x - player.initPosition!.x)
                player.playerImage.position.y += (location.y - player.initPosition!.y)
                
                player.initPosition = location
                if ( player.playerImage.position.y > self.appDelegate.screenSize.height/2 * 0.815){
                    player.playerImage.position.y = self.appDelegate.screenSize.height/2 * 0.815
                }
                else if ( player.playerImage.position.y < -self.appDelegate.screenSize.height/2 * 0.815){
                    player.playerImage.position.y = -self.appDelegate.screenSize.height/2 * 0.815
                }
                if ( player.playerImage.position.x < -self.appDelegate.screenSize.width/2 * 0.735){
                    player.playerImage.position.x = -self.appDelegate.screenSize.width/2 * 0.735
                }
                else if ( player.playerImage.position.x > self.appDelegate.screenSize.width/2 * 0.745){
                    player.playerImage.position.x = self.appDelegate.screenSize.width/2 * 0.745
                }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for _ in touches {
            if (self.player.isInvincible == false){
            let liftUp = SKAction.scaleTo(1.0, duration: 0.2)
            player.playerImage.runAction(liftUp)
            }
        }
        
    }
    
    
    // iAd functions
    
 
    func bannerViewWillLoadAd(banner: ADBannerView!) {
        // about to load a new ads
        
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        adBannerView.hidden = false
        
       // print("iAD IS LOADED - SUCCESSFULLY LOADED")
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
     //   print("BANNER DID FINISH CALLED")
        //self.appDelegate.adBannerView.removeFromSuperview()
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        // when banner begins -> pause game
        adBannerView.hidden = true
        if(!gameover){
        pauseGame()
        }
        return true
        
        
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
  //      print("im called from the error banner")
        //when fails to call banner it will call this function
    }
    
    
    // finish iAd functions
    
    
    // iAD interstitial pop up
    
    func interstitialAdWillLoad(interstitialAd: ADInterstitialAd!) {
    }
    
    func interstitialAdDidLoad(interstitialAd: ADInterstitialAd!) {
    }
    
    func interstitialAdActionDidFinish(interstitialAd: ADInterstitialAd!) {
      // it is being called twice when closing the iAD.... WHY?!?!
       // print("is it called twice?")
       // print("DID FINISH CALLING....")
        // this funcion is also called when it is going to background
        if(self.interstitialAds.loaded && movingToBackground == false){
           self.interstitialAdView.removeFromSuperview()
            if(gameover == true){
            //     print("did Finish called")
                askPlayer()}
           
        }
        
    }
    
    func interstitialAdActionShouldBegin(interstitialAd: ADInterstitialAd!, willLeaveApplication willLeave: Bool) -> Bool {
        // actions to happen when user click on iAD
       // castEndScene()
        return true
    }
    
    func interstitialAd(interstitialAd: ADInterstitialAd!, didFailWithError error: NSError!) {
        //action if Ads can't load
        print("failed to start iAD fullscreen")
        
        // if game is over... cast end scene
        if (gameover){
            askPlayer()
        }
    }
    
    func interstitialAdDidUnload(interstitialAd: ADInterstitialAd!) {
        self.interstitialAdView.removeFromSuperview()
        self.interstitialAdView.hidden = true
    }
    
    // finish iAd pop up functions
    
    
    
    // good function helper for random a CGFloat datatype
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random( min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
    func loadObjects(){
    fire.type = 0
    fire.current_speed_rate = INITIAL_FIRE_SPEED_RATE!
    fire.max_speed_rate = MAX_FIRE_RATE!
        
    dragon.type = 1
    dragon.current_speed_rate = INITIAL_DRAGON_SPEED_RATE!
    dragon.max_speed_rate = MAX_DRAGON_RATE!
    powerUp.object.type = 2
        
        
        //keep calling callFire()
            runAction(SKAction.repeatActionForever(
                SKAction.sequence([
                    SKAction.runBlock({self.callType(self.fire)}),
                    SKAction.waitForDuration(NSTimeInterval(0.1))
                    ])
                ), withKey: "fire_attack")
        
    
        //keep calling callDragon

         //   removeActionForKey("dragon_attack")
            runAction(SKAction.repeatActionForever(
                SKAction.sequence([
                    SKAction.runBlock({self.callType(self.dragon)}),
                    SKAction.waitForDuration(NSTimeInterval(0.1))
                    ])
                ), withKey: "dragon_attack")
        
        // for food
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock({self.callType(self.powerUp.object)}),
                SKAction.waitForDuration(NSTimeInterval(1))
                ])
            ), withKey: "respawn_powerups")
        
    }
    
 
    func startCount(){
        startCountLabel.hidden = false
        let liftUp = SKAction.scaleTo(0.5, duration: 0.2)
        startCountLabel.runAction(liftUp)
        startCountLabel.text = "\(timerCount)"
        if ( timerCount == 0){
            startCountLabel.text = "START!"
            scoreStartCounting()
        }
        else if (timerCount == -1){
             startCountLabel.removeActionForKey("start_count")
            // Load all enemies/bonus items
             loadObjects()
            startCountLabel.removeFromParent()
        }
        
        timerCount--
       
    }
    
    func scoreStartCounting(){
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(setScore), SKAction.waitForDuration(NSTimeInterval(0.01))])), withKey: "scoreCounter")
    }
    
    func setScore(){
        scoreBoard.setScore()
    }
    
    func callType(obj: Object){
        // fireball
        if ( obj.type == 0){
            
            // increase level of difficulty
            if ( obj.current_speed_rate > obj.max_speed_rate ){
                fire.current_speed_rate -= RATE_SPEED_GROWTH!
            }
            
            fire.incDelay(0.2)
            
            if (obj.delay >= obj.current_speed_rate){
                callFire();
                fire.resetDelay()
            }
            
           // print("current level: \(obj.current_speed)")
        }
            // dragons
        else if (obj.type == 1){
            dragon.incDelay(0.2)
            if (obj.delay >= obj.current_speed_rate && scoreBoard.score >= RESPAWN_DRAGON_SCORE){
                
                //increase dragon speed
                if ( obj.current_speed_rate > obj.max_speed_rate ){
                    dragon.current_speed_rate -= RATE_SPEED_GROWTH!
                }
                
                callDragon()
               dragon.resetDelay()
            }
        }
        
            // powerups
        else if (obj.type == 2){
            let ram = random(0, max:100)
            if(ram > 100 - CHANCE_OF_POWERUP!){
            
                // chance for cloud
                let ramm = random(0, max:100)
                if ( ramm >= 90){
                    callCloud()
                }
                else{
            callPowerUp()
                }
            }
            
        }
        
        
    }
    func callFire() {
        
        // print buff time of powerUp
     /*   print("left \(self.powerUp.buffTime_Left)")
         print("right \(self.powerUp.buffTime_Right)")
         print("up \(self.powerUp.buffTime_Up)")
         print("down \(self.powerUp.buffTime_Down)")*/
        //self.s = self.delta
        // Create sprite
        let fireball = SKSpriteNode(imageNamed: "sprites/fireball/fireBall")
        fireball.name = "spriteFire"
        fireball.size = CGSize(width: 15, height: 15)
        
        // destination
        let y_up_bound:CGFloat = self.appDelegate.screenSize.height/2
        let y_down_bound:CGFloat = -self.appDelegate.screenSize.height/2
        let x_left_bound:CGFloat = -self.appDelegate.screenSize.width/2
        let x_right_bound:CGFloat = self.appDelegate.screenSize.width/2
        var x_togo:CGFloat = 0
        var y_togo:CGFloat = 0
        var angle:CGFloat = 0 // angular coefficient that passes through player
        var b:CGFloat = 0     // the b from y = a+b
        
        // Giving a initial random position ( x and y )
        var x_respawn = random( x_left_bound, max: x_right_bound)
        var y_respawn = random( y_down_bound, max: y_up_bound)
        let option = Int(arc4random_uniform(4))

        
        // Determine where to spawn the monster along the Y axis
       
        // Position of the fireball to respawn:
        
        // Respawn bottom
        if ( Int(option) == 0 ){
            if(powerUp.isDownArrowEnabled == true){
                return
            }
            fireball.position = CGPoint(x: x_respawn, y: y_down_bound)
            y_respawn = y_down_bound
          //  print("Respawn Bottom")
        }
        
        // Respawn Top
        else if ( Int(option) == 1 ){
            if(powerUp.isUpArrowEnabled == true){
                return
            }
            fireball.position = CGPoint(x: x_respawn, y: y_up_bound)
            y_respawn = y_up_bound
          //  print("Respawn Top")
        }
            
        //Respawn Left
        else if ( Int(option) == 2 ){
            if(powerUp.isLeftArrowEnabled == true){
                return
            }
            fireball.position = CGPoint(x: x_left_bound, y: y_respawn)
            x_respawn = x_left_bound
         //  print("Respawn Left")
        }
            
        //Respawn Right
        else if ( Int(option) == 3 ){
            if(powerUp.isRightArrowEnabled == true){
                return
            }
            fireball.position = CGPoint(x: x_right_bound, y: y_respawn)
            x_respawn = x_right_bound
         //   print("Respawn Right")
        }
        
        // Add to scene
        addChild(fireball)
        
        
        // adding physical body
       
        fireball.physicsBody = SKPhysicsBody(circleOfRadius: fireball.size.width/2) // 1
        fireball.physicsBody?.dynamic = true // physic engine will not control the movement of the fireball
        fireball.physicsBody?.categoryBitMask = PhysicsCategory.Fire // category of bit I defined in the struct
        fireball.physicsBody?.contactTestBitMask = PhysicsCategory.Player // notify when contact Player
        fireball.physicsBody?.collisionBitMask = PhysicsCategory.None // this thing is related to bounce
      //  fireball.physicsBody?.usesPreciseCollisionDetection = true
        
        // calculate the destination position
        
        
        // 1. Getting the final destination of coordinate y or x :
        
        if ( (Int(option) == 0) || (Int(option) == 1)  )
        {
            y_togo = y_respawn*(-1)
        }
            
            
        else if ( (Int(option) == 2) || (Int(option) == 3)  ){
            x_togo = x_respawn*(-1)
            
        }
        
        // 2. Calculate the angular coefficient
        
        angle = (player.playerImage.position.y - y_respawn)/(player.playerImage.position.x - x_respawn) //  angle = (y - yi ) / ( x - xo )
        b = y_respawn - angle*x_respawn // finding b from y = ax + b,  b = y - ax
        
        
        // 3. finding the second line which will intersect with previous line
        
        if ( (Int(option) == 0) || (Int(option) == 1)  )
        {
            x_togo = (y_togo - b)/angle // finding x final, x= ( y - b )/a
            
            if ( x_togo > 200 ){
                x_togo = 200
            }
            else if (x_togo < -200){
                x_togo = -200
            }
            
        }
            
            
        else if ( (Int(option) == 2) || (Int(option) == 3)  ){
            y_togo = angle*x_togo + b // finding y final,  y = ax + b
            
            
            if ( y_togo > 355 ){
                y_togo = 355
            }
            else if (y_togo < -355){
                y_togo = -355
            }
        }
        
        
        // calculate time  t = d/v
        let dx = Double(x_togo) - Double(x_respawn)
        let dy = Double(y_togo) - Double(y_respawn)
        let dist = sqrt( (dx*dx) + (dy*dy) )
        
        // end calculation
        
        // Create the actions
        let actionMove = SKAction.moveTo(CGPoint(x: x_togo, y: y_togo), duration: dist/SPEED_OF_BALL!)
        let actionMoveDone = SKAction.removeFromParent()
        fireball.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    
    func callDragon(){
        
        // Create sprite
        let dragonMonster = SKSpriteNode(imageNamed: "dragons")
        
        dragonMonster.name = "spriteDragon"
        dragonMonster.size = CGSize(width: 20, height: 20)
        
        // random Y position respawn
        let y_respawn = random( -355, max: 355)
        
        // destination
        let x_left_bound:CGFloat = -200
        let x_right_bound:CGFloat = 200
        
        dragonMonster.position = CGPoint(x: x_left_bound, y: y_respawn)
        
        // both side if score greater than 10000
        if (scoreBoard.score >= 10000){
            let rVal:CGFloat = random(0, max:1000)
            
            if (rVal > 500){
                dragonMonster.xScale = dragonMonster.xScale * -1;
                dragonMonster.position = CGPoint(x: x_right_bound, y: y_respawn)
            }
        }
        
        addChild(dragonMonster)
        
        // adding physical stuff  -> create a function for that later
        
        dragonMonster.physicsBody = SKPhysicsBody(circleOfRadius: dragonMonster.size.width/2) // 1
        dragonMonster.physicsBody?.dynamic = true // physic engine will not control the its movement
        dragonMonster.physicsBody?.categoryBitMask = PhysicsCategory.Dragon // category of bit I defined in the struct
        dragonMonster.physicsBody?.contactTestBitMask = PhysicsCategory.Player // notify when contact Player
        dragonMonster.physicsBody?.collisionBitMask = PhysicsCategory.None // this thing is related to bounce
       // dragonMonster.physicsBody?.usesPreciseCollisionDetection = true
        
        // Create the actions
        
        // by default
        var actionMove = SKAction.moveTo(CGPoint(x: x_right_bound, y: y_respawn), duration: 5)
        
        if (dragonMonster.position.x == 200){
          actionMove = SKAction.moveTo(CGPoint(x: x_left_bound, y: y_respawn), duration: 5)
        }
        
        let actionMoveDone = SKAction.removeFromParent()
        let walk = SKAction.animateWithTextures(dragonMoving(), timePerFrame: 0.033)
        
        dragonMonster.runAction(SKAction.repeatActionForever(walk))
        
        dragonMonster.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
        
    }
    
    func callCloud(){
        
        // Create sprite
        let cloud = SKSpriteNode(imageNamed: "sprites/cloud/white_cloud_1")
        
        cloud.name = "spriteCloud"
        cloud.size = CGSize(width: 50, height: 50)
        
        // random Y position respawn
        let y_respawn = Y_MAX_IN_SUBSCREEN
        // random X position respawn
        let x_respawn = random(X_MIN_IN_SUBSCREEN, max: X_MAX_IN_SUBSCREEN)
        // destination
        let x_left_bound:CGFloat = X_MIN_IN_SUBSCREEN
        let x_right_bound:CGFloat = X_MAX_IN_SUBSCREEN
        
        cloud.position = CGPoint(x: x_respawn, y: y_respawn)
        
        cloud.physicsBody = SKPhysicsBody(circleOfRadius: cloud.size.width/2) // 1
        
        cloud.physicsBody?.categoryBitMask = PhysicsCategory.Cloud // giving its bitmask
        cloud.physicsBody?.collisionBitMask = PhysicsCategory.Player // it pushes away player
        cloud.physicsBody?.dynamic = false // it cant be moved by physic contacts
        addChild(cloud)
        
        // calculate dist
        // calculate time  t = d/v
        
        let dx = Double(x_right_bound) - Double(x_left_bound)
        let dy = Double(0)
        let dist = sqrt( (dx * dx) + (dy*dy) )
        let dur = dist / SPEED_OF_CLOUD!  // note: this is the desired duration
        
        let dx_tmp = Double(x_respawn) - Double(x_left_bound)
        let dist_tmp = sqrt( (dx_tmp * dx_tmp) + (dy*dy) )
        let dur_tmp = dist_tmp / SPEED_OF_CLOUD!
        
        let whiteTime:CGFloat = 0.5; // 50%
        let greyTimeA:CGFloat = 0.3; // 20%
        let greyTimeB:CGFloat = 0.1; // 20%
        
        // Create the actions
        
        let totalTime = random(40, max: 70)
        var amountTime = totalTime
        // by default
        let actionInitialMove = SKAction.moveTo(CGPoint(x: x_right_bound, y: y_respawn), duration: dur - dur_tmp)
        let actionMoveRight = SKAction.moveTo(CGPoint(x: x_right_bound, y: y_respawn), duration: dur)
        let actionMoveLeft = SKAction.moveTo(CGPoint(x: x_left_bound, y: y_respawn), duration: dur)
        
        let whiteAnimation = SKAction.animateWithTextures( [SKTexture(imageNamed: "sprites/cloud/white_cloud_1"),SKTexture(imageNamed: "sprites/cloud/white_cloud_2") ], timePerFrame: 0.5)
        
        // Action moving
        cloud.runAction(SKAction.sequence([actionInitialMove, SKAction.repeatActionForever(SKAction.sequence([actionMoveLeft, actionMoveRight]))]))
        
        // Action duration
        cloud.runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock({
                    
                    
                    amountTime -= 1
                //    print("\(amountTime)")
                    
                // white
                    if ( amountTime >= totalTime * whiteTime){
                    cloud.runAction(whiteAnimation)
                        
                        let ram = self.random(0, max:100)
                        if ( ram > 10){
                            let coinLoot = SKSpriteNode()
                            coinLoot.texture = SKTexture(imageNamed: "sprites/coin")
                            coinLoot.name = "spriteCoin"
                            coinLoot.size = CGSize(width: 55, height: 55)
                            coinLoot.position = cloud.position
                            let move = SKAction.moveToY( -self.appDelegate.screenSize.height/2, duration: 5)
                            let movedone = SKAction.removeFromParent()
                            
                            coinLoot.physicsBody = SKPhysicsBody(circleOfRadius: coinLoot.size.width/2) // 1
                            coinLoot.physicsBody?.dynamic = true // physic engine will not control the movement of the fireball
                            coinLoot.physicsBody?.categoryBitMask = PhysicsCategory.Food // category of bit I defined in the struct
                            coinLoot.physicsBody?.contactTestBitMask = PhysicsCategory.Player // notify when contact Player
                            coinLoot.physicsBody?.collisionBitMask = PhysicsCategory.None // this thing is related to bounce*/
                            
                            self.addChild(coinLoot)
                            
                            coinLoot.runAction(SKAction.sequence([move, movedone]))

                        }
                    }
                // grey 1
                    else if ( amountTime >= totalTime * greyTimeA){
                    cloud.texture = SKTexture(imageNamed: "sprites/cloud/grey_cloud_1")
                    }
                    
                // grey 2
                    else if ( amountTime >= totalTime * greyTimeB){
                        cloud.texture = SKTexture(imageNamed: "sprites/cloud/grey_cloud_2")
                    }
                // grey 3
                    else if ( amountTime > 0 ){
                        cloud.texture = SKTexture(imageNamed: "sprites/cloud/grey_cloud_3")
                        
                        
                        let thunder = SKSpriteNode()
                        thunder.texture = SKTexture(imageNamed: "sprites/powerUps/energy")
                        thunder.name = "spriteThunder"
                        thunder.size = CGSize(width: 20, height: 20)
                        thunder.position = cloud.position
                        let move = SKAction.moveToY( -self.appDelegate.screenSize.height/2, duration: 5)
                        let movedone = SKAction.removeFromParent()
                        
                        thunder.physicsBody = SKPhysicsBody(circleOfRadius: thunder.size.width/2) // 1
                        thunder.physicsBody?.dynamic = true // physic engine will not control the movement of the fireball
                        thunder.physicsBody?.categoryBitMask = PhysicsCategory.Fire // category of bit I defined in the struct
                        thunder.physicsBody?.contactTestBitMask = PhysicsCategory.Player // notify when contact Player
                        thunder.physicsBody?.collisionBitMask = PhysicsCategory.None // this thing is related to bounce*/
                        
                        self.addChild(thunder)
                        
                        thunder.runAction(SKAction.sequence([move, movedone]))
                    }
                    
                    else{
                        cloud.removeAllActions()
                        cloud.removeFromParent()
                    }
                    
                }),SKAction.waitForDuration(NSTimeInterval(1))
                ])), withKey: "cloud_action")
        
    }
    
    func callPowerUp(){
        
        // change to this later after debug
        
        // 10% :  Imune item
        // 20% :  block side
        // 70% :  Gain HP
        
        let randomNum:CGFloat = random(0, max: 100)
        let randomArrowtype:CGFloat = random(0, max:100)
        // Create sprite
        let item = SKSpriteNode()
        
        // 10% imune
        if ( randomNum <= 10){
            item.texture = SKTexture(imageNamed: "sprites/powerUps/imuneItem")
            item.name = "spriteImune"
            item.size = CGSize(width: 20, height: 20)
        }
        
        // 20% block item
        else if ( randomNum > 10 && randomNum <= 30){
           
           
            // 30% : up/down
            // 20% : left/right
            
            if (randomArrowtype <= 30 ){
               item.texture = SKTexture(imageNamed: "sprites/powerUps/left_arrow")
                item.name = "spriteArrow_left"
            }
            
            else if (randomArrowtype > 30 && randomArrowtype <= 60 ){
                item.texture = SKTexture(imageNamed: "sprites/powerUps/right_arrow")
                item.name = "spriteArrow_right"
            }
            
            else if (randomArrowtype > 60 && randomArrowtype <= 80 ){
                item.texture = SKTexture(imageNamed: "sprites/powerUps/up_arrow")
                item.name = "spriteArrow_up"
            }
            
            else if (randomArrowtype > 80 && randomArrowtype <= 100 ){
                item.texture = SKTexture(imageNamed: "sprites/powerUps/down_arrow")
                item.name = "spriteArrow_down"
            }
            
            
            item.size = CGSize(width: 20, height: 20)
        }
        
        // 70% life item
        else {
            item.texture = SKTexture(imageNamed: "sprites/powerUps/life")
            item.name = "spriteLife"
            item.size = CGSize(width: 20, height: 20)
        }
       
       
        
        // random Y position respawn
        let y_respawn = random( Y_MIN_IN_SUBSCREEN, max: Y_MAX_IN_SUBSCREEN)
        
        // destination
        let x_respawn = random( X_MIN_IN_SUBSCREEN, max: X_MAX_IN_SUBSCREEN)
        
        item.position = CGPoint(x: x_respawn, y: y_respawn)
        
        addChild(item)
        
        // adding physical stuff  -> create a function for that later
        
        item.physicsBody = SKPhysicsBody(circleOfRadius: item.size.width/2) // 1
        item.physicsBody?.dynamic = true // physic engine will not control the its movement
        item.physicsBody?.categoryBitMask = PhysicsCategory.Food // category of bit I defined in the struct
        item.physicsBody?.contactTestBitMask = PhysicsCategory.Player // notify when contact Player
        item.physicsBody?.collisionBitMask = PhysicsCategory.Food // this thing is related to bounce
        //item.physicsBody?.usesPreciseCollisionDetection = true
        
        
    }
    
    // MOVE THIS FUNCTION TO PLAYER CLASS LATER
    func updatePlayerIMG(){
       
        if(player.isInvincible == true){
             self.player.playerImage.texture = SKTexture(imageNamed: "sprites/player/player_imune")
        }
        
        else{
        
        if(player.HP! == 3){
        self.player.playerImage.texture = SKTexture(imageNamed: "sprites/player/player_full")
        }
        else if(player.HP! == 2){
            self.player.playerImage.texture = SKTexture(imageNamed: "sprites/player/player_medium")
        }
        else if(player.HP! == 1){
            self.player.playerImage.texture = SKTexture(imageNamed: "sprites/player/player_low")
        }
        else{
         self.player.playerImage.texture = SKTexture(imageNamed: "sprites/player/player")
        }
            
        }
    }
   
    // added Jan 12, 2016  - Consider using struct?
    func createWall(name:String, dir:String){
        // load a many blocks of red_walls using for loop
        //  print("screen width: \(self.appDelegate.screenSize.width)\n")
        //   print("screen height: \(self.appDelegate.screenSize.height)")
        var value_x = self.appDelegate.screenSize.width / 2
        var value_y =  self.appDelegate.screenSize.height / 2
        
        if ( dir == "left"){
            value_x *= -1

        }
        if (dir == "bottom"){
            value_y *= -1
        }
        for (var s:CGFloat = 0; s <= self.appDelegate.screenSize.height; s = s + 40){
            let redWall:SKSpriteNode = SKSpriteNode()
            redWall.size = CGSize(width: 50, height: 40)
            redWall.texture = SKTexture(imageNamed: "sprites/grey_wall")
            redWall.name = name
            if ( dir == "left" || dir == "right"){
            redWall.position = CGPointMake( value_x , value_y - s)
            }
            else{
               redWall.position = CGPointMake( value_x - s , value_y)
            }
            
            // add physical body
            redWall.physicsBody = SKPhysicsBody(rectangleOfSize: redWall.size)
            
            // playerImage.physicsBody =  SKPhysicsBody(texture: playerImage.texture!, size: playerImage.size)
            redWall.physicsBody?.dynamic = false
            redWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
            redWall.physicsBody?.collisionBitMask = PhysicsCategory.None
            
            self.addChild(redWall)
            //       print("I create a wall on height: \(self.appDelegate.screenSize.height / 2 - s)")
        }
        
       
    }
    // added Jan 12, 2016
    func deleteWall(name:String){
        for kids in children{
            if (kids.name == name){
                kids.removeFromParent()
            }
        }
    }
    
    
    // MOVE THIS FUNCTION TO PLAYER CLASS LATER -> IF POSSIBLE
    func playerObtainItem(itemName:String) -> Bool{
        
        if (itemName == "spriteLife"){
            self.player.HP = self.player.HP! + 1
            
            if (self.player.HP > 3 ){
                self.player.HP = 3
            }
            updatePlayerIMG()
        }
            
        else if (itemName == "spriteImune"){
            
            var tempBool:Bool = true // this is used for alpha purpose
            var timer:CGFloat = 0.1
            var tempTimer:CGFloat = 0
            var boolSwapper:Bool = true
            
            let expand = SKAction.scaleTo(2.5, duration: 0.2)
            let shrink = SKAction.scaleTo(1.0, duration: 0.2)
            let BONUS_TIME:CGFloat = 10.0
            
            self.player.playerImage.runAction(expand)
            self.player.isInvincible = true
            updatePlayerIMG()
            
            self.player.playerImage.alpha = 1.0
            
            if (self.powerUp.buffTime_imune <= 0 ){
                self.powerUp.buffTime_imune = BONUS_TIME
                self.powerUp.update()
                
                runAction(SKAction.repeatActionForever(
                    SKAction.sequence([
                        SKAction.runBlock({
                            
                            if(self.powerUp.isImuneItemEnabled == true){
                                self.powerUp.buffTime_imune -= 0.1
                            }
                            if( self.powerUp.buffTime_imune > 0 &&  self.powerUp.buffTime_imune <= 5){
                                
                                if(tempBool == true){
                                    
                                    self.player.playerImage.alpha -= 0.1
                                    if (self.player.playerImage.alpha <= 0.5){
                                        tempBool = false
                                    }
                                }
                                else{
                                    self.player.playerImage.alpha += 0.1
                                    if (self.player.playerImage.alpha >= 1.0){
                                        tempBool = true
                                    }
                                }
                                
                                
                                //character color swapping
                                tempTimer += timer
                                
                                if(tempTimer >= 1.0){
                                    if(boolSwapper){
                                        
                                        if(self.player.HP! == 3){
                                            self.player.playerImage.texture = SKTexture(imageNamed: "sprites/player/player_full")
                                        }
                                        else if(self.player.HP! == 2){
                                            self.player.playerImage.texture = SKTexture(imageNamed: "sprites/player/player_medium")
                                        }
                                        else if(self.player.HP! == 1){
                                            self.player.playerImage.texture = SKTexture(imageNamed: "sprites/player/player_low")
                                        }
                                        boolSwapper = false
                                        
                                    }
                                    else{
                                        self.updatePlayerIMG()
                                        boolSwapper = true
                                    }
                                    timer *= 1.15
                                    tempTimer = 0
                                }
                            }
                            
                            
                            self.powerUp.update()
                            
                            if (self.powerUp.isImuneItemEnabled == false){
                                self.player.isInvincible = false
                                self.player.playerImage.alpha = 1.0
                                self.player.playerImage.runAction(shrink)
                                self.removeActionForKey("imune_counter")
                                self.updatePlayerIMG()
                            }
                            
                        }), SKAction.waitForDuration(NSTimeInterval(0.1))
                        ])
                    ), withKey: "imune_counter")
                
            }
            else {
                self.powerUp.buffTime_imune = BONUS_TIME
                self.powerUp.update()
            }
        }
            
        else if (itemName.containsString("spriteArrow")){
            
            let BONUS_TIME:CGFloat = 15.0
            
            // SKAction - run it if the action is not running
            if (self.powerUp.buffTime_Right <= 0.0 && self.powerUp.buffTime_Left <= 0.0 && self.powerUp.buffTime_Up <= 0.0 && self.powerUp.buffTime_Down <= 0.0 ){
                
                if(itemName.containsString("_right")){
                    self.powerUp.buffTime_Right = BONUS_TIME
                    createWall("right_brick", dir: "right")
                }
                else if(itemName.containsString("_left")){
                    self.powerUp.buffTime_Left = BONUS_TIME
                    createWall("left_brick", dir: "left")
                }
                else if(itemName.containsString("_up")){
                    self.powerUp.buffTime_Up = BONUS_TIME
                    createWall("top_brick", dir: "top")
                }
                else if(itemName.containsString("_down")){
                    self.powerUp.buffTime_Down = BONUS_TIME
                    createWall("bottom_brick", dir: "bottom")
                }
                
                // update the current status
                self.powerUp.update()
                
                runAction(SKAction.repeatActionForever(
                    SKAction.sequence([
                        SKAction.runBlock({
                            
                            if(self.powerUp.isRightArrowEnabled){
                                self.powerUp.buffTime_Right -= 0.1
                            }
                            
                            if(self.powerUp.isLeftArrowEnabled){
                                self.powerUp.buffTime_Left -= 0.1
                            }
                            if(self.powerUp.isUpArrowEnabled){
                                self.powerUp.buffTime_Up -= 0.1
                            }
                            
                            if(self.powerUp.isDownArrowEnabled){
                                self.powerUp.buffTime_Down -= 0.1
                            }
                            
                            self.powerUp.update()
                            if(!self.powerUp.isDownArrowEnabled){
                                self.deleteWall("bottom_brick")
                            }
                            if(!self.powerUp.isUpArrowEnabled){
                                self.deleteWall("top_brick")
                            }
                            if(!self.powerUp.isRightArrowEnabled){
                                 self.deleteWall("right_brick")
                            }
                            if(!self.powerUp.isLeftArrowEnabled){
                                 self.deleteWall("left_brick")
                            }
                            if(self.powerUp.isDownArrowEnabled == false && self.powerUp.isUpArrowEnabled == false && self.powerUp.isLeftArrowEnabled == false && self.powerUp.isRightArrowEnabled == false){
                               
                                self.removeActionForKey("arrow_counter")
                            }
                            
                        }), SKAction.waitForDuration(NSTimeInterval(0.1))
                        ])
                    ), withKey: "arrow_counter")
                
                
            }
                
            else{
                
                if(itemName.containsString("_right")){
                    if ( self.powerUp.buffTime_Right <= 0 ){
                        createWall("right_brick", dir: "right")
                    }
                    self.powerUp.buffTime_Right = BONUS_TIME
                }
                else if(itemName.containsString("_left")){
                    if ( self.powerUp.buffTime_Left <= 0 ){
                        createWall("left_brick", dir: "left")
                    }
                    self.powerUp.buffTime_Left = BONUS_TIME
                }
                else if(itemName.containsString("_up")){
                    if ( self.powerUp.buffTime_Up <= 0 ){
                        createWall("top_brick", dir: "top")
                    }
                    self.powerUp.buffTime_Up = BONUS_TIME
                }
                else if(itemName.containsString("_down")){
                    if ( self.powerUp.buffTime_Down <= 0 ){
                        createWall("bottom_brick", dir: "bottom")
                    }
                    self.powerUp.buffTime_Down = BONUS_TIME
                }
                
                // update
                powerUp.update()
            }
           
        }
        
        else if (itemName.containsString("Coin")){
            
            //initialize the virtual plist
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
            
            // giving the path?
            let fullPathName = documentDirectory.stringByAppendingPathComponent("dodger.plist") as String
            
            // plistFile is the root ( which is of the type Dictionary )
            let plistFile = NSMutableDictionary(contentsOfFile:fullPathName)
            let pointsPlist = plistFile!.valueForKeyPath("Points") as? Int
            
            // updating Points
            
            // updating virtual plist for points
            plistFile?.setObject(pointsPlist! + 1, forKey: "Points")
            
            // Saving it to the virtual file
            if !plistFile!.writeToFile(fullPathName, atomically: false){
                print("FILE FAILED TO SAVE THE CHANGES ---- PLEASE FIX IT IN GameViewController")
            }
            
            updatePoints()
        }
            
        else{
            return false
        }
        return true
    }
    
    func projectileDidCollideWithMonster(player:SKSpriteNode, object:SKSpriteNode) {
       
        if (player.name?.containsString("brick") == true) {
            object.removeFromParent()
        return
        }
        
        object.removeFromParent()
        
        // swift read from left to right... if left is true... then right will not be read
         if (playerObtainItem(object.name!) == false && self.player.isInvincible == false ){
            self.player.HP = self.player.HP! - 1
            updatePlayerIMG()
        }
        
        
        
        if (self.player.HP! <= 0){
        // Game is over - this fix when player do not close the interstital ad
            gameover = true
        // pause game
             view?.paused = true
            
        // show iAd Pop up - if it is loaded successfully
            let chance_toShow:CGFloat = random(0, max: 100)
            
    // debug print
  //  print("The iAD Interstitial loaded: \(self.interstitialAds.loaded)")
   // print("Value of Random: \(chance_toShow)")
            if (self.interstitialAds.loaded && chance_toShow > 70){
                iAdPopup()
            }
            else{
              
                askPlayer()
            }
        }
        
    }
    
    func askPlayer(){
        replayGameViewController.delegate = self
        let replayScene = replayGameViewController.view
        view?.addSubview(replayScene)
        }
    
    func playerContinue(){
        replayGameViewController = ReplayMenuController()
        gameover = false
        self.player.HP = 3
        playerObtainItem("spriteImune")
        
        // update Points
       updatePoints()
    }
    
    func updatePoints(){
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let fullPathName = documentDirectory.stringByAppendingPathComponent("dodger.plist") as String
        let virtualPlist = NSMutableDictionary(contentsOfFile:fullPathName)
        let the_points:Int = virtualPlist?.valueForKey("Points") as! Int
        labelCountPoint.text = "\(the_points)"
    }
    func castEndScene(){
        
        // 1. Display ReplayGameMenu
        // 2. User can choose if to continue or endgame
        
        // remove all actions ( maybe can try remove all actions later )
        /* removeActionForKey("scoreCounter")
        removeActionForKey("fire_attack")
        removeActionForKey("dragon_attack")
        removeActionForKey("respawn_powerups")
        removeActionForKey("imune_counter")
        removeActionForKey("imune_counter")*/
        removeAllActions()
        startCountLabel.removeAllActions()
        
        // remove the strong reference
        //Questions: Why I do not need to do this to other delegates such as:
        // *physical delegate, ad delegate? :/
        // Example: the pauseGameController MUST have. Otherwise, it will cause memory leak
        // But.. the others will not cause memory leak
        pauseGameViewController.delegate = nil
        replayGameViewController.delegate = nil
        
        // delete the listener nsnotification ( since it dont get removed when move to other scenes)
        notificationCenter.removeObserver(self)
        
        // remove children action
        for sprites in self.children{
            if ( sprites.name == "spriteCloud"){
                sprites.removeAllActions()
            }
        }
        
        // hide banner iAd
          adBannerView.hidden = true
        
        
        SKAction.waitForDuration(5)
        //  let reveal = SKTransition.flipHorizontalWithDuration(0.5)
        
        
        
        
               if ( scoreBoard.score > currHighscore){
                let winScene = GameOver(size: self.size, containHighscore: true, score: scoreBoard.score, highscore: highscore, game_mode: self.gameMode!)
            self.view?.presentScene(winScene)
        }
            
        else{
                let loseScene = GameOver(size: self.size, containHighscore: false, score: scoreBoard.score, highscore: highscore, game_mode:gameMode!)
            self.view?.presentScene(loseScene)
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        
        var firstBody: SKPhysicsBody  // player
        var secondBody: SKPhysicsBody // fireball
        
    //    print("the body A: \(contact.bodyA.categoryBitMask)")
     //   print("the body B: \(contact.bodyB.categoryBitMask)")
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
     
        
        // This is to prevent a error when a node is deleted... but this function is called.
        // I think this function might be called twice when a object touches 2 stuff at a time. So it will be called twice
        if(contact.bodyA.node == nil || contact.bodyB.node == nil ){
          //  print("I HAVE BEEN CALLED... IM RETURNING TO AVOID ERROR")
            return
        }
     //   if (firstBody.node?.name?.containsString("brick") == true || secondBody.node?.name?.containsString("brick") == true) {
     //     print("first: \(firstBody.node?.name), second: \(secondBody.node?.name)")
     //   }
        
     //   if ((firstBody.categoryBitMask & PhysicsCategory.Player != 0) &&
     //       (secondBody.categoryBitMask & PhysicsCategory.Fire != 0)) {
                projectileDidCollideWithMonster(firstBody.node as! SKSpriteNode, object: secondBody.node as! SKSpriteNode)
     //   }
    }
    
    func iAdPopup(){
        // recently added for test
        self.interstitialAdView.frame = self.view!.bounds
           self.interstitialAds.delegate = self
           view!.addSubview(self.interstitialAdView)
//
        
        self.interstitialAds.presentInView(self.interstitialAdView)
        UIViewController.prepareInterstitialAds()
        self.interstitialAdView.hidden = false
    }
    
    func pauseGame (){
       
        isPauseGameCalled = true
        view?.paused = true
        view?.addSubview(pauseGameViewController.view)
    }
    
    // It is only called by delegate. If you plan to use for this Class.. please, review the logic of the boolean
    func callUnpause(){
        isPauseGameCalled = false
        view?.paused = false
    }
    
    func removeAds(){
        //  self.appDelegate.interstitialAdView.removeFromSuperview()
        adBannerView.removeFromSuperview()
    }
    
    func fixRatio(curr_ratio:CGFloat){
      //  print("THE RATIO IS: \(curr_ratio)")
        
        var RATIO:CGFloat = 1.0
        
        var FIX_X:CGFloat = 0.0
        
        if (curr_ratio > 0.6){
            RATIO = 0.6333
            FIX_X = 20.0
        }
            
        else if (curr_ratio >= 0.562 && curr_ratio < 0.563){
           RATIO = 0.9
        }
        else{
            RATIO = 0.76
        }
        
        X_POSITION_TOP_LABEL = X_POSITION_TOP_LABEL * RATIO + FIX_X
        Y_POSITION_TOP_LABEL *= RATIO
        
        X_MIN_IN_SUBSCREEN *= RATIO
        X_MAX_IN_SUBSCREEN *= RATIO
        Y_MIN_IN_SUBSCREEN *= RATIO
        Y_MAX_IN_SUBSCREEN *= RATIO
        
     //   DISTANCE_BETWEEN_SCORE = DISTANCE_BETWEEN_SCORE * RATIO  + 5.0
        
    /*    DISTANCE_X_SEPARATOR_RESET = DISTANCE_X_SEPARATOR_RESET * RATIO
        
        SIZE_RESET_BUTTON_HEIGHT *= RATIO
        SIZE_RESET_BUTTON_WIDTH *= RATIO*/
        
        
    }

}