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
    static let Fire   : UInt32 = 0b10
    static let Dragon : UInt32 = 0b11
    
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
        self.playerImage.texture = SKTexture(imageNamed: "player")
        self.playerImage.name = "player"
        self.playerImage.position = CGPointMake( 0, 0)
    }
    func materializeBody(){
        // Setting a physical body to the player
        playerImage.physicsBody = SKPhysicsBody(rectangleOfSize: playerImage.size)
        playerImage.physicsBody?.dynamic = true
        playerImage.physicsBody?.categoryBitMask = PhysicsCategory.Player
        playerImage.physicsBody?.contactTestBitMask = PhysicsCategory.Fire
        playerImage.physicsBody?.collisionBitMask = PhysicsCategory.None
    }
}

/*

im going to put fireball/dragon in a struct
*/

struct Enemy{
    var delay:Int = 0  // delay for spawining the object
    
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
    
    func load(){
        // load score
        node.text = "\(score)"
        node.name = "scoring"
        node.fontSize = 20
        node.fontColor = SKColor.blackColor()
        node.position = CGPoint(x:-130, y:320)
    }
    
    mutating func setScore(){
        //set score and display it
        score = score + 10
        node.text = "\(score)"
    }
}

class StartGame: SKScene, SKPhysicsContactDelegate, ADBannerViewDelegate, ADInterstitialAdDelegate, UnpauseDelegate{
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate // Create reference to the app delegate
    
    var stageLevel:Int? = nil;   // current Level -> this is set up by level selector
    var scorePass:Int? = nil;    // minumum score to pass to next level
    
    var fireDelay:CGFloat = 0;
    var dragonDelay:CGFloat = 0;
    var speedLevel:CGFloat = 1   // default speed for 'delay'
    
    var pauseGameViewController = PauseMenu()
    var bgImage = SKSpriteNode(imageNamed: "background2")
    var startCountLabel = SKLabelNode(fontNamed: "Courier")
    var isValid:Bool = false  // touching the 'player' object  :  change var name later.. for a better one
    var highscore:Int = 0
    var timerCount:Int = 3
    
    var player = Player(playerImage: SKSpriteNode()) // using extension way
    var scoreBoard = Scorelabel()
    
    var interstitialAds:ADInterstitialAd = ADInterstitialAd()
    var interstitialAdView: UIView = UIView()
    
    override func didMoveToView(view: SKView){
        
      //  print("screen width: \(self.appDelegate.screenSize.width)\n")
      //  print("screen height: \(self.appDelegate.screenSize.height)")
        
        
        // delete subviews if previous didnt called
        for view in view.subviews {
            view.removeFromSuperview()
        }
        
        // load ads
        loadiAd()
        // load objects
        load();
        
        // Counts from 3 to 0 and starts showing enemies
        startCountLabel.runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(startCount),
                SKAction.waitForDuration(NSTimeInterval(1)), SKAction.scaleTo(1.0, duration: 0.2)
                ])
            ), withKey: "start_count")
        
    }
    
    func loadiAd(){
        
        // delegate for Unpause scene
        pauseGameViewController.delegate = self
        
        //iAd Banner
       // self.appDelegate.adBannerView.delegate = self  // -> to avoid an error
        
        //hide until ad loaded
        
        self.appDelegate.adBannerView.hidden = false
        self.appDelegate.adBannerView = ADBannerView(frame: CGRect.zero)
        self.appDelegate.adBannerView.center = CGPoint(x: self.appDelegate.adBannerView.center.x, y: view!.bounds.size.height - self.appDelegate.adBannerView.frame.size.height / 2)
        self.appDelegate.adBannerView.delegate = self
        self.appDelegate.adBannerView.hidden = true
        view!.addSubview(self.appDelegate.adBannerView)
        
        // iAD  Interstitial  -> pop up full screen iAds   ( Not fully working! )
        self.interstitialAdView.frame = self.view!.bounds
        self.interstitialAds.delegate = self
        self.interstitialAdView.hidden = true
        self.anchorPoint = CGPointMake(0.5, 0.5)
        view!.addSubview(self.interstitialAdView)
        
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
        
        scoreBoard.load()
        self.addChild(scoreBoard.node)
        
        // load player
        player.load()
          self.addChild(player.playerImage)
        
        // applying physics
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
    }
    
    func testSprite() -> [SKTexture]{
  
        //testing
       // dragonMonster.texture = SKTexture(imageNamed: "sprites/draggy/d_001")
        //ends
        return [SKTexture(imageNamed: "sprites/draggy/d_001"), SKTexture(imageNamed: "sprites/draggy/d_002"), SKTexture(imageNamed: "sprites/draggy/d_003"), SKTexture(imageNamed: "sprites/draggy/d_004")]
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            
            
            let location = (touch ).locationInNode(self)
            if ( ((player.playerImage.position.x > location.x - 20 ) && (player.playerImage.position.x < location.x + 20)) && ((player.playerImage.position.y > location.y - 20 ) && (player.playerImage.position.y < location.y + 20))  ){
                let liftUp = SKAction.scaleTo(1.2, duration: 0.2)
                player.playerImage.runAction(liftUp)
                isValid = true
                
            }
            else{
                isValid = false
            }
            
            player.materializeBody()
            
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = (touch ).locationInNode(self)
            if (isValid){
                
                player.playerImage.position = location
                
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
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for _ in touches {
            let liftUp = SKAction.scaleTo(1.0, duration: 0.2)
            player.playerImage.runAction(liftUp)
        }
    }
    
    
    // iAd functions
    
    
    func bannerViewWillLoadAd(banner: ADBannerView!) {
        // about to load a new ads
        
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.appDelegate.adBannerView.hidden = false
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        //self.appDelegate.adBannerView.removeFromSuperview()
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        
        // when banner begins -> pause game
        self.appDelegate.adBannerView.hidden = true
        pauseGame()
        return true
        
        
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        
        //when fails to call banner it will call this function
    }
    
    
    // finish iAd functions
    
    
    // iAD pop up
    
    func interstitialAdWillLoad(interstitialAd: ADInterstitialAd!) {
    }
    
    func interstitialAdDidLoad(interstitialAd: ADInterstitialAd!) {
    }
    
    func interstitialAdActionDidFinish(interstitialAd: ADInterstitialAd!) {
        // it is always called twice... why?
        
        if(self.interstitialAds.loaded){
           // print("lose scene called: \(self.interstitialAds.loaded)")
            self.interstitialAdView.removeFromSuperview()
            castEndScene()
        }
        callUnpause()
    }
    
    func interstitialAdActionShouldBegin(interstitialAd: ADInterstitialAd!, willLeaveApplication willLeave: Bool) -> Bool {
        // actions to happen when user click on iAD
        return true
    }
    
    func interstitialAd(interstitialAd: ADInterstitialAd!, didFailWithError error: NSError!) {
        //action if Ads can't load
        print("failed to start iAD fullscreen")
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
    
    // function to keep calling callFire()
    func loadFire(){
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock({self.callType(0)}),
                SKAction.waitForDuration(NSTimeInterval(0.2))
                ])
            ), withKey: "fire_attack")
        
    }
    
    // function to keep calling callDragon
    func loadDragonMonster(){
        removeActionForKey("dragon_attack")
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock({self.callType(1)}),
                SKAction.waitForDuration(NSTimeInterval(0.2))
                ])
            ), withKey: "dragon_attack")
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
            removeActionForKey("start_count")
            
            // Start sending fireballs
            loadFire()
            
            // Start sending Dragons
            if(stageLevel! >= 2){
                loadDragonMonster()
            }
            
            
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
    
    func callType(id: Int){
        
        // fireball
        if ( id == 0){
            
            // increase level of difficulty
            if ( scoreBoard.score % 10000 < 300 && speedLevel > 0.4 ){
                speedLevel -= 0.1
            }
            
            
            fireDelay += 0.2
            if (fireDelay >= speedLevel){
                callFire();
                fireDelay = 0
            }
        }
            // dragons
        else if (id == 1){
            dragonDelay += 0.2
            if (dragonDelay >= 1.5 && scoreBoard.score >= 5000){
                callDragon()
                dragonDelay = 0;
            }
        }
        
        
    }
    func callFire() {
        
        //self.s = self.delta
        // Create sprite
        let fireball = SKSpriteNode(imageNamed: "fireBall")
        fireball.name = "spriteFire"
        fireball.size = CGSize(width: 20, height: 20)
        
        // random X
        var x_respawn = random( -200, max: 200)
        var y_respawn = random( -355, max: 355)
        let option = Int(arc4random_uniform(4))
        
        // destination
        let y_up_bound:CGFloat = 355
        let y_down_bound:CGFloat = -355
        let x_left_bound:CGFloat = -200
        let x_right_bound:CGFloat = 200
        var x_togo:CGFloat = 0
        var y_togo:CGFloat = 0
        var angle:CGFloat = 0 // angular coefficient that passes through player
        var b:CGFloat = 0     // the b from y = a+b
        
        // Determine where to spawn the monster along the Y axis
        // let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
        
        // Position of the fireball to respawn
        if ( Int(option) == 0 ){
            fireball.position = CGPoint(x: x_respawn, y: -355)
            y_respawn = y_down_bound
            
        }
        else if ( Int(option) == 1 ){
            fireball.position = CGPoint(x: x_respawn, y: 355)
            y_respawn = y_up_bound
            
        }
        else if ( Int(option) == 2 ){
            fireball.position = CGPoint(x: x_left_bound, y: y_respawn)
            x_respawn = x_left_bound
            
        }
        else if ( Int(option) == 3 ){
            fireball.position = CGPoint(x: x_right_bound, y: y_respawn)
            x_respawn = x_right_bound
            
        }
        
        // Add to scene
        addChild(fireball)
        
        // adding physical stuff
        
        fireball.physicsBody = SKPhysicsBody(circleOfRadius: fireball.size.width/2) // 1
        fireball.physicsBody?.dynamic = true // physic engine will not control the movement of the fireball
        fireball.physicsBody?.categoryBitMask = PhysicsCategory.Fire // category of bit I defined in the struct
        fireball.physicsBody?.contactTestBitMask = PhysicsCategory.Player // notify when contact Player
        fireball.physicsBody?.collisionBitMask = PhysicsCategory.None // this thing is related to bounce
        fireball.physicsBody?.usesPreciseCollisionDetection = true
        
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
        
        
        // end calculation
        
        // Create the actions
        let actionMove = SKAction.moveTo(CGPoint(x: x_togo, y: y_togo), duration: 5)
        let actionMoveDone = SKAction.removeFromParent()
        fireball.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    
    func callDragon(){
        
        // Create sprite
        let dragonMonster = SKSpriteNode(imageNamed: "dragons")
        
        dragonMonster.name = "spriteFire"
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
        dragonMonster.physicsBody?.usesPreciseCollisionDetection = true
        
        // Create the actions
        
        // by default
        var actionMove = SKAction.moveTo(CGPoint(x: x_right_bound, y: y_respawn), duration: 5)
        
        if (dragonMonster.position.x == 200){
          actionMove = SKAction.moveTo(CGPoint(x: x_left_bound, y: y_respawn), duration: 5)
        }
        
        let actionMoveDone = SKAction.removeFromParent()
        let walk = SKAction.animateWithTextures(testSprite(), timePerFrame: 0.033)
        
        dragonMonster.runAction(SKAction.repeatActionForever(walk))
        
        dragonMonster.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
        
    }
    
    func projectileDidCollideWithMonster(player:SKSpriteNode, fireball:SKSpriteNode) {
        
        fireball.removeFromParent()
        removeActionForKey("scoreCounter")
        removeActionForKey("fire_attack")
        removeActionForKey("dragon_attack")
        // show iAd Pop up - if it is loaded successfully
        if (self.interstitialAds.loaded){
            view?.paused = true
            iAdPopup()
        }
        else{
            castEndScene()
        }
        
        
    }
    
    func castEndScene(){
        
        SKAction.waitForDuration(5)
        //  let reveal = SKTransition.flipHorizontalWithDuration(0.5)
        let winScene = GameOver(size: self.size, won: true, score: scoreBoard.score, highscore: highscore)
        
        let loseScene = GameOver(size: self.size, won: false, score: scoreBoard.score, highscore: highscore)
        
        if ( scoreBoard.score >= scorePass!){
            self.view?.presentScene(winScene)
        }
            
        else{
            self.view?.presentScene(loseScene)
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        
        
        var firstBody: SKPhysicsBody  // player
        var secondBody: SKPhysicsBody // fireball
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Player != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Fire != 0)) {
                projectileDidCollideWithMonster(firstBody.node as! SKSpriteNode, fireball: secondBody.node as! SKSpriteNode)
        }
        
    }
    
    func iAdPopup(){
        self.interstitialAds.presentInView(self.interstitialAdView)
        UIViewController.prepareInterstitialAds()
        self.interstitialAdView.hidden = false
    }
    
    func pauseGame (){
        
        view?.paused = true
        view?.addSubview(pauseGameViewController.view)
    }
    
    // this is also called by delegate
    func callUnpause(){
        
        view?.paused = false
    }
    
    func removeAds(){
        //  self.appDelegate.interstitialAdView.removeFromSuperview()
        self.appDelegate.adBannerView.removeFromSuperview()
    }
}