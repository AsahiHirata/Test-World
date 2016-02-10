//
//  SlectScene.swift
//  BallGame
//
//  Created by 平田朝飛 on 2015/11/15.
//  Copyright © 2015年 AsahiHirata. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class SelectScene: SKScene {
    var baseNode = SKNode()
    var pageArray:[SKSpriteNode] = []
    var btnArrays:[SKSpriteNode] = []
    var starArrays:[SKLabelNode] = []
    var keyArrays = [SKSpriteNode!]()
    var shadowArrays = [SKSpriteNode!]()
    var pageCount:CGFloat = 1
    var select:ViewConfirmation!
    var beganPos:CGPoint!
    
    var timelog:NSTimer!
    
    override func didMoveToView(view: SKView) {
        
        self.addChild(baseNode)
        //広告
        Imobile.sharedInstance.makeBanner(self, under:true)
        
        //ボタンなどを配置
        self.make()
        Particle.makeParticle(self, position: CGPoint(x: size.width * 0.5, y: size.height), zPosition: 11, fileName: "snowParticle")
        
        // タイトルを表示
        let myLabel = Label(size: CGSize(), position: CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.94), color: UIColor.whiteColor())
        myLabel.makeLabel(FontName.ChalkboardSE_Regular, size: size.width * 0.08, text: "Select Stage")
        self.addChild(myLabel)
        
        // タイトル画面へ
        let backBtn = Sprite(size: CGSize(width: size.width * 0.09, height: size.width * 0.09), position: CGPoint(x: size.width * 0.5, y: size.height * 0.14), name: "BackBtn", alpha: 1, zPosition: 12)
        backBtn.making("home")
        self.addChild(backBtn)
        
        //ハート
        Life.makeHeart(size.height * 0.88, target: self)
        timelog = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "lim", userInfo: self, repeats: true)
    }
    
    func lim(){ print(Life.getLimitTime(self, y: size.height * 0.88)) }
    
    func make(){
        
        //ページ
        for var u = 0; u < 6; u++ {
            let z = Sprite(size: self.size, position: CGPoint(x: self.frame.size.width * CGFloat(u), y: 0), color: UIColor.blackColor())
            pageArray.append(z.making())
            pageArray[u].anchorPoint = CGPoint(x: 0, y: 0)
            baseNode.addChild(z)
        }
        
        var count = 1
        
        //Btnの配置
        for page in 0...5{
            for var i = 1,x = 0.2,y = 0.77; i <= 3; ++i,y -= 0.22, x = 0.2 {
                for var n = 1; n <= 3; n++,x += 0.3, count++ {
                    
                    if count > 50{ break }
                    
                    //btn作成
                    let btn = Sprite(size: CGSize(width: self.size.height * 0.18, height: self.size.height * 0.18), position: CGPoint(x: self.frame.width * CGFloat(x), y: self.frame.height * CGFloat(y)), name: String(count))
                    btnArrays += [btn.making("image")]
                    pageArray[page].addChild(btn)
                    
                    //Stage名
                    let btnLabel = Label(size: CGSize(), position: CGPoint(x: -2, y: -5), name: String(count), zPosition: 11, color: UIColor.whiteColor())
                    btnLabel.makeLabel(FontName.ChalkboardSE_Regular, size: self.size.height * 0.03, text: NSString(format: "Stage %02d", count) as String)
                    btnArrays[count - 1].addChild(btnLabel)
                    
                    //Key
                    let key = Sprite(size: CGSize(width: self.size.height * 0.07, height: self.size.height * 0.07), position: CGPoint(x: -2, y: 5), name: String(count), zPosition: 50, alpha:1)
                    keyArrays.append(key.making("key"))
                    btnArrays[count - 1].addChild(key)
                    
                    //影
                    let shadow = Sprite(size: CGSize(width: self.size.height * 0.18, height: self.size.height * 0.17), position: CGPoint(x: self.frame.width * CGFloat(x), y: self.frame.height * CGFloat(y)), name: String(count), zPosition: 30, alpha:0.5,color:UIColor.blackColor())
                    shadowArrays.append(shadow.making())
                    pageArray[page].addChild(shadow)
                }
            }
        }
        
        //初期設定
        if NSUserDefaults.standardUserDefaults().dictionaryForKey("1") == nil {
            shadowArrays[0].removeFromParent(); shadowArrays[0] = nil
            keyArrays[0].removeFromParent(); keyArrays[0] = nil
        }else{
            for var i = 0; i < 30/*9ね*/; i++ {
                shadowArrays[i].removeFromParent(); shadowArrays[i] = nil
                keyArrays[i].removeFromParent(); keyArrays[i] = nil
            }
        }
    
        //星の配置
        count = 1
        var scoreCount = 0
        let rank = ["★ ☆ ☆","★ ★ ☆","★ ★ ★"]
        var clearCount = 0
        for page in 0...5{
            for var i = 1,x = 0.19,y = 0.66; i <= 3; ++i,y -= 0.22, x = 0.19{
                for var n = 1; n <= 3; n++,x += 0.3{
                    
                    let arr = NSUserDefaults.standardUserDefaults().dictionaryForKey(String(count))
                    if arr?[DefaultKeys.rank] != nil{
                        if count > 50{ break }
                        
                        scoreCount += arr![DefaultKeys.rank]! as! Int + 1
                        
                        let star = Label(size: CGSize(), position: CGPoint(x: self.frame.width * CGFloat(x), y: self.frame.height * CGFloat(y)), color: UIColor.whiteColor())
                        starArrays += [star.makeLabel(FontName.ChalkboardSE_Regular, size: 20, text: rank[arr![DefaultKeys.rank]! as! Int])]
                        pageArray[page].addChild(star)

                        //Keyを消す処理
                        if 9 * page + 1...9 * (page + 1) ~= count { clearCount++ }
                        if clearCount >= 9 {
                            clearCount = 0
                            if page == 4{
                                for var i = 45; i < 50; i++ {
                                    shadowArrays[i].removeFromParent(); shadowArrays[i] = nil
                                    keyArrays[i].removeFromParent(); keyArrays[i] = nil
                                }
                                count++
                                break
                            }
                            for var i = 0; i < 9; i++ {
                                shadowArrays[i + (page + 1) * 9].removeFromParent(); shadowArrays[i + (page + 1) * 9] = nil
                                keyArrays[i + (page + 1) * 9].removeFromParent(); keyArrays[i + (page + 1) * 9] = nil
                            }
                        }
                    }
                    count++
                }
            }
        }
        
        //課金処理
        if NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.item + "7")! == "1"{
            for var i = 0; i < keyArrays.count; i++ {
                if keyArrays[i] != nil{
                    shadowArrays[i].removeFromParent(); shadowArrays[i] = nil
                    keyArrays[i].removeFromParent(); keyArrays[i] = nil
                }
            }
        }
        
        //戻るボタン
        let leftBtn = Sprite(size: CGSize(width: size.width * 0.08, height: size.height * 0.06), position: CGPoint(x: self.frame.width * 0.12, y: size.height * 0.15), name: "leftBtn")
        leftBtn.making("left")
        self.addChild(leftBtn)
        
        //進むボタン
        let rightBtn = Sprite(size: CGSize(width: size.width * 0.08, height: size.height * 0.06), position: CGPoint(x: self.frame.width * 0.88, y: size.height * 0.15), name: "rightBtn")
        rightBtn.making("right")
        self.addChild(rightBtn)
    }
    
    //「Start」ラベルをタップしたら、GameSceneへ遷移させる。
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            // タッチされた場所の座標を取得.
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            
            let diffPos:CGPoint = CGPointMake(location.x - beganPos.x,location.y - beganPos.y)
            
            if diffPos.x > size.width * 0.25 { leftBtn(0.25) }
            if diffPos.x < -size.width * 0.25 { rightBtn(0.25) }
            
            //動きが小さかったら位置を戻す
            if -size.width * 0.25...size.width * 0.25 ~= diffPos.x || !(-size.width * 5...0 ~= baseNode.position.x){
                baseNode.runAction(SKAction.moveToX(-size.width * (pageCount - 1), duration: 0.2))
            }
            
            if touchedNode.name != nil && -size.width * 0.05...size.width * 0.05 ~= diffPos.x && -size.width * 0.05...size.width * 0.05 ~= diffPos.y {
                if touchedNode.name != "rightBtn" && touchedNode.name != "leftBtn"{
                    Music.soundSE("click.mp3", scene: self)
                    print(touchedNode.name)
                }
        
                switch touchedNode.name!{
                    
                    case "rightBtn"://次へボタンを押した時
                        rightBtn(0.3)
                    
                    case "leftBtn"://戻るボタンを押した時
                        leftBtn(0.3)
                    
                    case "No", "OK" :
                        if select != nil {
                            select.remove()
                            select = nil
                        }
                    
                        if Life.selectView != nil{
                            Life.selectView.remove()
                            Life.selectView = nil
                        }
                    
                    case "BackBtn"://Backボタンを押した時
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.01 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                           Imobile.sharedInstance.removeBanner()
                            self.timelog.invalidate()
                            
                            let newScene = TitleScene(size: self.scene!.size)
                            newScene.scaleMode = SKSceneScaleMode.AspectFill
                            self.view!.presentScene(newScene,transition: SKTransition.fadeWithDuration(1))
                        })
                        
                    default://その他(stage選択ボタン)を押した時
                        if Life.selectView != nil && Life.selectView.number == "movie"{
                            Movie.instance.showMovie(self, view: &select)
                            break
                        }
                        
                        if select == nil{
                            if Life.readLife() <= 0 && keyArrays[Int(touchedNode.name!)! - 1] == nil{ Life.makeView(self, y:size.height * 0.88) }
                            if Life.readLife() > 0 && keyArrays[Int(touchedNode.name!)! - 1] == nil{
                                select = ViewConfirmation(number: touchedNode.name!)
                                select.makeFrame(self, text: "〜\(NSString(format: "Stage %02d", Int(touchedNode.name!)!))〜\n\nハートを１つ消費します。\nよろしいですか？", twoBtns: true)
                            }
                            
                            if keyArrays[Int(touchedNode.name!)! - 1] != nil{
                                var get = 0
                                for var i = 0; i < 50; i++ {
                                    if keyArrays[i] != nil{
                                        get = i / 9
                                        break
                                    }
                                }
                                
                                let first = NSString(format: "Stage %02d", (get - 1) * 9 + 1)
                                let last = NSString(format: "Stage %02d", get * 9)
                                select = ViewConfirmation(number: touchedNode.name!)
                                select.makeFrame(self, text: "このステージはまだ遊べません。\n\n\(first) から \(last)\nまでクリアしてください。", twoBtns: false)
                                if NSUserDefaults.standardUserDefaults().dictionaryForKey("1") == nil {
                                    select.comment.text = "このステージはまだ遊べません。\n\nStage01\nをクリアしてください。"
                                }
                            }
                        }
                       
                        if touchedNode.name == "Yes"{
                            Music.soundSE("click.mp3", scene: self)
                            Music.soundSE("GameSceneOpening.m4a", scene: self, wait: 0.1)
                            
                            UIApplication.sharedApplication().beginIgnoringInteractionEvents()// タッチイベントを無効にする.
                            UnitAnimation.selectAnimation(btnArrays, starArrays: starArrays, select: select,timelog: timelog)
                            Life.gamestart()
                            select.remove()
                            
                            //1秒後に画面遷移
                            NSTimer.scheduledTimerWithTimeInterval(1.8, target: self, selector: "nextScene", userInfo: nil, repeats: false)
                            NSUserDefaults.standardUserDefaults().setObject(select.number, forKey: DefaultKeys.stageNumber)
                            NSUserDefaults.standardUserDefaults().synchronize()
                            timelog.invalidate()
                        }
                }
            }
        }
    }
    
    func nextScene(){
        //アニメーション(遷移)
        let doorway = SKTransition.doorwayWithDuration(1)
        let newScene = GameScene(size: self.scene!.size)
        newScene.scaleMode = SKSceneScaleMode.AspectFill
        self.view!.presentScene(newScene,transition: doorway)
    }
    
    func rightBtn(speed:Double){
        if pageCount < 6 && select == nil{
            Music.soundSE("swipe.mp3", scene: self)
             UIApplication.sharedApplication().beginIgnoringInteractionEvents()// タッチイベントを無効にする.
            
            baseNode.runAction(SKAction.moveToX(self.frame.size.width * -pageCount, duration: speed), completion:{ () -> Void in
                UIApplication.sharedApplication().endIgnoringInteractionEvents()// タッチイベントを有効にする.
                self.pageCount++
            })
        }
    }
    
    func leftBtn(speed:Double){
        if pageCount > 1 && select == nil{
            Music.soundSE("swipe.mp3", scene: self)
             UIApplication.sharedApplication().beginIgnoringInteractionEvents()// タッチイベントを無効にする.
            
            baseNode.runAction(SKAction.moveToX(self.frame.size.width * -(pageCount - 2), duration: speed), completion:{ () -> Void in
                UIApplication.sharedApplication().endIgnoringInteractionEvents()// タッチイベントを有効にする.
                self.pageCount--
            })
        }
    }
    //タッチして指を動かしたら呼ばれる
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if -size.width * 5...0 ~= baseNode.position.x && select == nil{
            for touch: AnyObject in touches {
                let location = touch.locationInNode(self)
                let diffPos:CGPoint = CGPointMake(location.x - beganPos.x,location.y - beganPos.y)
                
                baseNode.runAction(SKAction.moveToX(diffPos.x + ((pageCount - 1) * -size.width)  , duration: 0.1))
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            // タッチされた場所の座標を取得.
            let location = touch.locationInNode(self)
            beganPos = location
            let touchedNode = self.nodeAtPoint(location)
            
            if (touchedNode.name != nil) {
                if let _ = Int(touchedNode.name!){
                    self.btnArrays[Int(touchedNode.name!)! - 1].runAction(SKAction.sequence([SKAction.scaleTo(1.1, duration: 0.1), SKAction.scaleTo(1, duration: 0.11)]))
                }
                touchedNode.runAction(SKAction.sequence([ SKAction.scaleTo(1.1, duration: 0.09), SKAction.scaleTo(1, duration: 0.09)]))
            }
        }
    }
}
