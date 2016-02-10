//
//  BallController.swift
//  BallGame
//
//  Created by 平田朝飛 on 2016/01/03.
//  Copyright © 2016年 AsahiHirata. All rights reserved.
//

import Foundation
import SpriteKit

class BallController{

    class func makeBall(x:CGFloat, y:CGFloat, location:SKNode, inout ball:SKSpriteNode!){
        let n = Sprite(size: CGSize(width: 30 * size.width * 0.0027, height: 30 * size.width * 0.0027), position: CGPoint(x: x, y: y), alpha: 1, zPosition: 50)
        ball = n.making("ball1", category: SpriteCategory.Ball, collision: SpriteCategory.Enemy | SpriteCategory.Line | SpriteCategory.Brock, contact: 0, dynamic: true, rectangle: 1, circle: true)
        
        ball.physicsBody?.linearDamping = 1
        ball.physicsBody?.affectedByGravity = false   //重力の影響を受けなくさせる.
        location.addChild(n)
    }
    
    
    class func categorySet(inout ball:SKSpriteNode!){
        ball.physicsBody?.categoryBitMask = SpriteCategory.Ball
        ball.physicsBody?.collisionBitMask = SpriteCategory.Enemy | SpriteCategory.Line | SpriteCategory.Brock
        ball.physicsBody?.contactTestBitMask = SpriteCategory.Enemy | SpriteCategory.NoCollisionEnemy | SpriteCategory.Coin | SpriteCategory.Hint
    }
    
    
    class func always(var positionData:CGPoint, inout ballSprite:SKSpriteNode!, inout baseNode:SKNode, flg:Bool){
        //加速度センサのXをキャラクタのx座標に設定
        if flg == false {
            if positionData.x > 0.2 || positionData.x < -0.2 || positionData.y > 0.2 || positionData.y < -0.2{
                if positionData.x > 7{ positionData.x = 7 }
                if positionData.x < -7{ positionData.x = -7 }
                if positionData.y > 7{ positionData.y = 7 }
                if positionData.y < -7{ positionData.y = -7 }
            
                ballSprite.position = CGPoint(x: ballSprite.position.x + CGFloat(positionData.x), y: ballSprite.position.y + CGFloat(positionData.y))
            }
        }
        
        //画面移動
        baseNode.position = CGPoint(x: 0, y: 0)
        if ballSprite.position.x < 0 { baseNode.position.x = size.width }
        if ballSprite.position.x > size.width * 1 { baseNode.position.x = -size.width }
        if ballSprite.position.y < 0 { baseNode.position.y = size.height }
        if ballSprite.position.y > size.height * 1 { baseNode.position.y = -size.height }
    }
}
