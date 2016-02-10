//
//  Pause.swift
//  BallGame
//
//  Created by 平田朝飛 on 2015/12/26.
//  Copyright © 2015年 AsahiHirata. All rights reserved.
//

import Foundation
import SpriteKit

class Pause{
    var img:Sprite!
 
    //ゲームストップ
    func gameStop(target:SKScene, inout ballStopFlg:Bool, inout playGameFlg:Bool, coinSprites:[SKSpriteNode] , question:[SKSpriteNode], inout tuple:(btn:[String:SKSpriteNode],label:[String:SKLabelNode])){
        ballStopFlg = true
        playGameFlg = false
        
        Music.player.pause()
        Music.soundSE("click.mp3", scene: target)
        
        //背景
        img = Sprite(size: CGSize(width: size.width * 1, height: size.height * 1), position: CGPoint(x: size.width * 0.5, y: size.height * 0.5), alpha: 0.5, zPosition: 200, color: UIColor.blackColor())
        img.making()
        target.addChild(img)
        
        //stageNumber
        let stageNumber:Int! = Int(NSUserDefaults.standardUserDefaults().stringForKey("StageNumber")!)
        let label = Label(size: CGSize(), position: CGPoint(x: size.width * 0.5, y: size.height * 0.78), alpha: 1, zPosition: 202, color: UIColor.whiteColor())
        label.makeLabel(FontName.ChalkboardSE_Regular, size: 25, text: NSString(format: "〜 Stage %02d 〜", stageNumber) as String)
        img.addChild(label)
        
        //Questionを隠す
        if question.first != nil{
            for i in question{
                if i.size.width < 30 { break }
                let shade = Sprite(size: i.size, position: i.position, alpha: 1, zPosition: 40)
                shade.making("hatena")
                img.addChild(shade)
            }
        }
        
        //獲得コイン
        var count = 0   //コインを数える
        for i in coinSprites{if i.name == nil{count++ }}
        
        let n = Label(size: CGSize(), position: CGPoint(x: size.width * 0.5, y: size.height * 0.65), alpha: 1, zPosition: 202, color: UIColor.whiteColor())
        n.makeLabel(FontName.ChalkboardSE_Regular, size: 25, text: "\(count) / \(coinSprites.count)   Diamonds")
        img.addChild(n)
        
        //MENU
        let menu = Label(size: CGSize(), position: CGPoint(x: size.width * 0.5, y: size.height * 0.9), alpha: 1, zPosition: 202, color: UIColor.whiteColor())
        menu.makeLabel(FontName.Noteworthy_Bold, size: 40, text: "M e n u")
        img.addChild(menu)
        
        

        //ボタンの作成
        let array:[String] = ["ReSume","ReStart","Select","Sound"]
        var loop = 0
        for var t = 0, x:CGFloat = 0.25, y:CGFloat = 0.5; t < 2; t++, y = 0.2, x = 0.25 {
            for var i = 0; i < 2; i++, x = 0.75 {
                let btn = Sprite(size: CGSize(width: size.width * 0.37, height: size.width * 0.37), position: CGPoint(x: size.width * x, y: size.height * y), name: array[loop], alpha: 1, zPosition: 201)
                tuple.btn[array[loop]] = btn.making("image")
                self.img.addChild(btn)
                y -= 0.01
                x -= 0.01   //微調整
                
                let label = Label(size: CGSize(), position: CGPoint(x: size.width * x, y: size.height * y), name: array[loop], alpha: 1, zPosition: 202, color: UIColor.whiteColor())
                tuple.label[array[loop]] = label.makeLabel(FontName.ChalkboardSE_Regular, size: size.width * 0.064, text: array[loop])
                 btn.addChild(label)
                y += 0.01
                x -= 0.01

                loop++
            }
        }
    }
    
    //ゲーム再開
    func gameResumption(inout ballStopFlg:Bool, inout playGameFlg:Bool, fallSprites:[SKSpriteNode]){
        if fallSprites.first?.size != nil{ for i in fallSprites{ i.physicsBody?.velocity.dy = -200 } }
        ballStopFlg = false
        playGameFlg = true
        img.removeFromParent()
        img = nil
    }
}

