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

       // let FORCERESET = true
        
        //1 - Updating the documentDirectory
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let fullPathName = documentDirectory.stringByAppendingPathComponent("dodger.plist") as String
        var virtualPlist = NSMutableDictionary(contentsOfFile:fullPathName)
        
        //2 - Create a filemanager to check if there is a documentDirectory
        let fileManager = NSFileManager.defaultManager()
    
        //3 - Checking if there exists one
        if !fileManager.fileExistsAtPath(fullPathName) {
            
            //4 - Copying the original to the "fake" one
            if  let sourceFilePath = NSBundle.mainBundle().pathForResource("dodger", ofType: "plist") {
    
                    print("virtualPlist updated. REASON: virtualPlist do not exist")
                        let originalPlist = NSMutableDictionary(contentsOfFile:sourceFilePath)
                        
                        virtualPlist = originalPlist
                
                // Saving the virtual plist
                        if !virtualPlist!.writeToFile(fullPathName, atomically: false){
                            print("FILE FAILED TO SAVE THE CHANGES ---- PLEASE FIX IT IN GameViewController")
                        }
                
                
            } else {
                print("dodger.plist not found")
            }
        }
        else{
            // If it's here... virtualPlist exists. 
            // Let check if both roots have same number of items
            
            if  let sourceFilePath = NSBundle.mainBundle().pathForResource("dodger", ofType: "plist") {
                
                
                let originalPlist = NSMutableDictionary(contentsOfFile:sourceFilePath)
                
                // replace the virtual if the roots have different size
                if (virtualPlist!.count != originalPlist!.count){
                    print("virtualPlist updated. REASON: Different size")
                virtualPlist = originalPlist
                
                // Saving the virtual plist
                if !virtualPlist!.writeToFile(fullPathName, atomically: false){
                    print("FILE FAILED TO SAVE THE CHANGES ---- PLEASE FIX IT IN GameViewController")
                }
                } else {
                    // same size... all good to proceed
                    
                    // FOR SELF USE PURPOSE
               /*     if (FORCERESET){
                        let originalPlist = NSMutableDictionary(contentsOfFile:sourceFilePath)
                        
                        virtualPlist = originalPlist
                        if !virtualPlist!.writeToFile(fullPathName, atomically: false){
                            print("FILE FAILED TO SAVE THE CHANGES ---- PLEASE FIX IT IN GameViewController")
                        }
                    }*/
                    
                }
                
            } else {
                print("dodger.plist not found")
            }
            
        }
        
        
        
        
            let scene = GameScene(size: view.bounds.size)            // Configure the view.
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