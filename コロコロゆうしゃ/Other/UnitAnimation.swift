//
//  UnitAnimation.swift
//  BallGame
//
//  Created by 平田朝飛 on 2015/11/14.
//  Copyright © 2015年 AsahiHirata. All rights reserved.
//

import Foundation
import SpriteKit

class UnitAnimation:SKNode{
    
    class func spinAnimation(target:SKSpriteNode){
        //２秒間かけて180度回転
        let action1:SKAction = SKAction.rotateByAngle(CGFloat(M_PI), duration: 2)
        //それを永遠繰り返す
        let repeatAction = SKAction.repeatActionForever(action1)
        target.runAction(repeatAction)
    }
    
    //移動させるアニメーション
    class func moveToAnimation(target target:SKSpriteNode,firstPosition:CGPoint, secondPosition:CGPoint,time:Double){
        let action1 = SKAction.moveTo(firstPosition, duration: time)
        let action2 = SKAction.moveTo(secondPosition, duration: time)
        let wait = SKAction.moveTo(secondPosition, duration: time / 10)
        let arrayAction = SKAction.sequence([action1,action2,wait])
        target.runAction(arrayAction)
    }
    
    //透明度を変える
    class func alphaAnimation(target target:SKSpriteNode, alphaMin:CGFloat,alphaMax:CGFloat,time:Double){
        let action1 = SKAction.fadeAlphaTo(alphaMin, duration: time)
        let action2 = SKAction.fadeAlphaTo(alphaMax, duration: time)
        let arrayAction = SKAction.sequence([action1,action2])
        let repeatAction = SKAction.repeatActionForever(arrayAction)
        target.runAction(repeatAction)
    }
    
    //フェードイン & フェードアウト
    class func fadeInOuntAnimation(target:SKSpriteNode, time:Double){
        let action1 = SKAction.fadeInWithDuration(time)
        let action2 = SKAction.fadeOutWithDuration(time)
        let arrayAction = SKAction.sequence([action1,action2])
        target.runAction(arrayAction)
    }
  
    //拡大縮小
    class func bigsmallAnimation(target target:SKSpriteNode,scaleSize: CGFloat, time:Double){
        let action1 = SKAction.scaleBy(scaleSize, duration: time)
        let action2 = SKAction.scaleBy(2, duration: time)
        let arrayAction = SKAction.sequence([action1,action2])
        let repeatAction = SKAction.repeatActionForever(arrayAction)
        target.runAction(repeatAction)
    }
    
    //回転                                                               時計回りかどうか
    class func rotateAnimation(target target:SKSpriteNode, time:Double, clockwise:Bool){
        let rotate:SKAction
        if clockwise == true{   //右回り
            rotate = SKAction.sequence([SKAction.rotateToAngle(CGFloat(M_PI), duration: time, shortestUnitArc: true),SKAction.rotateToAngle(CGFloat(M_PI * 2), duration: time, shortestUnitArc: true)])
        }else{                  //左回り
            rotate = SKAction.rotateByAngle(CGFloat(M_PI), duration: time)
        }
        let repeatAction = SKAction.repeatActionForever(rotate)
        target.runAction(repeatAction)
    }

    
    //fadeout ⇨ wait ⇨ fadein(ヒント)
    class func hintAnimation(target:(question:[SKSpriteNode], line:[SKSpriteNode]), time:Double){
        let action1 = SKAction.fadeInWithDuration(time / 5)
        let action2 = SKAction.fadeOutWithDuration(time / 5)
        let action3 = SKAction.waitForDuration(time)
        let questionAction = SKAction.sequence([action2, action3])
        let lineAction = SKAction.sequence([action1, action3])
        
        for i in target.question{   //フェードアウトさせて**秒待つ
            i.runAction(questionAction) { () -> Void in
                i.runAction(action1)    //そのあとフェードイン
            }
        }
        for i in target.line{       //フェードインさせて**秒待つ
            if i.name == nil{      //左のif文は枠外のラインは表示させない
                i.runAction(lineAction) { () -> Void in
                    i.runAction(action2)    //そのあとフェードアウト
                }
            }
        }
    }
    
    //カウントダウンアニメーション
    class func countDownAnimation(countImg:[SKSpriteNode]){
        for var i = 0; i < countImg.count; i++ {
            countImg[i].runAction(SKAction.sequence([SKAction.waitForDuration(Double(i) * 1 + 0.5), SKAction.waitForDuration(0.5),SKAction.moveToY(size.height * 0.5, duration: 0.5)]))
            countImg[i].runAction(SKAction.sequence([SKAction.waitForDuration(Double(i * 1) +  2), SKAction.fadeAlphaTo(0, duration: 0.5)]))
        }
    }
    
    //クリアのとき
    class func clearAnimation(labelNodeArray:[SKLabelNode], scene:SKScene){
        Music.soundSE("ClearSound.mp3", scene: scene)
        for var i = 0; i < labelNodeArray.count; i++ {
            labelNodeArray[i].runAction(SKAction.sequence([SKAction.waitForDuration(Double(i) * 0.1), SKAction.scaleTo(2, duration: 0.1)]))
            labelNodeArray[i].runAction(SKAction.sequence([SKAction.waitForDuration((Double(i) + 0.1) * 0.15), SKAction.scaleTo(1, duration: 0.5)]))
        }
    }
    //rank sec coin が浮き出てくる
    class func resultAnimation(sec:SKLabelNode, coin:SKLabelNode, rank:SKLabelNode ,time:Double){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            sec.runAction(SKAction.fadeAlphaTo(1, duration: 1), completion: { () -> Void in
                coin.runAction(SKAction.sequence([SKAction.waitForDuration(time),SKAction.fadeAlphaTo(1, duration: 1)]), completion: { () -> Void in
                    rank.runAction(SKAction.sequence([SKAction.waitForDuration(time),SKAction.fadeAlphaTo(1, duration: 1)]))
                })
            })
        })
    }
    class func scatterAnimation(labelNodeArrays:[SKLabelNode], dy:CGFloat, target:SKScene){
         Music.soundSE("GameOverSound.mp3", scene: target)
        //ばらけるアニメーションなど
        let textArray:[String] = ["G","A","M","E","O","V","E","R"]
        var n = 0
        for var i = 0; i < textArray.count; i++ {
            labelNodeArrays[i].runAction(SKAction.moveToY(size.height * 0.45, duration: 1), completion: { () -> Void in
                let randomY = arc4random() % UInt32(size.height) + 100
                let randomX = arc4random() % UInt32(size.width) + 1
                let randomRotate = Double(arc4random() % 5)
                
                labelNodeArrays[n].runAction((SKAction.sequence([SKAction.waitForDuration(1.5),SKAction.group([SKAction.moveTo(CGPoint(x: CGFloat(randomX), y: CGFloat(randomY)), duration: 0.3),SKAction.rotateByAngle(CGFloat(M_PI * randomRotate * 11.1), duration: 0.3)])])), completion: { () -> Void in
                    target.physicsWorld.gravity = CGVector(dx:0,dy: dy)
                })
                n++
            })
        }
    }
    
    //モンスターが動くアニメーション
    class func moveMonster(monsterSprites:[SKSpriteNode]){
        for var i = 0; i < monsterSprites.count; i++ {
            var randomX = CGFloat(arc4random() % UInt32(size.width))
            var randomY = CGFloat(arc4random() % UInt32(size.height))
            if monsterSprites[i].position.x < 0 { randomX *= -1 }
            if monsterSprites[i].position.x > size.width * 1 { randomX += size.width }
            if monsterSprites[i].position.y < 0 { randomY *= -1 }
            if monsterSprites[i].position.y > size.height * 1 { randomY += size.height }
            monsterSprites[i].runAction(SKAction.moveTo(CGPoint(x: randomX, y: randomY), duration: 3))
        }
    }
    
    //テレサの動き
    class func teresaAnimation(teresa:SKSpriteNode, ballSprite:SKSpriteNode){
        if ballSprite.position.x < teresa.position.x{
            teresa.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures([SKTexture(imageNamed: "teresaleft2"), SKTexture(imageNamed: "teresaleft")], timePerFrame: 0.5)))
        }
        
        if ballSprite.position.x > teresa.position.x{
            teresa.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures([SKTexture(imageNamed: "teresaright2"), SKTexture(imageNamed: "teresaright")], timePerFrame: 0.5)))
        }
        
        teresa.runAction(SKAction.moveTo(ballSprite.position, duration: 3.5))
    }
    
    
    class func selectAnimation(btnArrays:[SKSpriteNode], starArrays:[SKLabelNode], select:ViewConfirmation, timelog:NSTimer){
        //消える
        for i in btnArrays{
            if i.name != select.number{
                i.runAction(SKAction.fadeAlphaTo(0, duration: 0.2))
            }
        }
        for star in starArrays{
            star.runAction(SKAction.fadeAlphaTo(0, duration: 0.2))
        }
        
        //小刻みに震えて、少し待って、拡大する
        btnArrays[Int(select.number)! - 1].runAction(SKAction.sequence([SKAction.waitForDuration(0.2),SKAction.repeatAction(SKAction.sequence([SKAction.moveToX(btnArrays[Int(select.number)! - 1].position.x - 10, duration: 0.05),SKAction.moveToX(btnArrays[Int(select.number)! - 1].position.x, duration: 0.05)]), count: 4)]), completion: { () -> Void in
            btnArrays[Int(select.number)! - 1].runAction(SKAction.waitForDuration(0.3), completion: { () -> Void in
                btnArrays[Int(select.number)! - 1].zPosition = 100
                btnArrays[Int(select.number)! - 1].runAction(SKAction.group([SKAction.moveTo(CGPoint(x: size.width * 0.5, y: size.height * 0.5), duration: 0.8), SKAction.scaleBy(3.5, duration: 0.8)]), completion: { () -> Void in
                    
                    timelog.invalidate()
                })
            })
        })
    }
    //チュートリアルでiphoneの動き
    class func iphoneAction(iphone:SKSpriteNode){
        let action1 = SKAction.animateWithTextures([SKTexture(imageNamed: "iphoneMain"), SKTexture(imageNamed: "iphoneLeft")], timePerFrame: 0.5)
        let action2 = SKAction.animateWithTextures([SKTexture(imageNamed: "iphoneMain"), SKTexture(imageNamed: "iphoneRight")], timePerFrame: 0.5)
        iphone.runAction(SKAction.repeatActionForever(SKAction.sequence([action1, action2])))
    }
    
    //チュートリアルでカーソルのアクション
    class func cursorAction(cursor:SKSpriteNode, time:Double){
        cursor.size.height = cursor.size.height * 0.0001
        cursor.runAction(SKAction.waitForDuration(time), completion: { () -> Void in
            cursor.size.height = cursor.size.height * 10000
            cursor.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.moveToY(cursor.position.y, duration: 0.5), SKAction.moveToY(cursor.position.y - 10, duration: 0.5)])))
        })
    }
}
