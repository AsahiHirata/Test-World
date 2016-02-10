//
//  Life.swift
//  BallGame
//
//  Created by 平田朝飛 on 2016/01/21.
//  Copyright © 2016年 AsahiHirata. All rights reserved.
//

import Foundation
import SpriteKit

class Life{
    
    static var max = 5
    static var timeInterval:Double = 10
    
    static var selectView : ViewConfirmation!
    static var heartArrays:[SKSpriteNode!] = []
    static var label:SKLabelNode!
    
    
    class func readLife() -> Int{ return Int(NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.lifePoint)!)! }
    
    class func saveLife(value:Int) {
        NSUserDefaults.standardUserDefaults().setInteger(value, forKey: DefaultKeys.lifePoint)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func makeView(target:SKScene,y:CGFloat){
        selectView = ViewConfirmation(number: "movie")
        selectView.makeFrame(target, text: "ハートが足りません。\n\n短い動画を視聴して、ハートを全回復させますか？", twoBtns: true)
    }
    
    //ゲームが開始される
    class func gamestart(){
        
        //💙が消えるアニメーション
        heartArrays.last?.runAction(SKAction.scaleTo(0, duration: 0.5), completion: { () -> Void in
            heartArrays.last?.removeFromParent()
            heartArrays.removeLast()
        })
        
        //ライフマックスまでの時間を保存
        var currentTime = NSDate(timeIntervalSinceNow: 60 * timeInterval)
        if readLife() >= max{ currentTime = NSDate(timeIntervalSinceNow: 60 * timeInterval) }
        if readLife() <= (max - 1){
            
            //maxまでの時間
            let time = NSUserDefaults.standardUserDefaults().objectForKey(DefaultKeys.afterTime)
            //経過時間の取得
            let pastTime = time!.timeIntervalSinceDate(NSDate()) 
            
            currentTime = NSDate(timeIntervalSinceNow: 60 * timeInterval + pastTime)
            
            print("現在\(NSDate())")
            print("ライフマックスまでの時間\(NSDate(timeIntervalSinceNow: timeInterval + pastTime))")
            print("pastTime\(pastTime)")
        }
        
        NSUserDefaults.standardUserDefaults().setObject(currentTime, forKey: DefaultKeys.afterTime)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        //ライフを差し引いて保存
        saveLife(readLife() - 1)
        print("ライフ\(readLife())")
    }
    
    //ハートを表示
    class func makeHeart(y:CGFloat, target:SKNode){
        if heartArrays.first != nil{
            for var i = 0; i < heartArrays.count; i++ {
            heartArrays[i].removeFromParent()
            heartArrays.removeAll()
        }
    }
        for var i = 0 ,x:CGFloat = 0.45; i < readLife(); i++ ,x += 0.088{
            let heart = Sprite(size: CGSize(width: size.width * 0.07, height: size.width * 0.07), position: CGPoint(x: size.width * x, y: y + 10), alpha: 1, zPosition: 300)
            heartArrays.append(heart.making("blueheart"))
            target.addChild(heart)
            print(heartArrays.count)
            print(target)
        }
        
        let text = Label(size: CGSize(), position: CGPoint(x: size.width * 0.25, y: y ), alpha: 1, zPosition: 300, color: UIColor.whiteColor())
            label = text.makeLabel(FontName.Verdana_Bold, size: 15, text: "")
            target.addChild(text)
        }
    
    //あと 0 : 00 を得る
    class func getLimitTime(target:SKNode, y:CGFloat) -> String{
        //maxまでの時間
            let time = NSUserDefaults.standardUserDefaults().objectForKey(DefaultKeys.afterTime)
        
            // 経過時間の取得
            let pastTime = time!.timeIntervalSinceDate(NSDate())
            
            var min = floor(pastTime / 60)
            
            let sec = Int(floor(pastTime - min * 60))
        if readLife() < max{
            
            //ライフ一つの回復時間(min)
            for var i = 0; i < 20; i++ {
                if min >= timeInterval {
                    min -= timeInterval
                }
            }
            
            if pastTime > 0 {
                let val =  timeInterval * 60
                let point = max - Int(ceil(pastTime / val ))
                if heartArrays.count <= readLife(){ heartAnimation(y, target: target, _repeat: readLife() - heartArrays.count) }
                saveLife(point)
            }

            //SlectScene上で時間経過
            if min == 0 && sec == 0 {
                NSUserDefaults.standardUserDefaults().setInteger(readLife() + 1, forKey: DefaultKeys.lifePoint)
                NSUserDefaults.standardUserDefaults().synchronize()
                heartAnimation(y, target: target, _repeat: 1)
            }
            
            //アプリを開いた時
            if min < 0 {
//                if pastTime < 0{
                
                    saveLife(max)
                    heartAnimation(y, target: target, _repeat: max - heartArrays.count)
                    label.text = "あと 0 : 00"
                    return ""
//                }
//                saveLife(max)
            }
            
            if label != nil{
                label.text = " あと \(Int(min)) : \(sec < 10 ? "0" + String(sec) : String(sec))"
            }else{
                return ""
            }
            
            return " あと\(Int(min)) : \(sec < 10 ? "0" + String(sec) : String(sec))  lifeMaxまでのじかん\(pastTime)  Life\(readLife())  💙\(heartArrays.count)"
        }
      
        if readLife() >= max{
            saveLife(max)
            if label != nil{ label.text = "あと 0 : 00" }
            return "あと\(Int(min)) : \(sec < 10 ? "0" + String(sec) : String(sec))  lifeMaxまでのじかん\(pastTime)  Life\(readLife())MAX"
        }
        return "err"
    }
    //💙を増やす
    class func heartAnimation(y:CGFloat, target:SKNode, _repeat:Int){
         
        for var i = 0; i < _repeat; i++ {
            var x:CGFloat = size.width * 0.45
            
            if heartArrays.first != nil{ x = size.width * 0.088 + heartArrays.last!.position.x }
            let heart = Sprite(size: CGSize(width: size.width * 0.07, height: size.width * 0.07), position: CGPoint(x: x, y: y + 10), alpha: 0, zPosition: 300)
            heartArrays.append(heart.making("blueheart"))
            target.addChild(heart)

            heartArrays.last!.runAction(SKAction.sequence([SKAction.waitForDuration(0.3 * Double(i)),SKAction.fadeAlphaTo(1, duration: 0.4)]))
        }
    }
    
    //動画を見た時のアニメーション
    class func movieFinishAnimation(target:SKNode, y:CGFloat){
       
        label.removeFromParent()
        label = nil
        makeHeart(y, target: target)
        
        for var i = 0; i < heartArrays.count; i++ {
            heartArrays[i].runAction(SKAction.sequence([SKAction.waitForDuration(Double(i) * 0.1), SKAction.scaleTo(2, duration: 0.1)]))
            heartArrays[i].runAction(SKAction.sequence([SKAction.waitForDuration((Double(i)) * 0.15), SKAction.scaleTo(1, duration: 0.5)]))
        }
    }
}

