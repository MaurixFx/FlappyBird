//
//  Bird.swift
//  FlappyBirdMx
//
//  Created by Mauricio Figueroa Olivares on 06-03-17.
//  Copyright © 2017 Mauricio Figueroa Olivares. All rights reserved.
//

import SpriteKit

struct ColliderType {
    static let Bird: UInt32 = 1;
    static let Ground: UInt32 = 2;
    static let Pipes: UInt32 = 3;
    static let Score: UInt32 = 4;

}


class Bird: SKSpriteNode {
    
    var birdAnimation = [SKTexture]();
    var birdAnimationAction = SKAction();
    var diedTexture = SKTexture();
    
    func initialize(){
        
        for i in 2..<4 {
            let name = "\(GaameManager.instance.getBird()) \(i)";
            birdAnimation.append(SKTexture(imageNamed: name));  // Asignamos la imagen a la Textura
        }
        
        
        birdAnimationAction = SKAction.animate(with: birdAnimation, timePerFrame: TimeInterval(0.08), resize: true, restore: true);  // Asignamos la textura a la accion
        
        
        diedTexture = SKTexture(imageNamed: "\(GaameManager.instance.getBird()) 4");  // Asignamos la imagen del pajarito muerto a la textura
        
        //Declaramos caracteristicas y animaciones del pajaro
        self.name = "Bird";
        self.zPosition = 3;
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height / 2);
        self.physicsBody?.allowsRotation = false // con esto permitimos que el pajaro no rote
        self.physicsBody?.affectedByGravity = false;
        self.physicsBody?.categoryBitMask = ColliderType.Bird;
        self.physicsBody?.collisionBitMask = ColliderType.Ground | ColliderType.Pipes;
        self.physicsBody?.contactTestBitMask = ColliderType.Ground | ColliderType.Pipes | ColliderType.Score;
        
    }
    
    
    func flap() {
        self.physicsBody?.velocity = CGVector(dx: 0, dy: 0);
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120));
        self.run(birdAnimationAction);
    }
    
    
}
