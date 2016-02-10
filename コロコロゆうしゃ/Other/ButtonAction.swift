//
//  ButtonAction.swift
//  BallGame
//
//  Created by 平田朝飛 on 2016/01/19.
//  Copyright © 2016年 AsahiHirata. All rights reserved.
//

import Foundation
import SpriteKit

class ButtonAction{
    
    class func touch(touchedNode:SKNode, pause:Pause, target:SKScene, gameoverFlg:Bool, inout playGameFlg:Bool, inout ballStopFlg:Bool, inout stageTime:NSTimer!, baseNode:SKNode, inout selectView:ViewConfirmation!, fallSprites: [SKSpriteNode], ballSprite:SKSpriteNode, vel:CGVector, tutorial: Tutorial){
        if (touchedNode.name != nil) {
           Music.soundSE("click.mp3", scene: target)
            switch touchedNode.name!{
           
            case "Exit" :
                
                tutorial.remove(target)
                
            case "Select" : //SelectSceneに遷移
                if pause.img != nil {
                    selectView = ViewConfirmation(number: touchedNode.name!)
                    selectView.makeFrame(target, text: "セレクト画面に戻りますか？\n\n※このステージで獲得した\nダイヤはすべて失われます。", twoBtns: true)
                }
                if pause.img == nil {
                    if pause.img != nil{ selectView.remove() }
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.01 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                        let newScene = SelectScene(size: target.scene!.size)
                        newScene.scaleMode = SKSceneScaleMode.AspectFill
                        target.view!.presentScene(newScene,transition: SKTransition.fadeWithDuration(1))
                    })
                }
                
            case "ReTry" : //GameSceneに遷移
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.01 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                    
                        if Life.readLife() <= 0 { Life.makeView(target,y: size.width * 0.15 + 50 + size.width * 0.15 + 10) }
                    
                        if Life.readLife() >= 1{
                            
                            //ライフ消費なし
                            if gameoverFlg == true{  Life.gamestart() }
                           
                            let newScene = GameScene(size: target.scene!.size)
                            newScene.scaleMode = SKSceneScaleMode.AspectFill
                            target.view!.presentScene(newScene,transition: SKTransition.fadeWithDuration(1))
                    }
                })

                                
            case "Next" :
                if touchedNode.name == "Next" {
                    if Life.readLife() <= 0{ Life.makeView(target, y: size.width * 0.15 + 50 + size.width * 0.15 + 10) }

                    if Life.readLife() >= 1{
                        let stageNumber:Int! = Int(NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.stageNumber)!)
                        NSUserDefaults.standardUserDefaults().setObject(stageNumber + 1, forKey: DefaultKeys.stageNumber)
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.01 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                            let newScene = GameScene(size: target.scene!.size)
                            newScene.scaleMode = SKSceneScaleMode.AspectFill
                            target.view!.presentScene(newScene,transition: SKTransition.fadeWithDuration(1))
                            Life.gamestart()
                        })
                    
                    }
                }
                
            case "ReStart" :
                selectView = ViewConfirmation(number: touchedNode.name!)
                selectView.makeFrame(target, text: "このステージをやり直します。\nよろしいですか？", twoBtns: true)
                
            case "ReSume" : //ゲームに戻る

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                    Music.player.play()
                })
                
                pause.gameResumption(&ballStopFlg, playGameFlg: &playGameFlg, fallSprites: fallSprites)
                stageTime = NSTimer.scheduledTimerWithTimeInterval(0.1, target: target, selector: "limit", userInfo: nil, repeats: true)
                baseNode.paused = false
                ballSprite.physicsBody?.velocity = vel
                
            case "OK","No" :
                if selectView != nil {
                    selectView.remove()
                    selectView = nil
                }
                
                if Life.selectView != nil{
                    Life.selectView.remove()
                    Life.selectView = nil
                }
                
            case "Yes" :
                if Life.selectView != nil{
                    Movie.instance.showMovie(target, view: &selectView)
                    break
                }
                              
                switch selectView.number{
                   /**********************************************ネスト**************************************************/
                case "Select" : //Selectへ画面遷移
                    selectView.remove()
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.01 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                        let newScene = SelectScene(size: target.scene!.size)
                        newScene.scaleMode = SKSceneScaleMode.AspectFill
                        target.view!.presentScene(newScene,transition: SKTransition.fadeWithDuration(1))
                    })
                case "ReStart" :   //GameSceneへ画面遷移
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.01 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                        selectView.remove()
                        let newScene = GameScene(size: target.scene!.size)
                        newScene.scaleMode = SKSceneScaleMode.AspectFill
                        target.view!.presentScene(newScene,transition: SKTransition.fadeWithDuration(1))
                    })

                default:
                    break
                }
                /**********************************************ネスト**************************************************/
            case "Sound" : //設定
                
               let readSetting = NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.sound)!
                
                //オンにする
                if readSetting == "0"{
                    Music.player.volume = 0.9
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: DefaultKeys.sound)
                }
                //オフにする
                if readSetting == "1"{
                    Music.player.volume = 0
                    NSUserDefaults.standardUserDefaults().setBool(false, forKey: DefaultKeys.sound)
                }
               
               NSUserDefaults.standardUserDefaults().synchronize()
                
               selectView = ViewConfirmation()
               selectView.makeFrame(target, text: "サウンドを\(readSetting == "0" ? " ON " : " OFF ")にしました" , twoBtns: false)
                
            default :
                break
            }
        }
    }
}

