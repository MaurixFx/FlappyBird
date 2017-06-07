//
//  MainMenuScene.swift
//  FlappyBirdMx
//
//  Created by Mauricio Figueroa Olivares on 09-03-17.
//  Copyright © 2017 Mauricio Figueroa Olivares. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    var birdbtn = SKSpriteNode();
    
    var scoreLabel = SKLabelNode();
    
    override func didMove(to view: SKView) {
        initialize();
    }
    
    func initialize() {
        createBG();
        createButtons();
        createBirdButton();
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self);
            
            if atPoint(location).name == "Play" {
                let gameplay = GamePlayScene(fileNamed: "GamePlayScene");
                gameplay?.scaleMode = .aspectFill
                self.view?.presentScene(gameplay!, transition: SKTransition.doorway(withDuration: TimeInterval(1))); // Redireccionamos a la pantalla GameplayScene
                
            } else if atPoint(location).name == "Highscore" {
                
                scoreLabel.removeFromParent();
                createLabelPuntaje();
                
            } else if atPoint(location).name == "Bird" {
                GaameManager.instance.incrementIndex();
                birdbtn.removeFromParent();
                createBirdButton();
            }
            
        }
    }
    
    func createBG() {
        let bg = SKSpriteNode(imageNamed: "BG Night");
        bg.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        bg.position = CGPoint(x: 0, y: 0);
        bg.zPosition = 0;
        self.addChild(bg);
    }
    
    func createButtons() {
        let play = SKSpriteNode(imageNamed: "Play");
        let highscore = SKSpriteNode(imageNamed: "Highscore");
        play.name = "Play";
        play.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        play.position = CGPoint(x: -180, y: -50);
        play.zPosition = 1;
        play.setScale(0.7);
        
        highscore.name = "Highscore";
        highscore.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        highscore.position = CGPoint(x: 180, y: -50);
        highscore.zPosition = 1;
        highscore.setScale(0.7);
        
        self.addChild(play);
        self.addChild(highscore);
    }
    
    func createBirdButton() {
        birdbtn = SKSpriteNode();
        birdbtn.name = "Bird";
        birdbtn.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        birdbtn.position = CGPoint(x: 0, y: 200);
        birdbtn.setScale(1.3);
        birdbtn.zPosition = 3;
        
        var birdAnim = [SKTexture]();
        
        for i in 1..<4 {
            let name = "\(GaameManager.instance.getBird()) \(i)";
            birdAnim.append(SKTexture(imageNamed: name));
        }

        let animateBird = SKAction.animate(with: birdAnim, timePerFrame: TimeInterval(0.1), resize: true, restore: true);
        
        birdbtn.run(SKAction.repeatForever(animateBird));
        
        self.addChild(birdbtn);
        
    }
    
    func createLabelPuntaje() {
        scoreLabel = SKLabelNode(fontNamed: "04b_19");
        scoreLabel.fontSize = 120;
        scoreLabel.position = CGPoint(x: 0, y: -400);
        scoreLabel.text = "\(GaameManager.instance.getHighscore())";
        self.addChild(scoreLabel);
        
        
    }
    
    
}
