//
//  GamePlayScene.swift
//  FlappyBirdMx
//
//  Created by Mauricio Figueroa Olivares on 06-03-17.
//  Copyright © 2017 Mauricio Figueroa Olivares. All rights reserved.
//

import SpriteKit

class GamePlayScene: SKScene, SKPhysicsContactDelegate {

    var bird = Bird();  // Instanciamos la clase del Pajaro
    
    var pipesHolder = SKNode();   // Declaramos un nodo para los pipes (Tubos)
    var scoreLabel = SKLabelNode(fontNamed: "04b_19"); // Declaramos el label y le asignamos la fuente
    var score = 0;  // Declaramos el puntaje que ira aumentando
    
    var gameStarted = false;
    var isAlive = false;
    
    var press = SKSpriteNode();
    
    override func didMove(to view: SKView) {
        
        // Funcion que inicializa todo lo que inicia en la pantalla
        initialize();
        
        
    }
    
    // Funcion que muestra lo actualizado en pantalla frame a frame
    override func update(_ currentTime: TimeInterval){
       
        if isAlive {
            moveBackgroundsAndGrounds();
        }
      
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Esto es para la primera vez que se toca la pantalla
        if gameStarted == false {
            isAlive = true;
            gameStarted = true;
            press.removeFromParent(); // Cuando comienza el juego Eliminamos las instrucciones de la pantalla 
            spawObstacles();
            bird.physicsBody?.affectedByGravity = true;
            bird.flap();
        }
        
        if isAlive {
            bird.flap();
        }
        
        
        for touch in touches {
            let location = touch.location(in: self); // Obtiene donde fue el toque
            if atPoint(location).name == "Retry" {  // Si el punto donde se toco es el boton Retry
                
                // Reiniciamos el juego.
                self.removeAllActions();
                self.removeAllChildren();
                initialize();
                
            }
            
            if atPoint(location).name == "Quit" {  // Si el punto donde se toco es el boton Quit
                
                let mainmenu = MainMenuScene(fileNamed: "MainMenuScene");
                mainmenu?.scaleMode = .aspectFill
                self.view?.presentScene(mainmenu!, transition: SKTransition.doorway(withDuration: TimeInterval(1))); // Redireccionamos a la pantalla MainMenuScene
                
            }
            
            
            
            
        }
        
        
    }
    
    // Funcion que evalua los contactos entre los nodos
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody();
        var secondBody = SKPhysicsBody();
        
        if contact.bodyA.node?.name == "Bird" {
            firstBody = contact.bodyA;
            secondBody = contact.bodyB;
        } else {
            firstBody = contact.bodyB;
            secondBody = contact.bodyA;
        }
        
        // Evaluamos los contactos entre los dos objetos
        if firstBody.node?.name == "Bird" && secondBody.node?.name == "Score" {
            incrementScore(); // Incrementamos el puntaje
        } else  if firstBody.node?.name == "Bird" && secondBody.node?.name == "Pipe" {
           // Morir
            if isAlive {
                birdDied();
            }
            
          
        } else  if firstBody.node?.name == "Bird" && secondBody.node?.name == "Ground" {
            // Morir
            if isAlive {
                birdDied();
            }
        }
        
    }
    
    
    // Funcion que inicializa los objetos de la pantalla
    func initialize(){
        
        gameStarted = false;
        isAlive = false;
        score=0;
        
        physicsWorld.contactDelegate = self;
        
        createInstruccion();
        createBird();
        createBackgrounds();
        createGrounds();
        createLabel();
    }
    
    func createInstruccion() {
        press = SKSpriteNode(imageNamed: "Press");
        press.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        press.position = CGPoint(x: 0, y: 0);
        press.setScale(1.8);
        press.zPosition = 10;
        self.addChild(press);
    }
    
    // Funcion que crea el pajaro
    func createBird(){
        bird = Bird(imageNamed: "\(GaameManager.instance.getBird()) 1");
        bird.initialize();
        bird.position = CGPoint(x: -50, y: 0)
        self.addChild(bird);
    }
    
    // Funcion que crea el fondo y lo distribuye hasta 3 veces
    func createBackgrounds(){
        for i in 0...2 {
            let bg = SKSpriteNode(imageNamed: "BG Day");
            bg.name = "BG";
            bg.zPosition = 0;
            bg.anchorPoint = CGPoint(x: 0.5, y: 0.5);
            bg.position = CGPoint(x: CGFloat(i) * bg.size.width, y: 0);
            self.addChild(bg);
            
        }
    }
    
    // Funcion que crea el suelo y lo distribuye 3 veces
    func createGrounds(){
        for i in 0...2 {
            let ground = SKSpriteNode(imageNamed: "Ground");
            ground.name = "Ground";
            ground.zPosition = 4;
            ground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            ground.position = CGPoint(x: CGFloat(i) * ground.size.width, y: -(self.size.height/2));
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size);
            ground.physicsBody?.affectedByGravity = false;
            ground.physicsBody?.isDynamic = false;
            ground.physicsBody?.categoryBitMask = ColliderType.Ground;
            //ground.physicsBody?.collisionBitMask = ColliderType.Bird;
            //ground.physicsBody?.contactTestBitMask = ColliderType.Bird;
            self.addChild(ground);
        }
    }
    
    // Funcion que mueve el fondo y suelo de posicion
    func moveBackgroundsAndGrounds(){
        
        // Movemos el fondo
        enumerateChildNodes(withName: "BG") {
            (node, stop) in
            
            node.position.x -= 4.5;
            
            if node.position.x < -(self.frame.width){
                node.position.x += self.frame.width * 3
            }
            
        };
        
        // movemos el suelo
        enumerateChildNodes(withName: "Ground") {
            (node, stop) in
            
            node.position.x -= 2;
            
            if node.position.x < -(self.frame.width){
                node.position.x += self.frame.width * 3
            }
            
        };

    }
    
    
    func createPipes() {
        pipesHolder = SKNode();
        pipesHolder.name = "Holder";
        
        let pipeUp = SKSpriteNode(imageNamed: "Pipe 1");
        let pipeDown = SKSpriteNode(imageNamed: "Pipe 1");
        
        let scoreNode = SKSpriteNode();
        
        scoreNode.color = SKColor.red;
        scoreNode.name = "Score";
        scoreNode.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        scoreNode.position = CGPoint(x: 0, y: 0);
        scoreNode.size = CGSize(width: 5, height: 300);
        scoreNode.physicsBody = SKPhysicsBody.init(rectangleOf: scoreNode.size);
        scoreNode.physicsBody?.categoryBitMask = ColliderType.Score;
        scoreNode.physicsBody?.collisionBitMask = 0; // Si la collision esta en 0, significa que cuando el otro elemento colisione con esto, este no sera rigido, osea no chocaran
        scoreNode.physicsBody?.affectedByGravity = false;
        scoreNode.physicsBody?.isDynamic = false;
        
        
        pipeUp.name = "Pipe";
        pipeUp.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        pipeUp.position = CGPoint(x: 0, y: 630);
        pipeUp.yScale = 1.5;
        pipeUp.zRotation = CGFloat(M_PI); // Agregamos la rotacion, para rotar el tuvo en 180 grados
        pipeUp.physicsBody = SKPhysicsBody(rectangleOf: pipeUp.size); // La fisica del tuvo sera del cuerpo del tuvo
        pipeUp.physicsBody?.categoryBitMask = ColliderType.Pipes;
        pipeUp.physicsBody?.affectedByGravity = false; // cuando esta en false no atraviesa y no pasa de largo
        pipeUp.physicsBody?.isDynamic = false; // Cuando esta en false el pajaro no hace que el suelo baje
        
        pipeDown.name = "Pipe";
        pipeDown.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        pipeDown.position = CGPoint(x: 0, y: -630);
        pipeDown.yScale = 1.5;
        pipeDown.physicsBody = SKPhysicsBody(rectangleOf: pipeDown.size);
        pipeDown.physicsBody?.categoryBitMask = ColliderType.Pipes;
        pipeDown.physicsBody?.affectedByGravity = false;
        pipeDown.physicsBody?.isDynamic = false;
        
        pipesHolder.zPosition = 5;
        
        pipesHolder.position.x = self.frame.width + 100;
        pipesHolder.position.y = CGFloat.randomBetweenNumbers(firstNum: -300, secondNum: 300);
        
        pipesHolder.addChild(pipeUp); // Agregamos el tubo 1 al padre de los tubos
        pipesHolder.addChild(pipeDown); // Agregamos el tubo 2
        pipesHolder.addChild(scoreNode); // Agregamos la zona entre los tubos que permitira que aumente el puntaje
        
        self.addChild(pipesHolder);
        
        let destination = self.frame.width * 2;
        let move = SKAction.moveTo(x: -destination, duration: TimeInterval(6));
        let remove = SKAction.removeFromParent();
        
        pipesHolder.run(SKAction.sequence([move, remove]), withKey: "Move");
        
    }
    
    // Fucion que muestra los obstaculos (tubos)
    func spawObstacles() {
        let spawn = SKAction.run {
            self.createPipes();  // Llamamos la funcion que crea los tubos
        };
        
        let delay = SKAction.wait(forDuration: TimeInterval(1));
        let sequence = SKAction.sequence([spawn,delay]);
        
        self.run(SKAction.repeatForever(sequence), withKey: "Spawn");
    }
    
    // Creamos el Label que mostrara el puntaje
    func createLabel() {
        scoreLabel.zPosition = 6;
        scoreLabel.position = CGPoint(x: 0, y: 450);
        scoreLabel.fontSize = 120;
        scoreLabel.text = "0";
        self.addChild(scoreLabel);
    }
    
    // Funcion donde se incrementa el puntaje
    func incrementScore() {
        score += 1;
        scoreLabel.text = "\(score)";
    }
    
    // Funcion donde muere el Pajaro
    func birdDied() {
        
        
        self.removeAction(forKey: "Spawn"); // Como el pajaro mueve quitamos la accion donde se mueve y aparecen los tubos
        
        
        // Recorremos los tubos y zona de contacto para aumentar el puntaje
        // Eliminamos la accion Move donde se van moviendo
        for child in children {
            if child.name == "Holder" {
                child.removeAction(forKey: "Move");
            }
        }
        
        isAlive = false;
        
        bird.texture = bird.diedTexture; // Como el pajaro murio se asigna su textura de muerte
        
        let highscore = GaameManager.instance.getHighscore(); // Obtenemos el ultimo puntaje almacenado, Cuando no existe un puntaje al principio devuelve 0
        
        
        if highscore < score {
            //Si el puntaje actual es mayor al guardado, se envia para actualizar.
            GaameManager.instance.setHighscore(score);
        }
        
        
        let retry = SKSpriteNode(imageNamed: "Retry");
        let quit = SKSpriteNode(imageNamed: "Quit");
        
        retry.name = "Retry";
        retry.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        retry.position = CGPoint(x: -150, y: -150);
        retry.zPosition = 7;
        retry.setScale(0);
        
        quit.name = "Quit";
        quit.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        quit.position = CGPoint(x: 150, y: -150);
        quit.zPosition = 7;
        quit.setScale(0);
        
        let scaleUp = SKAction.scale(to: 1, duration: TimeInterval(0.5));
        
        retry.run(scaleUp);
        quit.run(scaleUp);
        
        self.addChild(retry);
        self.addChild(quit);
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
