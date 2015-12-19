//
//  GameViewController.swift
//  Dodger Me!
//
//  Created by Guan Wong on 2/3/15.
//  Copyright (c) 2015 Guan Wong. All rights reserved.
//

import UIKit
import SpriteKit



class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       // let SIZE:CGSize = CGSize(width: 414, height: 736)
        let scene = GameScene(size: view.bounds.size)            // Configure the view.
       // let scene = GameScene(size: SIZE)
        print("the size is: \(view.bounds.size)")
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = false
            
            /* Set the scale mode to scale to fit the window */
           // scene.scaleMode = .ResizeFill
        
        skView.multipleTouchEnabled = false
        
            skView.presentScene(scene)
        }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }


}