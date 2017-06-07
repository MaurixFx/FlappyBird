//
//  GameViewController.swift
//  FlappyBirdMx
//
//  Created by Mauricio Figueroa Olivares on 06-03-17.
//  Copyright © 2017 Mauricio Figueroa Olivares. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
            // Load the SKScene from 'GameScene.sks'
            if let scene = MainMenuScene(fileNamed: "MainMenuScene") {
                // Set the scale mode to scale to fit the window
                let skView = self.view as! SKView
                skView.showsFPS = false;
                skView.showsNodeCount = false;
                skView.showsPhysics = false;
                
                skView.ignoresSiblingOrder = true
                
                scene.scaleMode = .aspectFill
                
                // Present the scene
                skView.presentScene(scene)
            }
            
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
