//
//  GameOver.swift
//  Dodger Me!
//
//  Created by Guan Wong on 2/4/15.
//  Copyright (c) 2015 Guan Wong. All rights reserved.
//

import SpriteKit

class GameOver: SKScene {
    
//    deinit{
//        print(" gameover being deInitialized.");
        
//    }
    
    var bgImage = SKSpriteNode(imageNamed: "sprites/background2")
    var label = SKLabelNode(fontNamed: "Chalkduster")
    var scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    var score:Int = 0
    var highscore:Int = 0
    var winResult = false
    var game_mode:String?
    
    init(size: CGSize, won:Bool, score:Int, highscore:Int, game_mode:String) {
        
        super.init(size: size)
        
        self.score = score
        self.highscore = highscore
        self.winResult = won
        self.game_mode = game_mode
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
    

    
    // Implementing the plist 12/19/2015
    
    
    //initialize the virtual plist
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
    
    // giving the path?
    let fullPathName = documentDirectory.stringByAppendingPathComponent("dodger.plist") as String
    
    // plistFile is the root ( which is of the type Dictionary )
    let plistFile = NSMutableDictionary(contentsOfFile:fullPathName)
  
    // Selecting the mode
    var mode:String?
    
    if(game_mode! == "classic"){
        mode = "Highscore_Classic"
    }
    else if (game_mode! == "insane"){
        mode = "Highscore_Insane"
    }
    
    // newList is a copy of the key \(mode)
    let newList = plistFile!.valueForKeyPath(mode!) as? NSMutableArray
    for stuff in newList!{
    let id = newList!.indexOfObject(stuff) as Int
        
          if(score > stuff as! Int){
            newList?.insertObject(score, atIndex: id)
            newList?.removeLastObject()
            break
        }
        
    }

    // Changing the object from plistFile - I'm replacing it with a new newList
      plistFile!.setObject(newList!, forKey: mode!)
    
    
    // Saving it to the virtual file
    if !plistFile!.writeToFile(fullPathName, atomically: false){
        print("FILE FAILED TO SAVE THE CHANGES ---- PLEASE FIX IT IN GameViewController")
    }

    // Restart botton
    
    let restartLabel = SKLabelNode(fontNamed: "Courier")
    restartLabel.text = "Continue"
    restartLabel.name = "restart"
    restartLabel.fontSize = 20
    restartLabel.fontColor = SKColor.blackColor()
    restartLabel.position = CGPoint(x: 0, y: -view.center.y/2)
    self.addChild(restartLabel)

    }
    
   
    // Practice this later... probably implemented incorrectly
    // Purpose: required to initiate with some values
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
                   self.view?.presentScene(scene)
            }

    
   }


/* works for dictionary inside dictionary
let filePath = NSBundle.mainBundle().pathForResource("dodger", ofType: "plist")!
let stylesheet = NSDictionary(contentsOfFile:filePath)

let filename = "Test_Case"
let hs = stylesheet!.valueForKeyPath(filename) as! NSDictionary
print("finally we got this: \(hs.valueForKeyPath("one") as! Int)")
*/


/* works for array inside dictionary
let filePath = NSBundle.mainBundle().pathForResource("dodger", ofType: "plist")!
let stylesheet = NSDictionary(contentsOfFile:filePath)

let filename = "Highscore_Insane"
let hs = stylesheet!.valueForKeyPath(filename) as! NSArray

// getting size of the NSArray
print("this is the size: \(hs.count)")
// getting first index
print("finally we got this: \(hs.objectAtIndex(0) as! Int)")

//can it print all array? YES
print(hs)


*/


/* sorting NSArray

newList =
newList.sortedArrayUsingComparator(){(p1:AnyObject, p2:AnyObject) -> NSComparisonResult in

if (p1 as! Int > p2 as! Int) {
return NSComparisonResult.OrderedDescending
}
return NSComparisonResult.OrderedAscending
}
*/