//
//  TitleScene.swift
//  BallGame
//
//  Created by 平田朝飛 on 2015/11/10.
//  Copyright © 2015年 AsahiHirata. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import GameKit
import Social

class TitleScene: SKScene,GKGameCenterControllerDelegate{
    
    let errorView = ViewConfirmation()
    var is_Touch = false
    var shareLabel:SKLabelNode?
    
    override func didMoveToView(view: SKView) {
         // テスト用  NSUserDefaults.standardUserDefaults().setBool(false, forKey: DefaultKeys.share)
        //初回時のみ0を保存
        if NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.share) == nil {

            NSUserDefaults.standardUserDefaults().setBool(true, forKey: DefaultKeys.sound)
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: DefaultKeys.share)
        }
        
        if NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.ballHeart) == nil {
            NSUserDefaults.standardUserDefaults().setInteger(2, forKey: DefaultKeys.ballHeart)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: DefaultKeys.sound)
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: DefaultKeys.share)
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: DefaultKeys.totalCoins)
            NSUserDefaults.standardUserDefaults().setInteger(Life.max, forKey: DefaultKeys.lifePoint)
            NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: DefaultKeys.afterTime)
            
            for var i = 0; i < 9; i++ {
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: DefaultKeys.item + String(i))
                print(DefaultKeys.item + String(i))
            }
        }
                
        print(NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.item + "7"))
        print(NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.item + "8"))

      
        NSUserDefaults.standardUserDefaults().synchronize()
        
        // タイトルを表示。
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "無料！コロコロゆうしゃ！"
        myLabel.fontSize = 25
        myLabel.fontColor = UIColor.brownColor()
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(myLabel)
        
        // 「Start」を表示。
        let startLabel = SKLabelNode(fontNamed: "ChalkboardSE-Regular")
        startLabel.text = "Start"
        startLabel.fontSize = 50
        startLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: 200)
        startLabel.name = "Start"
        self.addChild(startLabel)
        
        //GameCenter
        let gamecenter = Sprite(size: CGSize(width: size.width * 0.1, height: size.width * 0.1), position: CGPoint(x: size.width * 0.2, y: size.height * 0.2), name: "GameCenter", zPosition: 20)
        gamecenter.making("GameCenter")
        self.addChild(gamecenter)
        
        //shop
        let shop = Sprite(size: CGSize(width: size.width * 0.1, height: size.width * 0.1), position: CGPoint(x: size.width * 0.5, y: size.height * 0.2), name: "shop", zPosition: 20)
        shop.making("shop")
        self.addChild(shop)
        
        //結果
        let result = Sprite(size: CGSize(width: size.width * 0.09, height: size.width * 0.09), position: CGPoint(x: size.width * 0.8, y: size.height * 0.2), name: "result", zPosition: 20)
        result.making("ranking")
        self.addChild(result)
        
        //ツイートボタン
        let twBtn = Sprite(size: CGSize(width: size.width * 0.1, height: size.width * 0.1), position: CGPoint(x: size.width * 0.5, y: size.height * 0.1), name: "twBtn", zPosition: 20)
        twBtn.making("twBtn")
        self.addChild(twBtn)
        
        //シェアコメント
        if NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.share) == "0" {
            
            let share = Label(size: CGSize(), position: CGPoint(x: size.width * 0.5, y: size.height * 0.03), zPosition: 50, color: UIColor.whiteColor())
            shareLabel = share.makeLabel(FontName.Noteworthy_Bold, size: size.width * 0.03, text: "シェアすると ダイヤ50個 プレゼント！！")
            self.addChild(share)
            shareLabel?.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.fadeOutWithDuration(0.5), SKAction.fadeInWithDuration(0.5)])))
        }
        
        //GameCenterにスコア送信
        var star = 0
        var clear = 0
        for var i = 0; i < 50; i++ {
            if let arr = NSUserDefaults.standardUserDefaults().dictionaryForKey(String(i + 1)){
                star += arr[DefaultKeys.rank]! as! Int + 1
                clear += arr[DefaultKeys.clearcount]! as! Int 
            }
        }
        
        //yamamuroにきく**************************
        let idList = ["star_count", "coin_count","clear_count"]
        let scoreList = [star, Int(NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.totalCoins)!)!, clear]

        for var i = 0; i < idList.count; i++ {
            let myScore = GKScore(leaderboardIdentifier: idList[i])
            myScore.value = Int64(scoreList[i])
            GKScore.reportScores([myScore], withCompletionHandler: { (error) -> Void in
                if error != nil {
                    print("game center send error. \(error!.code).\(error!.description)")
                } else {
                    print("game center send success")
                }
            })
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            
            // タッチされた場所の座標を取得.
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            if (touchedNode.name != nil) {
                
                touchedNode.runAction(SKAction.scaleTo(1.1, duration: 0.1), completion: { () -> Void in
                    touchedNode.runAction(SKAction.scaleTo(1, duration: 0.1))
                })
            }
        }
    }
    
    //「Start」ラベルをタップしたら、GameSceneへ遷移させる。
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            // タッチされた場所の座標を取得.
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            
            if (touchedNode.name != nil) && (is_Touch == false) {
                Music.soundSE("click.mp3", scene: self)
                
                if touchedNode.name != "OK" && touchedNode.name != "GameCenter" && touchedNode.name != "twBtn"{  is_Touch = true }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.01 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                     let transition = SKTransition.fadeWithDuration(1)
                    switch touchedNode.name! {
                
                    case "Start":
                        let newScene = SelectScene(size: self.scene!.size)
                        newScene.scaleMode = SKSceneScaleMode.AspectFill
                        self.view!.presentScene(newScene,transition: transition)
                
                    case "result":
                        let newScene = ResultSecne(size: self.scene!.size)
                        newScene.scaleMode = SKSceneScaleMode.AspectFill
                        self.view!.presentScene(newScene,transition: transition)
                    
                    case "shop":
                        let newScene = ShopScene(size: self.scene!.size)
                        newScene.scaleMode = SKSceneScaleMode.AspectFill
                        self.view!.presentScene(newScene,transition: transition)
                        
                    case "twBtn":
                        let twVC:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
                        
                        //投稿テキストを設定
                        twVC.setInitialText("みんなもあそんでみよう！")
                        
                        /***********************URLを変更する***********************/
                        twVC.addURL(NSURL(string: "https://itunes.apple.com/jp/app/breaker-burokku-bengshi-30miaodedokomade/id997366267?mt=8"))
                       
                        //投稿コントローラーを起動
                        self.view?.window?.rootViewController?.presentViewController(twVC, animated: true, completion: nil)
                        
                        //シェア後に呼ばれる
                        twVC.completionHandler = { (result:SLComposeViewControllerResult) in
                            print(result.rawValue)
                            if result.rawValue == 1{
                                 if NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.share) == "0"{
                                    self.errorView.makeFrame(self, text: "ありがとうございます。\n\nダイヤが50個\n付与されました。", twoBtns: false)
                                
                                    //コイン50枚付与
                                    let totalCoin = Int(NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.totalCoins)!)!
                                    NSUserDefaults.standardUserDefaults().setInteger(totalCoin + 50, forKey: DefaultKeys.totalCoins)
                                
                                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: DefaultKeys.share)
                                    NSUserDefaults.standardUserDefaults().synchronize()
                                
                                    self.shareLabel?.removeFromParent()
                                }
                            }
                        }
                    
                    case "OK" :
                    self.errorView.remove()
                        
                    case "GameCenter" :
                        let localPlayer = GKLocalPlayer()
                        localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler({ (leaderboardIdentifier : String?, error : NSError?) -> Void in
                            if error != nil {
                                print("game center show error. \(error!.description)")
                                self.errorView.makeFrame(self, text: "GameCenterにログインしていません。", twoBtns: false)
                            } else {
                                //GameCenterをクリックした時
                                let gameCenterController:GKGameCenterViewController = GKGameCenterViewController()
                                gameCenterController.gameCenterDelegate = self
                                gameCenterController.viewState = GKGameCenterViewControllerState.Leaderboards
                                gameCenterController.leaderboardIdentifier = "star_count"
                                self.view?.window?.rootViewController?.presentViewController(gameCenterController, animated: true, completion: nil)
                            }
                        })
                    
                    default :
                        break
                    }
                })
            }
        }
    }
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }

    override func update(currentTime: CFTimeInterval) {}
}

