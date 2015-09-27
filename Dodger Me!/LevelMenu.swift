//
//  LevelMenu.swift
//  Dodger Me!
//
//  Created by Guan Wong on 8/5/15.
//  Copyright (c) 2015 Guan Wong. All rights reserved.
//

import SpriteKit


class LevelMenu: SKScene{
    
    var score = 0;
    var scoreBoard = SKLabelNode()
    override func didMoveToView(view: SKView){
        
        let height = 60  // height of buttons
        let width = 50   // width of buttons
        
        self.backgroundColor = SKColor.lightGrayColor()
        
        
        
        let  level_Button1 = UIButton (frame: CGRectMake(0,0,CGFloat(width),CGFloat(height)))
        level_Button1.center = CGPointMake(view.center.x - 180, view.center.y)
        level_Button1.setTitle("1", forState: .Normal)
        level_Button1.titleLabel?.font = UIFont(name: "Chalkduster", size: 30)
        level_Button1.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        level_Button1.backgroundColor = UIColor.darkGrayColor()
        level_Button1.addTarget(self, action: "lv1", forControlEvents: .TouchUpInside)
        level_Button1.layer.cornerRadius = 5.0
        view.addSubview(level_Button1)
    
        let  level_Button2 = UIButton (frame: CGRectMake(0,0,CGFloat(width),CGFloat(height)))
        level_Button2.center = CGPointMake(view.center.x - 90, view.center.y)
        level_Button2.setTitle("2", forState: .Normal)
        level_Button2.titleLabel?.font = UIFont(name: "Chalkduster", size: 30)
        level_Button2.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        level_Button2.backgroundColor = UIColor.darkGrayColor()
        level_Button2.addTarget(self, action: "lv2", forControlEvents: .TouchUpInside)
        level_Button2.layer.cornerRadius = 5.0
        view.addSubview(level_Button2)
        
        let  level_Button3 = UIButton (frame: CGRectMake(0,0,CGFloat(width),CGFloat(height)))
        level_Button3.center = CGPointMake(view.center.x, view.center.y)
        level_Button3.setTitle("3", forState: .Normal)
        level_Button3.titleLabel?.font = UIFont(name: "Chalkduster", size: 30)
        level_Button3.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        level_Button3.backgroundColor = UIColor.darkGrayColor()
        level_Button3.addTarget(self, action: "lv3", forControlEvents: .TouchUpInside)
        level_Button3.layer.cornerRadius = 5.0
        view.addSubview(level_Button3)
        
        let  level_Button4 = UIButton (frame: CGRectMake(0,0,CGFloat(width),CGFloat(height)))
        level_Button4.center = CGPointMake(view.center.x + 90, view.center.y)
        level_Button4.setTitle("4", forState: .Normal)
        level_Button4.titleLabel?.font = UIFont(name: "Chalkduster", size: 30)
        level_Button4.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        level_Button4.backgroundColor = UIColor.darkGrayColor()
        level_Button4.addTarget(self, action: "lv4", forControlEvents: .TouchUpInside)
        level_Button4.layer.cornerRadius = 5.0
        view.addSubview(level_Button4)
        
        
    }
    
    @IBAction func lv1() {
        selector(1)
    }
    
    @IBAction func lv2() {
        selector(2)
    }
    
    @IBAction func lv3() {
        selector(3)
    }
    
    
    @IBAction func lv4() {
        selector(4)
    }
    
    
    func selector (level:Int){
    
        let scene = StartGame(size: self.size)
        scene.stageLevel = level
        view?.presentScene(scene)
        
    }
    
    override func willMoveFromView(view: SKView) {
        for view in view.subviews {
            view.removeFromSuperview()
        }
    }
}
    