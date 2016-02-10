//
//  Sprite.swift
//  BallGame
//
//  Created by 平田朝飛 on 2015/12/16.
//  Copyright © 2015年 AsahiHirata. All rights reserved.
//

import Foundation
import SpriteKit
class Sprite: Unit {
    var sprite:SKSpriteNode = SKSpriteNode()
    
    func making(imageName:String! = nil,category:UInt32 = 0, collision:UInt32 = 0, contact:UInt32 = 0,dynamic:Bool = false, rectangle:CGFloat = 1, circle:Bool = false)-> SKSpriteNode {
        if let img = imageName{ sprite.texture = SKTexture(imageNamed: img) }
        if let s = self._color{ sprite.color = s }
        
        sprite.size = self._size
        sprite.position = self._position
        sprite.zPosition = self._zPosition
        sprite.alpha = self._alpha
        sprite.name = self._name
        sprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: rectangle * self._size.width, height:  rectangle * self._size.height))
        if circle { sprite.physicsBody = SKPhysicsBody(circleOfRadius: self._size.width / 2) }  //当たり判定が円　○
        sprite.physicsBody?.dynamic = dynamic
        sprite.physicsBody?.categoryBitMask = category
        sprite.physicsBody?.contactTestBitMask = contact
        sprite.physicsBody?.collisionBitMask = collision
        self.addChild(sprite)
        
        return sprite
    }
}