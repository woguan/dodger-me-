//
//  LevelMenu.swift
//  Dodger Me!
//
//  Created by Guan Wong on 8/5/15.
//  Copyright (c) 2015 Guan Wong. All rights reserved.
//

import SpriteKit


class LevelMenu: SKScene{
    
  /*  deinit{
        print(" levelmenu being deInitialized.");
        
    }
    */
    var score = 0
    var scoreBoard = SKLabelNode()
    override func didMoveToView(view: SKView){
        
        self.backgroundColor = SKColor.lightGrayColor()
        
        let level_Button1 = UIButton()
        setUpButton(level_Button1)
        level_Button1.center = CGPointMake(view.center.x - 90, view.center.y)
        level_Button1.setTitle("Classic\nMode", forState: .Normal)
        level_Button1.addTarget(self, action: #selector(LevelMenu.Mode_1), forControlEvents: .TouchUpInside)
        view.addSubview(level_Button1)
    
        let  level_Button2 = UIButton()
        setUpButton(level_Button2)
        level_Button2.center = CGPointMake(view.center.x + 90, view.center.y)
        level_Button2.setTitle("Insane\nMode", forState: .Normal)
        level_Button2.addTarget(self, action: #selector(LevelMenu.Mode_2), forControlEvents: .TouchUpInside)
        view.addSubview(level_Button2)
        
        let  level_Button4 = UIButton()
        setUpButton(level_Button4)
        level_Button4.center = CGPointMake(view.center.x, view.center.y + 120)
        level_Button4.setTitle("Back", forState: .Normal)
        level_Button4.addTarget(self, action: #selector(LevelMenu.back), forControlEvents: .TouchUpInside)
        view.addSubview(level_Button4)
        
        
    }
    
    func setUpButton(button:UIButton){
        button.frame = CGRectMake(0,0,CGFloat(100),CGFloat(100))
        button.titleLabel?.lineBreakMode = .ByCharWrapping
        button.titleLabel?.textAlignment = .Center
        button.titleLabel?.font = UIFont(name: "Chalkduster", size: 20)
        button.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        button.backgroundColor = UIColor.darkGrayColor()
        button.layer.cornerRadius = 5.0
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
        view?.presentScene(scene)
    }
    
    override func willMoveFromView(view: SKView) {
        for view in view.subviews {
            view.removeFromSuperview()
        }
    }
}
    