//
//  LevelMenu.swift
//  Dodger Me!
//
//  Created by Guan Wong on 8/5/15.
//  Copyright (c) 2015 Guan Wong. All rights reserved.
//

import SpriteKit


class LevelMenu: SKScene{
    
  //  deinit{
   //     print(" levelmenu being deInitialized.");
        
   // }
    
    var score = 0
    var scoreBoard = SKLabelNode()
    override func didMoveToView(view: SKView){
        
        
        let height = 100  // height of buttons
        let width = 100   // width of buttons
        
        self.backgroundColor = SKColor.lightGrayColor()
        
        let  level_Button1 = UIButton (frame: CGRectMake(0,0,CGFloat(width),CGFloat(height)))
        
        level_Button1.center = CGPointMake(view.center.x - 90, view.center.y)
        level_Button1.titleLabel?.lineBreakMode = .ByCharWrapping
        level_Button1.titleLabel?.textAlignment = .Center
        level_Button1.setTitle("Classic\nMode", forState: .Normal)
        level_Button1.titleLabel?.font = UIFont(name: "Chalkduster", size: 20)
        level_Button1.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        level_Button1.backgroundColor = UIColor.darkGrayColor()
        level_Button1.addTarget(self, action: "Mode_1", forControlEvents: .TouchUpInside)
        level_Button1.layer.cornerRadius = 5.0
        view.addSubview(level_Button1)
    
        let  level_Button2 = UIButton (frame: CGRectMake(0,0,CGFloat(width),CGFloat(height)))
        level_Button2.center = CGPointMake(view.center.x + 90, view.center.y)
        level_Button2.titleLabel?.lineBreakMode = .ByCharWrapping
        level_Button2.titleLabel?.textAlignment = .Center
        level_Button2.setTitle("Insane\nMode", forState: .Normal)
        level_Button2.titleLabel?.font = UIFont(name: "Chalkduster", size: 20)
        level_Button2.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        level_Button2.backgroundColor = UIColor.darkGrayColor()
        level_Button2.addTarget(self, action: "Mode_2", forControlEvents: .TouchUpInside)
        level_Button2.layer.cornerRadius = 5.0
        view.addSubview(level_Button2)
    /*
        let  level_Button3 = UIButton (frame: CGRectMake(0,0,CGFloat(width),CGFloat(height)))
        level_Button3.center = CGPointMake(view.center.x, view.center.y)
        level_Button3.setTitle("3", forState: .Normal)
        level_Button3.titleLabel?.font = UIFont(name: "Chalkduster", size: 30)
        level_Button3.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        level_Button3.backgroundColor = UIColor.darkGrayColor()
        level_Button3.addTarget(self, action: "Mode_3", forControlEvents: .TouchUpInside)
        level_Button3.layer.cornerRadius = 5.0
        view.addSubview(level_Button3)
        
        let  level_Button4 = UIButton (frame: CGRectMake(0,0,CGFloat(width),CGFloat(height)))
        level_Button4.center = CGPointMake(view.center.x + 90, view.center.y)
        level_Button4.setTitle("4", forState: .Normal)
        level_Button4.titleLabel?.font = UIFont(name: "Chalkduster", size: 30)
        level_Button4.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        level_Button4.backgroundColor = UIColor.darkGrayColor()
        level_Button4.addTarget(self, action: "Mode_4", forControlEvents: .TouchUpInside)
        level_Button4.layer.cornerRadius = 5.0
        view.addSubview(level_Button4)*/
        
        
        let  level_Button4 = UIButton (frame: CGRectMake(0,0,CGFloat(width),CGFloat(height)))
        level_Button4.center = CGPointMake(view.center.x, view.center.y + 120)
        level_Button4.setTitle("Back", forState: .Normal)
        level_Button4.titleLabel?.font = UIFont(name: "Chalkduster", size: 30)
        level_Button4.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        level_Button4.backgroundColor = UIColor.darkGrayColor()
        level_Button4.addTarget(self, action: "back", forControlEvents: .TouchUpInside)
        level_Button4.layer.cornerRadius = 5.0
        view.addSubview(level_Button4)
        
        
    }
    
    @IBAction func Mode_1() {
        selector("classic")
    }
    
    @IBAction func Mode_2() {
        selector("insane")
    }
    
   /* @IBAction func lv3() {
        selector(3)
    }
    
    
    @IBAction func lv4() {
        selector(4)
    }*/
    @IBAction func back() {
        let scene = GameScene(size: self.size)
        view?.presentScene(scene)
        
    }
    
    
    
    func selector (mode:String){
    
        let scene = StartGame(size: self.size)
        scene.gameMode = mode
        //scene.scorePass = level * 15000;
        view?.presentScene(scene)
        
    }
    
    override func willMoveFromView(view: SKView) {
        for view in view.subviews {
            view.removeFromSuperview()
        }
    }
}
    