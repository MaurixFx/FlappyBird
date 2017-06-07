//
//  Random.swift
//  FlappyBirdMx
//
//  Created by Mauricio Figueroa Olivares on 07-03-17.
//  Copyright © 2017 Mauricio Figueroa Olivares. All rights reserved.
//

import Foundation
import CoreGraphics


public extension CGFloat {
    
    public static func  randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + firstNum;
    }
    
}
