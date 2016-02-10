//
//  AddChild.swift
//  BallGame
//
//  Created by 平田朝飛 on 2015/12/20.
//  Copyright © 2015年 AsahiHirata. All rights reserved.
//

import Foundation
import SpriteKit
class LabelMaker{
    
    var sprite = [SKSpriteNode]()
   
    static var timer:NSTimer!
    
    //StageTime
    class func makeTimer(target:SKNode, inout stageTime:(time:Double!, NSTimer:NSTimer!, label:SKLabelNode!)){
        let m = Label(size: CGSize(), position: CGPoint(x: size.width * 0.2, y: size.height * 0.97), zPosition: 100, color: UIColor.yellowColor())
    stageTime.label = m.makeLabel(FontName.ChalkboardSE_Regular, size: size.width * 0.05, text: "Time Limit \(stageTime.time)")
    target.addChild(m)
    }
    
    //3...2...1...Start!!
    class func makeStartLabel(target:SKNode) -> SKSpriteNode{
        Music.soundSE("countDown.m4a", scene:target as! SKScene, wait: 1.5)
        let n = Sprite(size: size, position: CGPoint(x: size.width * 0.5, y: size.height * 0.5), alpha: 0, zPosition: 100)
        let startlabel = n.making("start")
        target.addChild(n)
    
        //...3...2...1...を画面外に生成
        let countArray = ["Three","Two","One"]  //FileNameを管理する配列
        var countImg:[SKSpriteNode] = []
        for i in countArray{
            let sprite = Sprite(size: CGSize(width: 100, height: 100), position: CGPoint(x: size.width * 0.5, y: size.height + 100), zPosition: 100)
            countImg.append(sprite.making(i))
            target.addChild(sprite)
        }
        //カウントダウンアニメーション(3...2...1...Start!!)
        UnitAnimation.countDownAnimation(countImg)
        startlabel.runAction(SKAction.sequence([SKAction.waitForDuration(4.3),SKAction.fadeAlphaTo(1, duration: 0),SKAction.waitForDuration(0.2),SKAction.fadeAlphaTo(0, duration: 0.5)]))
        
        return startlabel
    }
    
    
    //ゲージを作る        　　　　　　                                         タプルで返す
    class func makeKeepLabel(goalSprite:SKSpriteNode,target:SKNode) ->(in_gauge:SKSpriteNode!, out_gauge:SKSpriteNode!){
        
        var x :CGFloat = goalSprite.position.x - 50
        var y :CGFloat = goalSprite.position.y - 40
        
        //画面外に行かないように
        switch goalSprite.position.x{
        case 0...size.width * 0.15:
            x = size.width * 0.1
        case size.width * 0.85...size.width:
            x = size.width * 0.7
        case size.width * 1.85...size.width * 2.0:
            x = size.width * 1.7
        case size.width...size.width * 1.15:
            x = size.width * 1.1
        case size.width * -0.15...0:
            x = size.width * -0.1
        case size.width * -1.0...size.width * -0.85:
            x = size.width * -0.7
        default :
            break
        }
        
        switch goalSprite.position.y{
        case 0...size.height * 0.15:
            y = size.height * 0.2
        case size.height...size.height * 1.15:
            y = size.height * 1.2
        case size.height * -0.15...0:
            y = size.height * -0.2
       
        default :
            break
        }
        
        //フレーム
        let _out = Sprite(size: CGSize(width: 100, height: 18), position: CGPoint(x: x, y: y), zPosition: 60)
        let out_gauge = _out.making("gauge")
        out_gauge.anchorPoint = CGPoint(x: 0, y: 0.5)
        target.addChild(_out)
        //ゲージ
        let _in = Sprite(size: CGSize(width: 1, height: 12.8), position: CGPoint(x: x + 5 , y: y), zPosition: 61, color: UIColor.yellowColor())
        let in_gauge = _in.making()
        in_gauge.anchorPoint = CGPoint(x: 0, y: 0.5)
        target.addChild(_in)
        //ゲージが溜まるアクション
        let action = SKAction.scaleXTo(90, duration: 2)
        action.timingMode = SKActionTimingMode.EaseOut      //アクションを最初速く、徐々に遅くしていく。
        in_gauge.runAction(action)
        
        return (in_gauge, out_gauge)
    }
    

    //結果画面の背景生成
    class func makeResultImage(target:SKScene){
        
        Music.player.pause()
        
        //薄い背景
        let resultImage = Sprite(size: size, position: CGPoint(x: size.width * 0.5, y: size.height * 0.5),  alpha: 0.5, zPosition: 100, color: UIColor.blackColor())
        resultImage.making()
        target.addChild(resultImage)
        
        Imobile.sharedInstance.makeBanner(target, under:true)
        
        //見えないライン
        let line = Sprite(size: CGSize(width: size.width * 2, height: 10), position: CGPoint(x: size.width * 0.5, y: Imobile.sharedInstance.benner_height), alpha: 0, zPosition: 100)
        let set = line.making("", category: SpriteCategory.Label, collision: SpriteCategory.Label, dynamic: false, rectangle: 1)
        target.addChild(line)
        set.physicsBody?.restitution = 0.3
    }
    
    //GAMEOVER or CLEAR ラベル と StageNumber
    class func makeLabels(textArray:[String],var x:CGFloat, color:UIColor, inout labelNodeArrays:[SKLabelNode], target:SKNode){
        //GAMEOVER or CLEAR!! label配置
        for var i = 0; i < textArray.count; i++ {
            let n = Label(size: CGSize(), position: CGPoint(x: size.width * CGFloat(x), y: size.height * 0.8), zPosition: 101, color: color)
            let label = n.makeLabel(FontName.Baskerville_BoldItalic, size: size.width * 0.115, text: textArray[i])
            
            label.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: label.fontSize * 0.5, height: label.fontSize * 0.5))
            label.physicsBody?.categoryBitMask = SpriteCategory.Label
            label.physicsBody?.collisionBitMask = SpriteCategory.Label | SpriteCategory.Btn
            label.physicsBody?.restitution = 0.3
            target.addChild(n)
            x += 0.12
           
            labelNodeArrays.append(label)
        }
        
        //StageName
        let stageName = Label(size: CGSize(), position: CGPoint(x: size.width * 0.5, y: size.height * 0.9), zPosition: 110, color: UIColor.whiteColor())
        stageName.makeLabel(FontName.ChalkboardSE_Regular, size: size.width * 0.07, text: "\(NSString(format: "〜 Stage %02d 〜", Int(NSUserDefaults.standardUserDefaults().stringForKey("StageNumber")!)!))")
        target.addChild(stageName)
    }
    
    //Retry と SelectStage と NextStage
    class func makeRetryLabel(target:SKScene, gameoverFlg:Bool, inout tuple:(btn:[String:SKSpriteNode],label:[String:SKLabelNode]), inout advaice:ViewConfirmation!){
        let array:[String] = ["ReTry", "Select", "Next"]
        var sprite:[SKSpriteNode] = []
        var str:[SKLabelNode] = []
        
        var x:CGFloat = 0.15
        var loop:Int = 3
        
        if gameoverFlg == true{ x = 0.325; loop = 2 }
        
        for var a = 0; a < loop; a++, x += 0.35 {
            //ボタン
           
            let btn = Sprite(size: CGSize(width: size.width * 0.3, height: size.width * 0.3), position: CGPoint(x: size.width * x, y: size.width * 0.12 + Imobile.sharedInstance.benner_height), name: array[a], alpha: 0, zPosition: 105)
            sprite += [ btn.making("image", category: SpriteCategory.Btn, collision: SpriteCategory.Label, contact: 0, dynamic: false, rectangle: btn._size.width * 0.5, circle: true)]
            target.addChild(btn)
            
            //リトライ、セレクト、ネクスト
            let label = Label(size: CGSize() ,position: CGPoint(x: size.width * x, y: size.width * 0.12 + Imobile.sharedInstance.benner_height - 5) , name: array[a], alpha: 0, zPosition: 110, color: UIColor.whiteColor())
            str += [label.makeLabel(FontName.ChalkboardSE_Regular, size: size.width * 0.063, text: array[a])]
            target.addChild(label)
            
            //touch Actionのために格納
            tuple.label[array[a]] = str[a]
            tuple.btn[array[a]] = sprite[a]
        }
        
        //アドバイス
        let random = arc4random() % 2
        if random == 0 && gameoverFlg == true{
            advaice = ViewConfirmation()
            advaice.makeFrame(target, text: "クリア出来ない...\n\nそんな時はアイテムショップを利用しよう!!", twoBtns: false)
            advaice.action(1.5)
        }
        
        //ライフ
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            if timer != nil{ timer.invalidate() }
            Life.makeHeart(size.height * 0.25, target: target)
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: target, selector: "lim", userInfo: nil, repeats: true)
        })
        
        for var i = 0; i < loop; i++ {
            str[i].runAction(SKAction.fadeAlphaTo(1, duration: 1))
            sprite[i].runAction(SKAction.fadeAlphaTo(1, duration: 1))
        }
    }
   
    
    //ClearTime:  ***, sec GetCoins: ***, Rank: ★★★
    class func makeScoreLabel(timerCount:Double, coinSprites:[SKSpriteNode], target:SKNode, stageTime:Double){
        var count = 0   //コインを数える
        for i in coinSprites{if i.name == nil{count++ }}
        
        //Rankの判定
        let star = ["★ ☆ ☆","★ ★ ☆","★ ★ ★"]
        var rank = 0
        if Double(coinSprites.count) / 2.0 <= Double(count) {rank = 1}
        if coinSprites.count == count{ rank = 2 }
        //                                                      10.4 sec                  4 / 5 coins
        let text = ["Clear Time :","Diamonds :","Rank :","\(timerCount) sec","\(count) / \(coinSprites.count) coins",star[rank]]
        var label:[SKLabelNode] = []
        var loopCount = 0
        for var i = 0, x:CGFloat = 0.05, y:CGFloat = 0.7, alpha:CGFloat = 1; i < 2; i++, x = 0.55, alpha = 0, y = 0.7 {
            for var n = 0; n < 3; n++ ,y -= 0.1{
                let clearTime = Label(size: CGSize(), position: CGPoint(x: size.width * x, y: size.height * y), alpha: alpha, zPosition: 120, color: UIColor.whiteColor())
                label += [clearTime.makeLabel(FontName.ChalkboardSE_Regular, size: size.width * 0.065, text: text[loopCount])]
                label[loopCount].horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                loopCount++
                target.addChild(clearTime)
            }
        }
        
        UnitAnimation.resultAnimation(label[3], coin: label[4], rank: label[5], time: 0.5)
        
        //ベストスコア保存
        let resultTime = round(timerCount * 10) / 10   //実数の誤差のため
        let stageNumber = NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.stageNumber)!
        
        //所持コインの追加
        if let total = NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.totalCoins) {
            NSUserDefaults.standardUserDefaults().setInteger(Int(total)! + count, forKey: DefaultKeys.totalCoins)
        }else{
            NSUserDefaults.standardUserDefaults().setInteger(count, forKey: DefaultKeys.totalCoins)
        }
        
         //StageNumberでタイムとランクとトータルコインを保存
        //if let文
        if var score = NSUserDefaults.standardUserDefaults().dictionaryForKey(stageNumber){
            score[DefaultKeys.clearcount] = Int(score[DefaultKeys.clearcount]! as! NSNumber) + 1; print("クリア回数 + 1")
            
            if Int(score[DefaultKeys.rank]! as! NSNumber) < rank{ score[DefaultKeys.rank] = rank; print("ベストランク！")}
            if Double(score[DefaultKeys.time]! as! NSNumber) > resultTime{ score[DefaultKeys.time] = resultTime; print("ベストタイム！")
                
//                //BestScore　を表示させる
//                let bestScore = Label(size: CGSize(), position: CGPoint(x: size.width * 0.5, y: size.height * 0.4), alpha: 0.5, zPosition: 101, color: UIColor.yellowColor())
//                let time = bestScore.makeLabel(FontName.Chalkduster, size: size.width * 0.1, text: "Best Time!!")
//                target.addChild(bestScore)
//                time.runAction(SKAction.sequence([SKAction.waitForDuration(2), SKAction.repeatActionForever(SKAction.fadeAlphaTo(0, duration: 0.3)), (SKAction.fadeAlphaTo(1, duration: 0.3))]))
            
            }
            NSUserDefaults.standardUserDefaults().setObject(score, forKey: stageNumber)
            
        }else{
            //初めてやるステージならその値を保存
            NSUserDefaults.standardUserDefaults().setObject([DefaultKeys.rank:rank, DefaultKeys.time:resultTime, DefaultKeys.clearcount:1], forKey:stageNumber)
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func makeLife(target:SKNode, point:Int){
        for var i = 0,x = 0.95; i < point; i++, x -= 0.1{
            let life = Sprite(size: CGSize(width: size.height * 0.035, height: size.height * 0.035), position: CGPoint(x: size.width * CGFloat(x), y: size.height * 0.98), zPosition: 50)
            sprite += [life.making("heart")]
            target.addChild(life)
        }
    }
    func removeLife(){
        sprite.last?.removeFromParent()
        sprite.removeAtIndex(sprite.count - 1)
        
        //体力残り１アクション
        if sprite.count == 1 {
            sprite.last?.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0.1), SKAction.fadeAlphaTo(1, duration: 0.1)])))
        }
    }
}



//dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
//    print( "5秒後の世界" )
//})
