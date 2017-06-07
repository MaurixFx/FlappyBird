//
//  GameManager.swift
//  FlappyBirdMx
//
//  Created by Mauricio Figueroa Olivares on 10-03-17.
//  Copyright © 2017 Mauricio Figueroa Olivares. All rights reserved.
//

import Foundation

class  GaameManager {
    
    static let instance = GaameManager();
    private init() {}
    
    var birdIndex = Int(0);
    var birds = ["Blue", "Green", "Red"];
    
    func getBird() -> String {
        return birds[birdIndex];
    }
    
    func incrementIndex() {
        birdIndex += 1;
        if birdIndex == birds.count {
            birdIndex = 0;
        }
    }
    
    func setHighscore(_ highscore: Int) {
        UserDefaults.standard.set(highscore, forKey: "Highscore");
    }
    
    func getHighscore() -> Int {
        return UserDefaults.standard.integer(forKey: "Highscore");
    }
    
}
