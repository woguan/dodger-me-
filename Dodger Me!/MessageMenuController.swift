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


protocol MessageMenuDelegate{
    func reset_score(mode:String)
    func setFreezeMode (f:Bool)
}


class MessageMenuController: UIViewController {
    
    /* deinit{
        print("MessageMenu Controller denitialized")
    
     }*/
    
    var SIZE_LABEL:CGFloat = 15.0
    var X_POSITION_LABEL_FIX:CGFloat = 0.0
    var Y_POSITION_LABEL_FIX:CGFloat = 0.0

    
    var theMode:String? // the mode
    var delegate:MessageMenuDelegate?
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate // Create reference to the app delegate
    
    var BUTTON_WIDTH:CGFloat = 100.0 * 0.7
    var BUTTON_HEIGHT:CGFloat = 50.0 * 0.7
    var BUTTON_LETTER_SIZE:CGFloat = 15
    
    var DISTANCE_BETWEEN_BUTTONS:CGFloat = 0
    
    var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ratio = appDelegate.screenSize.width/appDelegate.screenSize.height
        
        if (ratio != 0.5625){
            fixRatio(ratio)
        }
        
        view.frame = CGRectMake(view.center.x/2 , view.center.y/2, self.view.frame.width * 0.5, self.view.frame.height * 0.5)
        // UIGraphicsBeginImageContext(view.frame.size)
        let background_img = UIImage(named: "sprites/pause_img")
        
        let someImage = UIImageView(frame: self.view.bounds)
        someImage.image = background_img
        
        someImage.contentMode = .ScaleAspectFit
        self.view.addSubview(someImage)
        
        print(view.frame.width)
        print(view.frame.height)
        // Labels
        label.lineBreakMode = .ByCharWrapping
        label.numberOfLines = 2
       // label.text = "Reset Highscore?"  // it will be set on highscore
        label.font = UIFont(name: "Chalkduster", size: SIZE_LABEL)
        label.textColor = UIColor.blackColor()
        label.frame = CGRect(x: view.frame.width/7 + X_POSITION_LABEL_FIX, y: view.frame.height/11 + Y_POSITION_LABEL_FIX, width: 150, height: 200)
        view.addSubview(label)
        
        // Buttons
        let yesButton = UIButton (frame: CGRectMake(view.frame.width/4 - 24 + DISTANCE_BETWEEN_BUTTONS, view.frame.height/2 + 60,BUTTON_WIDTH,BUTTON_HEIGHT))
        yesButton.setTitle("yes", forState: .Normal)
        yesButton.titleLabel?.font = UIFont(name: "Chalkduster", size: BUTTON_LETTER_SIZE)
        yesButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        //yesButton.tag = 2
        yesButton.backgroundColor = UIColor.darkGrayColor()
        yesButton.addTarget(self, action: #selector(MessageMenuController.yes), forControlEvents: .TouchUpInside)
        //self.yes(yesButton)
        yesButton.layer.cornerRadius = 5.0
        view.addSubview(yesButton)
        
        let noButton = UIButton (frame: CGRectMake(view.frame.width/4 + 60 - DISTANCE_BETWEEN_BUTTONS, view.frame.height/2 + 60,BUTTON_WIDTH,BUTTON_HEIGHT))
        noButton.setTitle("no", forState: .Normal)
        noButton.titleLabel?.font = UIFont(name: "Chalkduster", size: BUTTON_LETTER_SIZE)
        noButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        noButton.backgroundColor = UIColor.darkGrayColor()
        noButton.addTarget(self, action: #selector(MessageMenuController.no), forControlEvents: .TouchUpInside)
        noButton.layer.cornerRadius = 5.0
        view.addSubview(noButton)
    }
    
    func fixRatio(curr_ratio:CGFloat){
        //  print("THE RATIO IS: \(curr_ratio)")
        
        var RATIO:CGFloat = 1.0
        
        // iPhone 4S
        if (curr_ratio > 0.6){
            RATIO = 0.63333
            DISTANCE_BETWEEN_BUTTONS = 12
            X_POSITION_LABEL_FIX = 8
            Y_POSITION_LABEL_FIX = -5

        }
        // iPhone 6
        else if (curr_ratio >= 0.562 && curr_ratio < 0.563){
            RATIO = 0.9
        }
        // iPhone 5
        else{
            RATIO = 0.76
            DISTANCE_BETWEEN_BUTTONS = 10
        }
        
        BUTTON_WIDTH *= RATIO
        BUTTON_HEIGHT  *= RATIO
        BUTTON_LETTER_SIZE *= RATIO
        
        SIZE_LABEL *= RATIO
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
  
    func yes(){
        delegate?.reset_score(theMode!)
        delegate?.setFreezeMode(false)
        view.removeFromSuperview()
    }
    
    func no(){
        delegate?.setFreezeMode(false)
        view.removeFromSuperview()
    }
    
    func setMode(mode: String){
        self.theMode = mode
    }
    
}