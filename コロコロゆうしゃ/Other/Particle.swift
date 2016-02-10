//
//  Particle.swift
//  BallGame
//
//  Created by 平田朝飛 on 2016/01/31.
//  Copyright © 2016年 AsahiHirata. All rights reserved.
//

import Foundation
import SpriteKit

class Particle{
   static var particle:SKEmitterNode?
    
    class func makeParticle(scene:SKScene ,position:CGPoint,zPosition:CGFloat, fileName:String){
            
            particle = SKEmitterNode(fileNamed: fileName)
        
            particle?.position = position
        
            particle?.zPosition = zPosition
        
            scene.addChild(particle!)
    
    }
    
    class func collision(nodeA:SKNode?, nodeB:SKNode?, scene:SKScene, ballSprite:SKSpriteNode, baseNode: SKNode){
        var fileName = ""
        
        //ReadFile
        if nodeA?.name == "die" || nodeB?.name == "die" || nodeA?.name == "rotation" || nodeB?.name == "rotation" || nodeA?.name == "monster" || nodeB?.name == "monster" || nodeA?.name == "teresa" || nodeB?.name == "teresa"{
           
            fileName = "MyParticle"
        }
        
        if nodeA?.name == "fall" || nodeB?.name == "fall"{
            Music.soundSE("fall.mp3", scene: scene)
            fileName = "StoneParticle"
        }
        
        if nodeA?.name == "switch" || nodeB?.name == "switch"{
            Music.soundSE("switch.mp3", scene: scene)
        }
        
        
                //候補 ball.alpha == ?
        
        if ballSprite.alpha == 1  && fileName != ""{
            print(particle)
            print(fileName)
            
            particle = SKEmitterNode(fileNamed: fileName)
        
            particle?.position = ballSprite.position
            
            if fileName == "MyParticle"{ Music.soundSE("collision.mp3", scene: scene) }
            
            //パーティクルの位置を決める
            for node in [nodeA, nodeB]{
                                
                if node?.position.y > ballSprite.position.y{ particle?.position.y += ballSprite.size.height * 0.5 }
                if node?.position.y < ballSprite.position.y{ particle?.position.y -= ballSprite.size.height * 0.5 }
                if node?.position.x > ballSprite.position.x{ particle?.position.x += ballSprite.size.height * 0.5 }
                if node?.position.x < ballSprite.position.x{ particle?.position.x -= ballSprite.size.height * 0.5 }
                
            }
            
            
            if nodeA?.name == "fall" || nodeB?.name == "fall"{
                particle?.runAction(SKAction.moveToY(particle!.position.y - 100, duration: 0.5))
            }
            particle?.zPosition = 100
            baseNode.addChild(particle!)
        
            particle?.runAction(SKAction.fadeAlphaTo(0, duration: 0.8), completion: { () -> Void in
                particle?.removeFromParent()
                particle = nil
            })
        }
    }
 }