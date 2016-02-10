//
//  Tutorial.swift
//  BallGame
//
//  Created by 平田朝飛 on 2016/01/01.
//  Copyright © 2016年 AsahiHirata. All rights reserved.
//

import Foundation
import SpriteKit

class Tutorial{
    var frame:SKSpriteNode!
    var imageArrays = [SKSpriteNode]()
    var comment:UILabel!
    var scene:SKScene!
    
    class func check() -> Bool{
        let stageNumber = Int(NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.stageNumber)!)!
        let arr = NSUserDefaults.standardUserDefaults().dictionaryForKey(String(stageNumber))
        if arr == nil{
            return true
        }else{
            return false
        }
    }
    
    func makeFrame(scene:SKScene, nodeA: String? = "", nodeB:String? = "", baseNode: SKNode, inout ballStopFlg:Bool, inout timer:NSTimer!){
        
        if frame == nil{
            let stageNumber = Int(NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.stageNumber)!)!
            let arr = NSUserDefaults.standardUserDefaults().dictionaryForKey(String(stageNumber))
        
            //初めてやるステージならチュートリアルを作る
            if arr == nil{
               
                //止める
                baseNode.paused = true
                ballStopFlg = true
                timer.invalidate()
                
                //背景
                let m = Sprite(size: scene.size, position: CGPoint(x: size.width * 0.5, y: size.height * 0.5), alpha: 0, zPosition: 300, color:UIColor.blackColor())
                frame = m.making()
                scene.addChild(m)
                
                //UILabelを生成する
                comment = UILabel(frame: CGRectMake(0, 0, size.width * 0.95 ,size.height * 0.8))
                comment.layer.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
                comment.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                
                //改行させる
                comment.numberOfLines = 0
                comment.alpha = 0
                comment.font = UIFont(name: FontName.Verdana_Bold, size: size.height * 0.024)
                comment.textColor = UIColor.whiteColor()
                comment.textAlignment = NSTextAlignment.Center //中央揃え
                // 影の濃さを設定する.
                comment.layer.shadowOpacity = 0.5
                scene.view!.addSubview(comment)
        
                //ボタン
                imageSet(CGPoint(x: 0, y: -0.4), imageSize: CGSize(width: 0.15, height: 0.15), imageName: "OK", name: "Exit")
                
                //UILabelアニメーション
                frame.runAction(SKAction.fadeAlphaTo(0.7, duration: 0.5), completion: { () -> Void in
                    UIView.animateWithDuration(2, animations: { () -> Void in
                        self.comment.alpha = 1
                    })
                })
                switch stageNumber {
                    
                case 1 :
                    
                    if nodeA == "" {
                        comment.text = "ようこそ breaker の世界へ\n\n操作はカンタン!!\n\n\nお手持ちのスマートフォンを傾けるだけで、\nボールを操作することができます。\n\n\n\n\n\n\n\n\n\nまずは前方にあるダイヤを\n獲得してみましょう。\n\n\n\n\nLet's Try!!"

                        /*CGPoint(x:0, y: 0)　で　中央配置　CGPoint(x:0.5, y: 0.5)で右上配置*/
                        
                        //ボール
                        imageSet(CGPoint(x:0, y: 0.4), imageSize: CGSize(width: 0.1, height: 0.1), imageName: "ball1")
                        
                        //iphone
                        imageSet(CGPoint(x: 0, y: 0), imageSize: CGSize(width: 0.15, height: 0.3), imageName: "iphone")
                        UnitAnimation.iphoneAction(imageArrays[2])
                    }
                    
                if nodeA == "coin0" || nodeB == "coin0" {

                    comment.text = "おめでとうございます!!\n\nダイヤを獲得しました。\n\n\n\n\n\nダイヤは集めるとショップで\n便利なアイテムを購入することができます。\n\n\nステージで獲得したダイヤはゲーム中に\n画面をタッチすることで確認できます。\n\n\n\n次は青く点滅しているところに\n向かってみましょう！\n\n\n\n\n※ショップはタイトル画面から\n行くことができます。"
                    imageSet(CGPoint(x:0, y: 0.15), imageSize: CGSize(width: 0.1, height: 0.1), imageName: "coin")
                }
                    

                if nodeA == "Goal" || nodeB == "Goal"{
                    comment.text = "\n\n\nここがゴール地点です。\n\n\n\nボールがゴールの真上に来ると\nゲージが溜まります。\n\n\n\nゲージが見事全て溜まるとクリアです。\n\nゴール地点から離れるとゲージは\n空っぽになってしまうので注意しましょう。\n\n\n\n最後に、画面左上にある残り時間を過ぎると\nゲームオーバーになってしまいます。"
                    //ゴール
                    imageSet(CGPoint(x:0, y: 0.3), imageSize: CGSize(width: 0.1, height: 0.1), imageName: "goal")
                    UnitAnimation.alphaAnimation(target: imageArrays[1], alphaMin: 0.2, alphaMax: 0.8, time: 1)
                    
                    //cursor
                    imageSet(CGPoint(x:-0.3, y: 0.43), imageSize: CGSize(width: 0.4, height: 0.1), imageName: "cursor")
                    UnitAnimation.cursorAction(imageArrays[2], time: 5)
                    
                    //outゲージ
                    imageSet(CGPoint(x: 0, y: 0.24), imageSize: CGSize(width: 0.3, height: 0.05), imageName: "gauge")
                    
                    //inゲージ
                    let _in = Sprite(size: CGSize(width: imageArrays[3].size.width * 0.01, height: imageArrays[3].size.height - 5), position: CGPoint(x: 0 - imageArrays[3].size.width * 0.45, y: 0), zPosition: 400, color: UIColor.yellowColor())
                    let in_gauge = _in.making()
                    in_gauge.anchorPoint = CGPoint(x: 0, y: 0.5)
                    
                    print(imageArrays[1].position)
                    print(size)
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                        self.imageArrays[3].addChild(_in)
                    
                        //ゲージが溜まるアクション
                        in_gauge.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.scaleXTo(90, duration: 2), SKAction.scaleXTo(1, duration: 2)])))
                    })
                }
                    
                    if comment.text == nil { remove(scene) }
                    
                case 2 :
                    comment.text = "このトラップにボールがぶつかると、\n画面右上のボールの体力が減ってしまいます。\n\n\nこのトラップの近くを通る時は\n慎重に操作しましょう。\n\n\nボールの体力が無くなっても \n\nゲームオーバー \n\nになってしまうので気を付けましょう。"
                    //die
                    imageSet(CGPoint(x: 0, y: 0.25), imageSize: CGSize(width: 0.1, height: 0.1), imageName: "die")
                    UnitAnimation.spinAnimation(imageArrays[1])
                    
                    //cursor
                    imageSet(CGPoint(x:0.45, y: 0.43), imageSize: CGSize(width: 0.28, height: 0.1), imageName: "cursor")
                    UnitAnimation.cursorAction(imageArrays[2], time: 3)
                    
                case 3 :
                    comment.text = "このワープポイントにボールが来ると、\nある場所にボールがワープします。\n\n\n※ワープ中はボールの体力は減りません"
                    //ワープ
                    imageSet(CGPoint(x: 0.4, y: 0.2), imageSize: CGSize(width: 0.1, height: 0.1), imageName: "warp")
                    UnitAnimation.spinAnimation(imageArrays[1])
                    
                    //ボール
                    imageSet(CGPoint(x: -0.4, y: 0.2), imageSize: CGSize(width: 0.08, height: 0.08), imageName: "ball1")
                    imageArrays[2].runAction(SKAction.sequence([SKAction.moveTo(CGPoint(x: imageArrays[1].position.x - 50, y: imageArrays[1].position.y), duration: 4), SKAction.moveTo(imageArrays[1].position, duration: 2), SKAction.moveTo(CGPoint(x: -100, y: -100), duration: 2)]))
                    
                    
                    
                case 8 :
                    comment.text = "このモンスターはステージ内を\nぐるぐると動き回ります。\n\n\nボールとぶつかってしまうと、\n体力が一つ減るので気を付けましょう。"
                    
                    imageSet(CGPoint(x: 0.3, y: 0.3), imageSize: CGSize(width: 0.1, height: 0.1), imageName: "monster")
                    imageSet(CGPoint(x: -0.3, y: 0.3), imageSize: CGSize(width: 0.1, height: 0.1), imageName: "monster")
                    
                    imageArrays[1].runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.moveTo(CGPoint(x: -100, y: -200), duration: 2),SKAction.moveTo(CGPoint(x: 100, y: 0), duration: 2), SKAction.moveTo(CGPoint(x: 20, y: -300), duration: 2)])))
                    
                    UnitAnimation.alphaAnimation(target: imageArrays[1], alphaMin: 0.3, alphaMax: 1, time: 0.3)
                    
                    imageArrays[2].runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.moveTo(CGPoint(x: 100, y: 200), duration: 2),SKAction.moveTo(CGPoint(x: -160, y: 300), duration: 2), SKAction.moveTo(CGPoint(x: 0, y: 0), duration: 2)])))
                    
                    UnitAnimation.alphaAnimation(target: imageArrays[2], alphaMin: 0.3, alphaMax: 1, time: 0.3)
                    
                    
                case 10 ://11
                    comment.text = "このステージでは、大きな岩が落下してきます。\n\n\nぶつかるとボールの体力は減りませんが、\n凄まじい勢いでボールが飛ばされるので\n気を付けましょう。"
                    
                    //ボール
                    imageSet(CGPoint(x: -0.38, y: -0.45), imageSize: CGSize(width: 0.1, height: 0.1), imageName: "ball1")
                    imageArrays[1].runAction(SKAction.sequence([SKAction.waitForDuration(4.9), SKAction.moveTo(CGPoint(x: size.width * 0.5 , y: 0), duration: 0.8), SKAction.moveTo(CGPoint(x: size.width * -0.5 , y: 100), duration: 1.5), SKAction.moveTo(CGPoint(x: 0 , y: 200), duration: 2)]))
                    
                    //岩
                    imageSet(CGPoint(x: -0.4, y: 0.3), imageSize: CGSize(width: 0.1, height: 0.1), imageName: "fall")
                    imageArrays[2].runAction(SKAction.sequence([SKAction.waitForDuration(3), SKAction.moveTo(imageArrays[1].position, duration: 2),SKAction.moveToY(-size.height, duration: 2)]))
                    
                case 13 ://13
                    comment.text = "\n\n？ \n\nには何かが隠れているようです。\n\n\n確かめるためには\nこの灰色に点滅している場所に\n行ってみましょう。\n\n\n一時的に\n\n？\n\nの中身が見えるようになります。"
                    
                    //ヒント
                    imageSet(CGPoint(x: 0.3, y: 0.25), imageSize: CGSize(width: 0.1, height: 0.1), imageName: "hint")
                    UnitAnimation.alphaAnimation(target: imageArrays[1], alphaMin: 0.2, alphaMax: 0.8, time: 1)
                    
                    //ボール
                    imageSet(CGPoint(x: -0.4, y: 0.25), imageSize: CGSize(width: 0.08, height: 0.08), imageName: "ball1")
                    imageArrays[2].runAction(SKAction.moveToX(imageArrays[1].position.x + 30, duration: 7))
                    
                    //coin
                    imageSet(CGPoint(x: 0, y: 0.4), imageSize: CGSize(width: 0.1, height: 0.1), imageName: "coin")
                    imageArrays[3].runAction(SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0), SKAction.waitForDuration(7), SKAction.fadeAlphaTo(1, duration: 0.5),SKAction.waitForDuration(4), SKAction.fadeOutWithDuration(1)]))
                    
                    //Question
                    imageSet(CGPoint(x: 0, y: 0.4), imageSize: CGSize(width: 0.1, height: 0.1), imageName: "hatena")
                    imageArrays[4].runAction(SKAction.sequence([SKAction.waitForDuration(7), SKAction.fadeOutWithDuration(0.5),SKAction.waitForDuration(4), SKAction.fadeInWithDuration(1)]))
                    
                case 16 ://16
                    comment.text = "このトラップはぐるぐると回転し、\nボールに攻撃を仕掛けてきます。\n\n\n巧みにボールを操作して\nぶつからないようにしましょう。"
                    imageSet(CGPoint(x: 0, y: 0.3), imageSize: CGSize(width: 0.6, height: 0.02), imageName: "rotation")
                    UnitAnimation.rotateAnimation(target: imageArrays[1], time: 4, clockwise: true)
                    
                    
                case 19 : //19
                    comment.text = "このスイッチを押すと・・・!?"
                    
                    //スイッチ
                    imageSet(CGPoint(x: 0.3, y: -0.3), imageSize: CGSize(width: 0.1, height: 0.1), imageName: "switchoff")
                    imageArrays[1].runAction( SKAction.sequence([SKAction.waitForDuration(5), SKAction.animateWithTextures([SKTexture(imageNamed: "switchon")], timePerFrame: 1)]))
                    
                    //ボール
                    imageSet(CGPoint(x: -0.3, y: -0.3), imageSize: CGSize(width: 0.1, height: 0.1), imageName: "ball1")
                    imageArrays[2].runAction(SKAction.moveToX(imageArrays[1].position.x - size.width * 0.1, duration: 5))
                    
                    //ブロック
                    var x = -0.2
                    for _ in 1...5{
                        imageSet(CGPoint(x: x, y: 0.3), imageSize: CGSize(width: 0.08, height: 0.08), imageName: "brock")
                        x += 0.1
                    }
                    
                    for var i = 3; i < 8; i++ {
                        imageArrays[i].runAction(SKAction.sequence([SKAction.waitForDuration(5), SKAction.fadeAlphaTo(0, duration: 1)]))
                    }
                    
                    
                case 20 ://20
                    comment.text = "よくステージを見ると、\nこのままではゴールまで辿り着けません...。\n\n\n画面の外にもステージが続いているようです。\n\n\n画面の一番下か上まで\nボールを転がしてみましょう。"
                    
                    imageSet(CGPoint(x: -0.3, y: 0), imageSize: CGSize(width: 0.1, height: 0.1), imageName: "ball1")
                    imageArrays[1].runAction( SKAction.repeatActionForever(SKAction.sequence([SKAction.moveToY(-size.height * 0.6, duration: 2),SKAction.moveToY(0, duration: 2),SKAction.moveToY(size.height * 0.6, duration: 2),SKAction.moveToY(0, duration: 2)])))
                   
                case 28 ://28
                    comment.text = "このモンスターは\n一定の速度でボールに近づき、\n攻撃してきます。\n\n\nある程度距離を取りながら進みましょう。\n\n\nポイントは...　\n\n\nあまり遠ざからないことです。"
                    
                    //ボール
                    imageSet(CGPoint(x: -0.4, y: -0.4), imageSize: CGSize(width: 0.1, height: 0.1), imageName: "ball1")
                    imageArrays[1].runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.moveToY(size.height * 0.4, duration: 2), SKAction.moveToX(size.width * 0.4, duration: 2), SKAction.moveToY(-size.height * 0.4, duration: 2), SKAction.moveToX(-size.width * 0.4, duration: 2)])))
                    
                    //テレサ
                    imageSet(CGPoint(x: -0.4, y: -0.5), imageSize: CGSize(width: 0.1, height: 0.1), imageName: "teresaleft")
                    imageArrays[2].runAction( SKAction.sequence([SKAction.waitForDuration(1),SKAction.repeatActionForever(SKAction.sequence([SKAction.moveToY(size.height * 0.4, duration: 2), SKAction.moveToX(size.width * 0.4, duration: 2), SKAction.moveToY(-size.height * 0.4, duration: 2), SKAction.moveToX(-size.width * 0.4, duration: 2)]))]))
                                      
                default :
                    remove(scene)
                }
            }
        }
    }
    
    //敵の画像などをつくる
    func imageSet(position:CGPoint, imageSize:CGSize, imageName:String ,name:String? = nil){
       
        let image = Sprite(size: CGSize(width: size.width * imageSize.width, height: size.width * imageSize.height), position: CGPoint(x: position.x * size.width, y: position.y * size.height), zPosition: 301, alpha: 0, name: name)
        imageArrays += [image.making(imageName)]
        print(position)
        print(imageArrays.last?.position)
        frame.addChild(image)
        imageArrays.last!.runAction(SKAction.sequence([SKAction.waitForDuration(0.5), SKAction.fadeAlphaTo(1, duration: 1)]))
    }
    
    func remove(scene:SKScene){
        if let _ = frame{
            
            //start時以外は３、２、１のアニメーションをしない
            if Int(NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.stageNumber)!)! == 1 && imageArrays.count != 3 {
                NSTimer.scheduledTimerWithTimeInterval(0, target: scene, selector: "tutorialTimer", userInfo: nil, repeats: false)
            }else{
                LabelMaker.makeStartLabel(scene).runAction(SKAction.waitForDuration(4.3), completion: { () -> Void in
                    NSTimer.scheduledTimerWithTimeInterval(0, target: scene, selector: "tutorialTimer", userInfo: nil, repeats: false)
                })
            }
            
            frame.removeFromParent()
            frame = nil
            comment.removeFromSuperview()
            imageArrays.removeAll()
            print("remove")
        }
    }
}
