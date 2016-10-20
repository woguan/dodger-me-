//
//  PauseMenu.swift
//  Dodger Me!
//
//  Created by Guan Wong on 2/18/15.
//  Copyright (c) 2015 Guan Wong. All rights reserved.
//

import UIKit
import SpriteKit

/*@objc protocol UnpauseDelegate{
// add all functions you want to be able to use
optional func callUnpause()
}*/

protocol ReplayMenuDelegate{
    
    var scoreBoard:Scorelabel {get}
    
    func callUnpause()
    func playerContinue()
    func castEndScene()
}


class ReplayMenuController: UIViewController {
    
    /* deinit{
        print(" ReplayMenuController being deInitialized.")
     }*/
    
    var delegate:ReplayMenuDelegate?
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate // Create reference to the app delegate
    
    var BUTTON_WIDTH:CGFloat = 100.0
    var BUTTON_HEIGHT:CGFloat = 50.0
    var BUTTON_LETTER_SIZE:CGFloat = 15
    
    var justScore:Int?
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ratio = appDelegate.screenSize.width/appDelegate.screenSize.height
        let pointsNeeded:Int = (delegate?.scoreBoard.score)!/10000
        
        let fullPathName = documentDirectory.stringByAppendingPathComponent("dodger.plist") as String
        let virtualPlist = NSMutableDictionary(contentsOfFile:fullPathName)
        
        if (ratio != 0.5625){
            fixRatio(ratio)
        }
       
        // use this message to debug
     //   print("THIS IS THE SCORE: \(delegate?.scoreBoard.score)")
        
        view.frame = CGRectMake(view.center.x/2 , view.center.y/2, self.view.frame.width * 0.5, self.view.frame.height * 0.5)
        let background_img = UIImage(named: "sprites/pause_img")
        
        let someImage = UIImageView(frame: self.view.bounds)
        someImage.image = background_img
        someImage.contentMode = .ScaleAspectFit
        
     //   print("view_width: \(view.frame.width), view_height: \(view.frame.height)")
        self.view.addSubview(someImage)
        
        
        let continueButton = UIButton (frame: CGRectMake(view.frame.width/4, view.frame.height/2,BUTTON_WIDTH,BUTTON_HEIGHT))
        continueButton.titleLabel?.lineBreakMode = .ByCharWrapping
        continueButton.titleLabel?.textAlignment = .Center
        continueButton.setTitle("CONTINUE\nx\(pointsNeeded)", forState: .Normal)
        continueButton.titleLabel?.font = UIFont(name: "Chalkduster", size: BUTTON_LETTER_SIZE)
        continueButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        continueButton.backgroundColor = UIColor.darkGrayColor()
        continueButton.layer.cornerRadius = 5.0
        
        if ( virtualPlist?.valueForKey("Points") as! Int >= pointsNeeded){
                    continueButton.alpha = 1.0
            continueButton.addTarget(self, action: #selector(ReplayMenuController.continueGame), forControlEvents: .TouchUpInside)
        }
        else{
                    continueButton.alpha = 0.5
        //    continueButton.addTarget(self, action: "", forControlEvents: .TouchUpInside)
        }
        
        view.addSubview(continueButton)
        
        let endButton = UIButton (frame: CGRectMake(view.frame.width/4, view.frame.height/1.5,BUTTON_WIDTH,BUTTON_HEIGHT))
        endButton.setTitle("END GAME", forState: .Normal)
        endButton.titleLabel?.font = UIFont(name: "Chalkduster", size: BUTTON_LETTER_SIZE)
        endButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        endButton.backgroundColor = UIColor.darkGrayColor()
        endButton.addTarget(self, action: #selector(ReplayMenuController.endGame), forControlEvents: .TouchUpInside)
        endButton.layer.cornerRadius = 5.0
        view.addSubview(endButton)
    }
    
    func fixRatio(curr_ratio:CGFloat){
        //  print("THE RATIO IS: \(curr_ratio)")
        
        var RATIO:CGFloat = 1.0
        
        //      var FIX_X:CGFloat = 0.0
        
        // iPhone 4S
        if (curr_ratio > 0.6){
            RATIO = 0.6333
            //      FIX_X = 20.0
        }
            
        else if (curr_ratio >= 0.562 && curr_ratio < 0.563){
            RATIO = 0.9
        }
        else{
            RATIO = 0.76
        }
        
        BUTTON_WIDTH *= RATIO
        BUTTON_HEIGHT  *= RATIO
        BUTTON_LETTER_SIZE *= RATIO
        
    }
    
    func removeAllViews(){
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
   
    @IBAction func continueGame(){
        //print("THE VALUE IS: \(self.paused)")
        
        let fullPathName = documentDirectory.stringByAppendingPathComponent("dodger.plist") as String
        let virtualPlist = NSMutableDictionary(contentsOfFile:fullPathName)
        let currPoints = virtualPlist?.valueForKeyPath("Points") as! Int
        
       // PointsPlist
        let pointsNeeded = (delegate?.scoreBoard.score)!/10000
        
        let newValuePoints = currPoints - pointsNeeded
        
        virtualPlist?.setValue(newValuePoints, forKey: "Points")
        
        if !virtualPlist!.writeToFile(fullPathName, atomically: false){
            print("FILE FAILED TO SAVE THE CHANGES ---- PLEASE FIX IT IN GameViewController")
        }
        
        removeAllViews()
        delegate?.callUnpause()
        delegate?.playerContinue()
        
        //view.removeFromSuperview()
    }
    
    @IBAction func endGame(){
        
         removeAllViews()
        
        //print("THE VALUE IS: \(self.paused)")
        delegate?.callUnpause()
        delegate?.castEndScene()
       
       // view.removeFromSuperview()
    }
    
    
    
}