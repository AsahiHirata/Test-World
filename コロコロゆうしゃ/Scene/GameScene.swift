//
//  GameScene.swift
//  BallGame
//
//  Created by 平田朝飛 on 2015/11/09.
//  Copyright (c) 2015年 AsahiHirata. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene,SKPhysicsContactDelegate {
    var baseNode = SKNode()
    var positionData = CGPoint(x: 0, y: 0)
    var vel:CGVector = CGVector(dx: 0, dy: 0)
    
    var ballSprite: SKSpriteNode!
    var goalSprite = SKSpriteNode()
    var fallSprites:[SKSpriteNode] = []
    var dieSprites:[SKSpriteNode] = []
    var teresa = SKSpriteNode()
    var brockSprite: [SKSpriteNode] = []
    var lineSprites: [SKSpriteNode] = []
    var warpSprites: [SKSpriteNode] = []
    var questionSprites: [SKSpriteNode] = []
    var hintSprites: [SKSpriteNode] = []
    var coinSprites: [SKSpriteNode] = []
    var monsterSprites: [SKSpriteNode] = []
    
    var stoneSize:CGFloat!
    var warplocations:[CGPoint] = []
    
    var stageTime: (time:Double!, NSTimer:NSTimer!, label:SKLabelNode!)
    var keepgauge: (in_gauge:SKSpriteNode!, out_gauge:SKSpriteNode!)
    var warpCount:Double!
    var timerCount:Double = 0
    
    var timerFlg = false
    var onGoalFlg = false
    var ballStopFlg = true
    var gameoverFlg = false
    var playGameFlg = false
    
    var tupleDic:(btn:[String:SKSpriteNode], label:[String:SKLabelNode]) = ([:],[:])
    var labelNodeArrays:[SKLabelNode] = []
    
    let life = LabelMaker()
    let pause = Pause()
    var tutorial = Tutorial()
    var selectView: ViewConfirmation!
    
    override func didMoveToView(view: SKView) {
        
        UIApplication.sharedApplication().endIgnoringInteractionEvents()// タッチイベントを有効にする.
        Music.audioPlayerDif()
        
        if Imobile.sharedInstance.bannerView != nil{ Imobile.sharedInstance.removeBanner() }
        //重力設定
        self.physicsWorld.gravity = CGVector(dx:0,dy:0)
        self.physicsWorld.contactDelegate = self
        
        self.addChild(baseNode)
        self.makeStage()
        var lifePoint = Int(NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.ballHeart)!)!
        var ballSpeed:Double = 10
        
        life.makeLife(self, point: lifePoint)
        
        //Itemの反映
        Status.readItem(ballSprite, stageTime: &stageTime.time!, lifePoint: &lifePoint, ballSpeed: &ballSpeed)
        
        //Time Limit セット
        LabelMaker.makeTimer(self, stageTime: &stageTime)
        
        var wait = 4.3
        if Tutorial.check(){
            wait = 0
        }else{
            LabelMaker.makeStartLabel(self)
        }
        
        ballSprite.runAction(SKAction.waitForDuration(wait)) { () -> Void in
            self.ballStopFlg = false
            self.playGameFlg = true
            self.stageTime.NSTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "limit", userInfo: nil, repeats: true)
           
            self.tutorial.makeFrame(self, baseNode: self.baseNode, ballStopFlg: &self.ballStopFlg, timer: &self.stageTime.NSTimer)
        }
        
        //加速度の値の取得の感覚を設定する
        Sensor.sharedInstance.accelerometerUpdateInterval = 0.1 //0.1秒ごとに取得
        
        //ハンドラを設定する
        let acceleromoterHandler:CMAccelerometerHandler = {
            (data:CMAccelerometerData?,error:NSError?) -> Void in
            //ボールのX,Y座標を設定
            data?.acceleration.x
            self.positionData.x = CGFloat(data!.acceleration.x * ballSpeed)
            self.positionData.y = CGFloat(data!.acceleration.y * ballSpeed)
        }
        
        //static変数にアクセスし、CMMotionManagerを生成。 ⇨ 取得開始して、上記で設定したハンドラを呼び出し、ログを表示する
        Sensor.sharedInstance.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler:acceleromoterHandler)
    }
    
    //チュートリアルのタイマーで呼ばれる
    func tutorialTimer(){
        stageTime.NSTimer =  NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "limit", userInfo: nil, repeats: true)
        baseNode.paused = false
        ballStopFlg = false
    }
    
    func limit(){
        //ballSprite.position.y += 15.0
        if NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.sound) == "1"{  Music.player.play() }
        print(Music.player.volume)
                                                                    //小数点第2位は切り捨て
        stageTime.label.text = "Time Limit \(round((stageTime.time - (timerCount / 10)) * 10.0) / 10.0)"
        if stageTime.time <= (timerCount / 10){ gameover() }
        
        //何秒かごとに実行
        if timerCount % 35 == 0 || timerCount == 0{ UnitAnimation.teresaAnimation(teresa, ballSprite: ballSprite) }
        if timerCount % 15 == 0 && stoneSize != nil{ EnemyMaker.makefall(stoneSize, location:baseNode, fallSprite: &fallSprites, lineSprites: lineSprites) }
        if timerCount % 30 == 0 || timerCount == 0{ UnitAnimation.moveMonster(monsterSprites) }
        
        //ゴール地点にボールが来た時
        if onGoalFlg == true && keepgauge.in_gauge.size.width > 89{ goalSprite.name = "Clear" }
        
        //残り時間１０以下の時
        if stageTime.time - (timerCount / 10) == 10 {
            stageTime.label.fontColor = UIColor.redColor()
            stageTime.label.runAction( SKAction.repeatActionForever(SKAction.sequence([SKAction.scaleTo(1, duration: 0.4), SKAction.scaleTo(1.2, duration: 0.4)])))
        }
        
        //ワープするときに他の敵に衝突しないようにする
        if let _ = warpCount{
                ballSprite.physicsBody?.collisionBitMask = 0
                ballSprite.physicsBody?.categoryBitMask = 0
                ballSprite.physicsBody?.contactTestBitMask = SpriteCategory.Coin | SpriteCategory.Hint
            warpCount! += 0.1
            
            if warpCount > 2.1 {
                BallController.categorySet(&ballSprite)
                warpCount = nil
            }
        }
        timerCount++
    }

    //1フレームごとに呼ばれるメソッド
    override func update(currentTime: CFTimeInterval) {
        
        //加速度センサのX,Yをキャラクタのx座標に設定、画面移
        BallController.always(positionData, ballSprite: &ballSprite, baseNode: &baseNode, flg: ballStopFlg)
        
        //ボールがゴール地点にある時 true
        onGoalFlg = (goalSprite.position.x - goalSprite.size.width / 1.8)...(goalSprite.position.x + goalSprite.size.width / 1.8) ~= ballSprite.position.x && (goalSprite.position.y - goalSprite.size.height / 1.8)...(goalSprite.position.y + goalSprite.size.height / 1.8) ~= ballSprite.position.y
        
        if onGoalFlg == true && timerFlg == false{
            timerFlg = true
            (keepgauge.in_gauge,keepgauge.out_gauge) = LabelMaker.makeKeepLabel(goalSprite, target: baseNode)
        }
            //timerが動いてるなら.
            if timerFlg == true && onGoalFlg == false{
                timerFlg = false
                
                //インスタンス削除
                keepgauge.out_gauge.removeFromParent()
                keepgauge.in_gauge.removeFromParent()
            }
        
        //クリア条件
        if goalSprite.name == "Clear" &&  ballStopFlg == false{ self.gameClear() }
    }
    
    //Retry と SelectStage(Timerで呼ばれる)
    func makeResultLabel(){ LabelMaker.makeRetryLabel(self, gameoverFlg: gameoverFlg, tuple: &tupleDic, advaice: &selectView) }
    
    //ライフ表示(Timer)
    func lim(){ print(Life.getLimitTime(self, y: size.height * 0.25)) }
    
    //ゲームクリアー処理
    func gameClear(){
        playGameFlg = false
        ballStopFlg = true
        gameoverFlg = false
        stageTime.NSTimer.invalidate()
        stageTime.label.removeAllActions()
        
        //結果画面の背景生成
        LabelMaker.makeResultImage(self)
        
        let textArray:[String] = ["C","L","E","A","R","!","!"]
        
        //CLEAR label配置    //クリアタイム と ★ ★ ★ と コイン
        LabelMaker.makeLabels(textArray, x: 0.15, color: UIColor.yellowColor(), labelNodeArrays: &labelNodeArrays, target: self)
        LabelMaker.makeScoreLabel((round((timerCount / 10) * 10.0) / 10.0 - 0.1), coinSprites: coinSprites, target: self, stageTime: stageTime.time)
        
        //大きくなるアニメーション
        UnitAnimation.clearAnimation(labelNodeArrays, scene:self)
        NSTimer.scheduledTimerWithTimeInterval(5.5, target: self, selector: "makeResultLabel", userInfo: nil, repeats: false)
    }
    
    //ゲームオーバー処理
    func gameover(){
        ballStopFlg = true
        gameoverFlg = true
        playGameFlg = false
        stageTime.NSTimer.invalidate()
        stageTime.label.removeAllActions()
        
        //結果画面の背景生成
        LabelMaker.makeResultImage(self)
       
        //GAMEOVER label配置
        let textArray:[String] = ["G","A","M","E","O","V","E","R"]
        LabelMaker.makeLabels(textArray, x: 0.08, color: UIColor.redColor(), labelNodeArrays: &labelNodeArrays, target: self)
       
        //ばらけるアニメーションなど
        UnitAnimation.scatterAnimation(labelNodeArrays, dy: -10, target: self)
        NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: "makeResultLabel", userInfo: nil, repeats: false)
    }
    
    //タッチイベント
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?){
        for touch: AnyObject in touches {
            
            // タッチされた場所の座標を取得.
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            
            //PAUSEの処理
            if playGameFlg == true && tutorial.frame == nil && timerCount != 0{
                vel = (ballSprite.physicsBody?.velocity)!
                baseNode.paused = true
                ballSprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                
                if stoneSize != nil{ for i in fallSprites{ i.physicsBody?.velocity.dy = 0 } }
                pause.gameStop(self, ballStopFlg: &ballStopFlg, playGameFlg: &playGameFlg,coinSprites: coinSprites, question: questionSprites, tuple: &tupleDic)
                stageTime.NSTimer.invalidate()
            }
            
            //ReTry Select　などのアクション
            ButtonAction.touch(touchedNode, pause: pause, target: self, gameoverFlg: gameoverFlg, playGameFlg: &playGameFlg, ballStopFlg: &ballStopFlg, stageTime: &stageTime.NSTimer, baseNode: baseNode, selectView: &selectView, fallSprites: fallSprites, ballSprite: ballSprite, vel: vel, tutorial: tutorial)
        }
    }
    
    //衝突した際に呼ばれるメソッド
    func didBeginContact(contact: SKPhysicsContact) {
        if ballStopFlg == false{

            let nodeA = contact.bodyA.node
            let nodeB = contact.bodyB.node
            print("A   \(nodeA?.name)"); print("B   \(nodeB?.name)")
            
            Particle.collision(nodeA, nodeB: nodeB, scene: self, ballSprite: ballSprite, baseNode: baseNode)
            
            //Warpに衝突した時
            for var i = 0; i < warpSprites.count; i++ {
                if nodeA?.name == "Warp\(i)" || nodeB?.name == "Warp\(i)"{
                    Music.soundSE("warp.m4a", scene: self)
                    ballSprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    warpCount = 0
                    UnitAnimation.moveToAnimation(target: ballSprite, firstPosition: warpSprites[i].position, secondPosition: CGPoint(x: self.size.width * warplocations[i].x, y: self.size.height * warplocations[i].y), time: 1)
                }
            }
            
            //die or rocationに衝突した時
            if nodeA?.name == "die" || nodeB?.name == "die" || nodeA?.name == "rotation" || nodeB?.name == "rotation" || nodeA?.name == "monster" || nodeB?.name == "monster" || nodeA?.name == "teresa" || nodeB?.name == "teresa"{
                for i in dieSprites { i.name = "" }
                if ballSprite.alpha == 1 { self.life.removeLife() }
                
                if gameoverFlg == false && life.sprite.count == 0{ gameover() }
                if life.sprite.count != 0 && ballSprite.alpha == 1 {
                    ballSprite.runAction(SKAction.sequence([SKAction.repeatAction(SKAction.sequence([SKAction.fadeAlphaTo(0, duration: 0.1),SKAction.fadeAlphaTo(0.9, duration: 0.1)]), count: 5),SKAction.fadeAlphaTo(1, duration: 0.1)]), completion: { () -> Void in
                        for i in self.dieSprites{ i.name = "die" }
                    })
                }
            }
            
            //Questionに衝突した時
            for var i = 0; i < questionSprites.count; i++ {
                if nodeA?.name == "question\(i)" || nodeB?.name == "question\(i)"{
                    let w = i
                    questionSprites[i].runAction(SKAction.fadeAlphaTo(0, duration: 0.2), completion: { () -> Void in
                        self.questionSprites[w].removeFromParent()
                         self.questionSprites[w].size = CGSize(width: 0, height: 0)
                    })
                }
            }
            
            //ヒントに衝突した時
            for var i = 0; i < hintSprites.count; i++ {
                if nodeA?.name == "hint\(i)" || nodeB?.name == "hint\(i)"{
                    Music.soundSE("hint.m4a", scene: self)
                    UnitAnimation.hintAnimation((questionSprites, lineSprites), time: 3)
                    self.hintSprites[i].removeFromParent()
                   
                }
            }
            
            //コインに衝突した時
            for var i = 0; i < coinSprites.count; i++ {
                if nodeA?.name == "coin\(i)" || nodeB?.name == "coin\(i)"{
                     Music.soundSE("coinget.mp3", scene: self)
                    let w = i
                    
                    coinSprites[w].runAction(SKAction.fadeAlphaTo(0, duration: 0.4), completion: { () -> Void in
                        //チュートリアル
                        if Int(NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.stageNumber)!)! == 1 {
                            self.tutorial.makeFrame(self, nodeA: nodeA?.name, nodeB: nodeB?.name, baseNode: self.baseNode, ballStopFlg: &self.ballStopFlg, timer: &self.stageTime.NSTimer)
                        }
                        nodeB?.name = nil; nodeA?.name = nil
                        self.coinSprites[w].removeFromParent()
                    })
                }
            }
            
            //ゴール
            if (nodeA?.name == "Goal" || nodeB?.name == "Goal") && Int(NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.stageNumber)!)! == 1{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                     self.tutorial.makeFrame(self, nodeA: nodeA?.name, nodeB: nodeB?.name, baseNode: self.baseNode, ballStopFlg: &self.ballStopFlg, timer: &self.stageTime.NSTimer)
                nodeA?.name = nil; nodeB?.name = nil
                })
               
            }
            
            //スイッチの振る舞い
            if nodeA?.name == "switch" || nodeB?.name == "switch"{
                for i in brockSprite{
                    if nodeA?.name == "switch"{ (nodeA as! SKSpriteNode).texture = SKTexture(imageNamed: "switchon"); nodeA?.name = nil }
                    if nodeB?.name == "switch"{ (nodeB as! SKSpriteNode).texture = SKTexture(imageNamed: "switchon"); nodeA?.name = nil }
                    i.runAction(SKAction.fadeAlphaTo(0, duration: 0.5), completion: { () -> Void in i.removeFromParent() })
                }
            }
            
            //岩にぶつかった時
            if nodeA?.name == "fall" || nodeB?.name == "fall" {
                if nodeA?.physicsBody?.velocity.dy > 0{
                    if nodeA == nil{ nodeA?.physicsBody?.velocity = CGVector(dx: 0, dy: -150) }
                    if nodeB != nil{ nodeB?.physicsBody?.velocity = CGVector(dx: 0, dy: -150) }
                }
            }
        }
    }
    
    func makeStage(){
        //NSUserDefaultsで保存したStageNumberを読み込む
        let stageNumber:Int! = Int(NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.stageNumber)!)
        
        let list = ["MainStage","LeftStage","RightStage","DownStage","UpStage"]
        for plistName in list{
            // プロパティファイルをバインド
            let path = NSBundle.mainBundle().pathForResource(plistName, ofType: "plist")
        
            // rootがDictionaryなのでNSDictionaryに取り込み
            let dict = NSDictionary(contentsOfFile: path!)
            if let _ = dict!.objectForKey(NSString(format: "Stage%02d", stageNumber)) {
                // キー"stage%02d"の中身はDictionnaryなのでNSDictionaryで取得
                let stage:NSDictionary = dict!.objectForKey(NSString(format: "Stage%02d", stageNumber)) as! NSDictionary
        
                //Stage辞書から＊＊＊というキーの配列を取り出す
                let enemiesDic:NSDictionary = stage.objectForKey("enemies") as! NSDictionary
    
                // enemiesDicから"キー"を取りだして配列に格納
                var nameArray:[String] = []
                for i in enemiesDic{ nameArray.append(i.key as! String) }
                
                //時計回りかどうか
                var clockwise:[Bool] = []
                var lineFlg:[Bool] = []
                
                var x:CGFloat = 0, y:CGFloat = 0
                switch plistName{   //位置決め
                    case "RightStage" : x = 1
                    case "LeftStage" : x = -1
                    case "UpStage" : y = 1
                    case "DownStage" :y = -1
                    default : break
                }
                
                func getData(name: String) ->[(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat)]{
                    var arr:[(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat)] = []
                    let array:NSArray = enemiesDic.objectForKey(name) as! NSArray
            
                    //arrayで取れた分だけループ
                    for value in array {
                        // またNSDictionaryなので、キーを指定してデータを取得
                        let xPosition = value.objectForKey("x") as! CGFloat + x
                        let yPosition = value.objectForKey("y") as! CGFloat + y
                        
                        //sizeを比率にするため。。。
                        var width = 0.0027 * (value.objectForKey("width") as! CGFloat) * size.width
                        var height = 0.0027 * (value.objectForKey("height") as! CGFloat) * size.width
                        if name == "line" || width > 250{
                            width = (value.objectForKey("width") as! CGFloat)
                            height = (value.objectForKey("height") as! CGFloat)
                        }
                                               
                        if let m:Bool = value.objectForKey("clockwise") as? Bool { clockwise.append(m) }
                        if name == "fall"{ stoneSize = 0.0027 * (value.objectForKey("width") as! CGFloat) * size.width }
                        if name == "line"{ lineFlg += [value.objectForKey("alpha") as! Bool] }
                        if name == "warp"{  //飛ばされる場所を読み込み
                            let warpXposition = value.objectForKey("warpX") as! CGFloat + x
                            let warpYposition = value.objectForKey("warpY") as! CGFloat + y
                            warplocations.append(CGPoint(x: warpXposition,y: warpYposition))
                        }
                        arr.append((xPosition, yPosition, width, height))
                    }
                    return arr
                }
                //一度のみballの位置、時間の読み込み
                if let time:Double = stage.objectForKey("time") as? Double{ stageTime.time = time }
                if let ballposition:NSDictionary = stage.objectForKey("ballPosition") as? NSDictionary{
                   BallController.makeBall(self.size.width * (ballposition.objectForKey("x") as! CGFloat + x), y: self.size.height * (ballposition.objectForKey("y") as! CGFloat + y), location: baseNode, ball: &ballSprite)
                }
                
                //背景セット
                let backImage = Sprite(size: self.size, position: CGPoint(x: self.size.width * (0.5 + x), y: self.size.height * (0.5 + y)), zPosition: 1)
                backImage.making("back")
                baseNode.addChild(backImage)
        
                //plistからデータを読み込んで他のスプライトを配置
                for var i = 0; i < nameArray.count; i++ {
                    var data = getData(nameArray[i])
                    for var n = 0; n < data.count; n++ {
                        switch nameArray[i]{
                            case "line" :
                                EnemyMaker.makeLine(data[n].x, y: data[n].y, width: data[n].width, height: data[n].height, flg: lineFlg[n], location: baseNode, lineSprites: &lineSprites, n: lineSprites.count)
                    
                            case "goal" :
                                EnemyMaker.makegoal(data[n].x, y: data[n].y, width: data[n].width, height: data[n].height, location: baseNode, goalSprite: &goalSprite)
                        
                            case "hint" :
                                EnemyMaker.makeHintPoint(data[n].x, y: data[n].y, width: data[n].width, height: data[n].height, n: hintSprites.count,location: baseNode, hintSprites: &hintSprites)
                    
                            case "warp" :
                                EnemyMaker.makewarp(data[n].x, y: data[n].y, width: &data[n].width, height: &data[n].height, n: warpSprites.count, location: baseNode, warpSprites: &warpSprites)
                    
                            case "die" :
                                EnemyMaker.makeDie(data[n].x, y: data[n].y, width: data[n].width , height: data[n].height, location: baseNode, dieSprites: &dieSprites)
                            
                            case "question" :
                                EnemyMaker.question(data[n].x, y: data[n].y, width: data[n].width, height: data[n].height, n: questionSprites.count, location: baseNode, questionSprites: &questionSprites)
                    
                            case "coin" :
                                EnemyMaker.makeCoin(data[n].x, y: data[n].y, width: data[n].width, height: data[n].height, n: coinSprites.count, location: baseNode, coinSprites: &coinSprites)
                    
                            case "rotation" :
                                EnemyMaker.makeRotation(data[n].x, y: data[n].y, width: data[n].width, height: data[n].height, location: baseNode, clockwise: clockwise[n])
                            
                            case "brock" :
                                EnemyMaker.makeBrock(data[n].x, y: data[n].y, width: data[n].width, height: data[n].height, location: baseNode, brockSprite: &brockSprite)
                            
                            case "switch" :
                                EnemyMaker.makeSwitch(data[n].x, y: data[n].y, width: data[n].width, height: data[n].height, location: baseNode)
                      
                            case "teresa" :
                                EnemyMaker.makeTeresa(data[n].x, y: data[n].y, width: data[n].width, height: data[n].height, location: baseNode, teresa: &teresa)
                            
                            case "monster" :
                            EnemyMaker.makeMonster(data[n].x, y: data[n].y, width: data[n].width, height: data[n].height, location: baseNode, monster: &monsterSprites)
                            
                            default:
                                break
                        }
                    }
                }
            }
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            // タッチされた場所の座標を取得.
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            
            if touchedNode.name != nil{
                if touchedNode.name == "Yes" || touchedNode.name == "No" || touchedNode.name == "OK"{
                    touchedNode.runAction(SKAction.sequence([SKAction.scaleTo(1.1, duration: 0.1), SKAction.scaleTo(1, duration: 0.1)]))
                }
                if let _ = (tupleDic.btn[touchedNode.name!]){
                    tupleDic.btn[touchedNode.name!]!.runAction(SKAction.sequence([SKAction.scaleTo(1.1, duration: 0.1), SKAction.scaleTo(1, duration: 0.1)]))
                }
                if let _ = (tupleDic.btn[touchedNode.name!]){
                    tupleDic.label[touchedNode.name!]!.runAction(SKAction.sequence([SKAction.scaleTo(1.1, duration: 0.1), SKAction.scaleTo(1, duration: 0.1)]))
                }
            }
        }
    }
}



//タイトルレイアウト//著作権の表記//楽曲:魔王魂
//Stageを見直す
//配信可能をハイにする

