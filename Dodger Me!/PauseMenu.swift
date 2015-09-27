//
//  PauseMenu.swift
//  Dodger Me!
//
//  Created by Guan Wong on 2/18/15.
//  Copyright (c) 2015 Guan Wong. All rights reserved.
//

import UIKit
import SpriteKit

@objc protocol UnpauseDelegate{
    // add all functions you want to be able to use
    optional func callUnpause()
}


class PauseMenu: UIViewController {
    
    var delegate:UnpauseDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.greenColor()
        
        view.frame = CGRectMake(view.center.x/2 , view.center.y/2, self.view.frame.width * 0.5, self.view.frame.height * 0.5)
        
        let continueButton = UIButton (frame: CGRectMake(view.center.x/4,view.center.y/4,100,50))
        continueButton.setTitle("CONTINUE", forState: .Normal)
        continueButton.titleLabel?.font = UIFont(name: "Chalkduster", size: 15)
        continueButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        continueButton.backgroundColor = UIColor.darkGrayColor()
        continueButton.addTarget(self, action: "continueGame", forControlEvents: .TouchUpInside)
        continueButton.layer.cornerRadius = 5.0
        view.addSubview(continueButton)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    @IBAction func continueGame(){
       delegate?.callUnpause!()
      view.removeFromSuperview()
    }
    
}