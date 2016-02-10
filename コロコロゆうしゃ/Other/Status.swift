//
//  Status.swift
//  BallGame
//
//  Created by 平田朝飛 on 2016/01/28.
//  Copyright © 2016年 AsahiHirata. All rights reserved.
//

import Foundation
import SpriteKit

class Status{
    
    class func readItem(ballSprite:SKSpriteNode, inout stageTime:Double, inout lifePoint:Int, inout ballSpeed:Double){
        for var i = 0; i < 7; i++ {
            //0 = false , 1 = true
            let data = Int(NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.item + "\(i)")!)!
                     print(NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.item + "\(i)"))
            print("\(data)\(i)")
            if data == 1{
                switch i{
                    
                case 1:
                    lifePoint += 1
                    
                case 2:
                    stageTime += 30.0
                    
                case 3:
                    stageTime += 60.0
                    
                case 4:
                    ballSprite.size.height *= 0.5
                    ballSprite.size.width *= 0.5
                    
                case 5:
                    ballSpeed = 15
                    ballSprite.runAction(SKAction.animateWithTextures([SKTexture(imageNamed: "ball2")], timePerFrame: 0))
                    
                case 6:
                    ballSpeed = 5
                     ballSprite.runAction(SKAction.animateWithTextures([SKTexture(imageNamed: "ball3")], timePerFrame: 0))
                    
                default:
                    break
                }
            }
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: DefaultKeys.item + "\(i)")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}