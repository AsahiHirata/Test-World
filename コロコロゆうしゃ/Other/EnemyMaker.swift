//
//  EnemyMaker.swift
//  BallGame
//
//  Created by 平田朝飛 on 2015/12/26.
//  Copyright © 2015年 AsahiHirata. All rights reserved.
//

import Foundation
import SpriteKit

class EnemyMaker{
    
    //壁
    class func makeLine(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, flg:Bool, location:SKNode, inout lineSprites:[SKSpriteNode], n:Int){
        let s = Sprite(size: CGSize(width: size.width * width, height: size.height * height), position: CGPoint(x: size.width * x, y: size.height * y), name: flg ? "line" : nil, alpha: 0, zPosition: 10, color: UIColor.blackColor())
        lineSprites.append(s.making(category: SpriteCategory.Line, collision: SpriteCategory.Ball | SpriteCategory.Question, dynamic: false, rectangle: 1))
        lineSprites[n].physicsBody?.usesPreciseCollisionDetection = true  //衝突判定正確
        location.addChild(s)
    }
    
    //ゴール生成
    class func makegoal(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, location:SKNode, inout goalSprite:SKSpriteNode){
        let n = Sprite(size: CGSize(width: width, height: height), position:  CGPoint(x: size.width * x, y: size.height * y), name: "Goal", alpha: 1, zPosition: 1)
        goalSprite = n.making("goal", category: SpriteCategory.NoCollisionEnemy, collision: 0, contact: SpriteCategory.Ball, dynamic: false, rectangle: 1)
        UnitAnimation.alphaAnimation(target: goalSprite, alphaMin: 0.2, alphaMax: 0.8, time: 1)
        location.addChild(n)
    }
    
    //warp生成
    class func makewarp(x:CGFloat, y:CGFloat, inout width:CGFloat, inout height:CGFloat, n:Int, location:SKNode, inout warpSprites:[SKSpriteNode]){
        if width == 999{ width = size.width - 20; height = size.width - 20 }
        let s = Sprite(size: CGSize(width: width, height: height), position: CGPoint(x: size.width * x, y: size.height * y), name: "Warp\(n)", alpha: 1, zPosition: 10)
        
        warpSprites.append(s.making("warp", category: SpriteCategory.NoCollisionEnemy, contact: SpriteCategory.Ball, dynamic: false, rectangle: width > 250 ? 0.8 : 0.5))
        
        UnitAnimation.spinAnimation(warpSprites[n])
        location.addChild(s)
    }
    
    //あたると死ぬ
    class func makeDie(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, location:SKNode, inout dieSprites:[SKSpriteNode]){
        let s = Sprite(size: CGSize(width: width - 2, height: height - 2), position: CGPoint(x: size.width * x, y: size.height * y), name: "die", alpha: 1, zPosition: 10)
        dieSprites += [s.making("die", category: SpriteCategory.Enemy, collision: SpriteCategory.Ball, contact: SpriteCategory.Ball, dynamic: false, rectangle: 0.6)]
        location.addChild(s)
        let randomRotate = Double(arc4random() % 5)
        dieSprites.last?.runAction(SKAction.rotateByAngle(CGFloat(M_PI * randomRotate * 11.8), duration: 0))
        
        UnitAnimation.spinAnimation(dieSprites.last!)
    }
    
    //落下物
    class func makefall(stoneSize:CGFloat, location:SKNode, inout fallSprite:[SKSpriteNode], lineSprites:[SKSpriteNode]){
        for var p = 0; p < 3; p++ {
            let randomX = arc4random() % UInt32(size.width) + 1
            let s = Sprite(size: CGSize(width: stoneSize, height: stoneSize), position: CGPoint(x: CGFloat(randomX) + (-size.width + size.width * CGFloat(p))  , y: lineSprites.last!.position.y > size.height ? size.height * 2 + 100 : size.height + 100), name: "fall", alpha: 1, zPosition: 70)
            fallSprite += [s.making("fall", category: SpriteCategory.Enemy, collision: SpriteCategory.Ball ,contact: SpriteCategory.Ball, dynamic: true, rectangle: 1)]
                    
            fallSprite.last!.physicsBody?.restitution = 2.8  //跳ね返る力
            fallSprite.last!.physicsBody?.affectedByGravity = false
            fallSprite.last!.physicsBody?.linearDamping = 0
            fallSprite.last!.physicsBody?.friction = 0    //空気抵抗とか
            fallSprite.last!.physicsBody?.mass = 1        //重さ
            fallSprite.last!.physicsBody?.velocity = CGVector(dx: 0, dy: -200)
            location.addChild(s)
        }
        
        if fallSprite.first?.position.y < -size.height - 100{
            for var i = 0; i < 3; i++ {
                fallSprite.removeFirst()
            }
        }
    }
    
    //Question?
    class func question(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, n:Int, location:SKNode, inout questionSprites:[SKSpriteNode]){
        let s = Sprite(size: CGSize(width: width, height: height), position: CGPoint(x: size.width * x, y: size.height * y), name: "question\(n)", alpha: 1, zPosition: 40)
        questionSprites.insert(s.making("hatena", category: SpriteCategory.Question, collision: SpriteCategory.Ball ,contact: SpriteCategory.Ball, dynamic: true, rectangle: 0.9), atIndex: n)
        questionSprites[n].physicsBody?.affectedByGravity = false
        location.addChild(s)
    }
    
    //ヒントポイント
    class func makeHintPoint(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, n:Int, location:SKNode, inout hintSprites:[SKSpriteNode]){
        let s = Sprite(size: CGSize(width: width, height: height), position:  CGPoint(x: size.width * x, y: size.height * y), name: "hint\(n)", alpha: 1, zPosition: 1)
        hintSprites.append(s.making("hint", category: SpriteCategory.Hint, collision: 0, contact: SpriteCategory.Ball, dynamic: false, rectangle: 1))
        UnitAnimation.alphaAnimation(target: hintSprites[n], alphaMin: 0.3, alphaMax: 1, time: 1)
        location.addChild(s)
    }
    
    //コイン
    class func makeCoin(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, n:Int, location:SKNode, inout coinSprites:[SKSpriteNode]){
        let s = Sprite(size: CGSize(width: width, height: height), position:  CGPoint(x: size.width * x, y: size.height * y), name: "coin\(n)", alpha: 1, zPosition: 20)
        coinSprites.append(s.making("coin", category: SpriteCategory.Coin, collision: 0, contact: SpriteCategory.Ball, dynamic: false, rectangle: 0.5))
        location.addChild(s)
    }
    
    //回転するやつ
    class func makeRotation(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, location:SKNode, clockwise:Bool){
        let s = Sprite(size: CGSize(width: size.width * width, height: size.height * height), position: CGPoint(x: size.width * x, y: size.height * y), name: "rotation", alpha: 1, zPosition: 45)
        let rotateSprites = s.making("rotation", category: SpriteCategory.Enemy, collision: SpriteCategory.Ball, contact: SpriteCategory.Ball, dynamic: false, rectangle: 0.9)
        UnitAnimation.rotateAnimation(target: rotateSprites, time: 3.5, clockwise: clockwise)
        location.addChild(s)
    }
    
    //ブロック
    class func makeBrock(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, location:SKNode, inout brockSprite:[SKSpriteNode]){
        let s = Sprite(size: CGSize(width: width, height: height), position: CGPoint(x: size.width * x, y: size.height * y), name: "brock", alpha: 1, zPosition: 10)
        
        brockSprite += [s.making("brock", category: SpriteCategory.Brock, collision: SpriteCategory.Ball, contact: 0, dynamic: false, rectangle: 1)]
        brockSprite.last?.physicsBody?.usesPreciseCollisionDetection = true  //衝突判定正確
        location.addChild(s)
    }
    
    //スイッチ
    class func makeSwitch(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, location:SKNode){
        let s = Sprite(size: CGSize(width: width, height: height), position: CGPoint(x: size.width * x, y: size.height * y), name: "switch", alpha: 1, zPosition: 10)
        s.making("switchoff", category: SpriteCategory.Enemy, collision: SpriteCategory.Ball, contact: SpriteCategory.Ball, dynamic: false, rectangle: 0.8)
        location.addChild(s)
    }
    
    //テレサ
    class func makeTeresa(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, location:SKNode, inout teresa:SKSpriteNode){
        let s = Sprite(size: CGSize(width: width, height: height), position: CGPoint(x: size.width * x, y: size.height * y), name: "teresa", alpha: 1, zPosition: 99)
        teresa = s.making("teresaright", category: SpriteCategory.Enemy, collision: SpriteCategory.Ball, contact: SpriteCategory.Ball, dynamic: false, rectangle: 0.5)
        location.addChild(s)
    }
    
    //ランダムに動くモンスター
    class func makeMonster(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, location:SKNode, inout monster:[SKSpriteNode]){
        let s = Sprite(size: CGSize(width: width, height: height), position: CGPoint(x: size.width * x, y: size.height * y), name: "monster", alpha: 1, zPosition: 80)
        monster += [s.making("monster", category: SpriteCategory.Enemy, collision: SpriteCategory.Ball, contact: SpriteCategory.Ball, dynamic: false, rectangle: 0.5)]
        location.addChild(s)
        UnitAnimation.alphaAnimation(target: monster.last!, alphaMin: 0.3, alphaMax: 1, time: 0.3)
        
        
    }
}