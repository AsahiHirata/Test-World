//
//  ShopScene.swift
//  BallGame
//
//  Created by 平田朝飛 on 2016/01/28.
//  Copyright © 2016年 AsahiHirata. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import StoreKit

class ShopScene: SKScene, XXXPurchaseManagerDelegate {
    
    var image: SKSpriteNode!
    var viewArrays = [SKSpriteNode]()
    let price = ["50","10","10","20","20","20","20","120","120"]
    var notbuy = [SKSpriteNode]()
    var frameView:ViewConfirmation!
    var coinLabel = SKLabelNode()

    var is_Touch = false
    override func didMoveToView(view: SKView) {
        
        Imobile.sharedInstance.makeBanner(self, under:true)
        
        //背景
        let back = Sprite(size: self.size, position: CGPoint(x: size.width * 0.5, y: size.height * 0.5), alpha: 1, zPosition: 1, color: UIColor.blackColor())
        back.making()
        self.addChild(back)
        
        //タイトル
        let itemName = Label(size: CGSize(), position: CGPoint(x: size.width * 0.5, y: size.height * 0.95), alpha: 1, zPosition: 30, color: UIColor.whiteColor())
        itemName.makeLabel(FontName.ChalkboardSE_Regular, size: size.width * 0.08, text: "Item Shop")
        self.addChild(itemName)
        
        
        /***************************************所持コイン*******************************************/
        //コインの画像
        let coin_Image = Sprite(size: CGSize(width: size.width * 0.07, height: size.width * 0.07), position: CGPoint(x: size.width * 0.1, y: size.height * 0.12), name: "back", alpha: 1, zPosition: 12)
        coin_Image.making("coin")
        self.addChild(coin_Image)
        //数字
        let totalCoin = Label(size: CGSize(), position: CGPoint(x: size.width * 0.15, y: size.height * 0.11), alpha: 1, zPosition: 30, color: UIColor.whiteColor())
        coinLabel = totalCoin.makeLabel(FontName.ChalkboardSE_Regular, size: size.width * 0.065, text: " x \(Int(NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.totalCoins)!)!)")
        coinLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        self.addChild(totalCoin)
        /***************************************所持コイン*******************************************/
        
        
        //もどる
        let backBtn = Sprite(size: CGSize(width: size.width * 0.09, height: size.width * 0.09), position: CGPoint(x: size.width * 0.5, y: size.height * 0.13), name: "back", alpha: 1, zPosition: 20)
        backBtn.making("home")
        self.addChild(backBtn)
        
        //リストアボタン
        let restoreBtn = Sprite(size: CGSize(width: size.width * 0.2, height: size.width * 0.1), position: CGPoint(x: size.width * 0.83, y: size.height * 0.13), name: "ReStore", alpha: 1, zPosition: 20)
        restoreBtn.making("Restore")
        self.addChild(restoreBtn)
        
        
        //ファイルの名前
        let nameList = ["lifeup","lifeup","timelimit+30","timelimit+60","ballSizeDown","speedup","speeddown","openStage","bannerDelete"]
        var count = 0
        for var i = 0,x:CGFloat = 0.2, y:CGFloat = 0.8 ; i < 3; i++, y -= 0.25 {
            for var t = 0; t < 3; t++, x += 0.3 {
                //掲示板
                let view = Sprite(size: CGSize(width: size.width * 0.28, height: size.height * 0.25), position: CGPoint(x: size.width * x, y: size.height * y), name: String(count), zPosition: 10)
                viewArrays += [view.making("shopItemBack")]
                self.addChild(view)
                
                //コインマーク
                let coin = Sprite(size: CGSize(width: view._size.width * 0.2, height: view._size.width * 0.2), position: CGPoint(x: -view._size.width * 0.3, y: -view._size.height * 0.35), name: String(count), zPosition: 20)
                coin.making(count < 7 ? "coin" : "¥")
                viewArrays[count].addChild(coin)
                
                                
                //¥50
                let itemName = Label(size: CGSize(), position: CGPoint(x: 0, y: -view._size.height * 0.4), name: String(count), alpha: 1, zPosition: 30, color: UIColor.blackColor())
                itemName.makeLabel(FontName.ChalkboardSE_Regular, size: size.width * 0.05, text: price[count])
                viewArrays[count].addChild(itemName)
                
                //画像
                let image = Sprite(size: CGSize(width: view._size.width * 0.9 , height: view._size.width * 0.95), position: CGPoint(x: 0, y: 0), name: String(count), zPosition: 20)
                image.making(nameList[count])
                viewArrays[count].addChild(image)
                
                //購入禁止
                let black = Sprite(size: view._size, position: CGPoint(x: 0, y: 0), name: String(count), zPosition: 20, alpha: 0, color: UIColor.blackColor())
                notbuy.append(black.making())
                viewArrays[count].addChild(black)
                
                if Int(NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.item + "\(count)")!)! == 1 && count < 7{
                    notbuy[count].alpha = 0.5
                }
                count++
            }
            x = 0.2
        }
        
        //買えないようにする処理
        for var n = 4; n < 7; n++ {
            if 1 == Int(NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.item + "\(n)")!)!{
                for var i = 4; i < 7; i++ { notbuy[i].alpha = 0.5 }
            }
        }
        if Int(NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.ballHeart)!)! >= 5{
                    notbuy[0].alpha = 0.5
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            // タッチされた場所の座標を取得.
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            
            if (touchedNode.name != nil) {
                
                if let _ = Int(touchedNode.name!){
                    viewArrays[Int(touchedNode.name!)!].runAction(SKAction.sequence([SKAction.scaleTo(1.1, duration: 0.1), SKAction.scaleTo(1, duration: 0.11)]))
                }
                touchedNode.runAction(SKAction.sequence([ SKAction.scaleTo(1.1, duration: 0.09), SKAction.scaleTo(1, duration: 0.09)]))
            }
        }
    }

    
    //「Start」ラベルをタップしたら、GameSceneへ遷移させる。
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {

            // タッチされた場所の座標を取得.
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            
            if (touchedNode.name != nil) && is_Touch == false{
                Music.soundSE("click.mp3", scene: self)
                if let number = Int(touchedNode.name!){
                    if notbuy[number].alpha == 0.5{ break }
                    frameView = ViewConfirmation(number: String(number))
                    
                    var text = ""
                
                    //アイテムの説明
                    switch number{
                    case 0:
                        text = "ボールの❤️をひとつ増加します。\n(最大5個)"
                    case 1:
                        text = "1ステージのみ、ボールの\n❤️をひとつ増加します。"
                    case 2:
                        text = "1ステージのみ、\nTime Limitを \n30秒 延長します。"
                    case 3:
                        text = "1ステージのみ、\nTime Limitを \n60秒 延長します。"
                    case 4:
                        text = "1ステージのみ、\nボールの大きさを\n小さくします。"
                    case 5:
                        text = "1ステージのみ、\nボールの転がる速さを\n速くします。"
                    case 6:
                        text = "1ステージのみ、\nボールの転がる速さを\n遅くします。"
                    case 7:
                        text = "¥120 で全てのステージを\n解放します。"
                    case 8:
                        text = "¥120 で画面上部と下部に\n表示されている広告を\n削除します。"
                    default:
                        break
                    }
                    
                frameView.makeFrame(self, text: " \(text)\n\nダイヤ \(price[number])個 で購入しますか？", twoBtns: true)
                    if number > 6{ frameView.comment.text = "\(text)\n\n¥ \(price[number]) で購入しますか？" }
            }
                
                switch touchedNode.name! {
                    
                case "Yes":
                    let num = Int(frameView.number)!
                    let money = Int(NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.totalCoins)!)
                    
                    if Int(price[Int(frameView.number)!])!.hashValue > money! && num < 7{
                        
                        frameView.remove()
                        frameView = nil
                        
                        frameView = ViewConfirmation()
                        frameView.makeFrame(self, text: "ダイヤが足りません。", twoBtns: false)
                        break
                    }
                    
                    //lifePointを増やす
                    if num == 0{
                        let point = NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.ballHeart)
                        NSUserDefaults.standardUserDefaults().setInteger(Int(point!)! + 1, forKey: DefaultKeys.ballHeart)
                        NSUserDefaults.standardUserDefaults().synchronize()
                    }
                    
                    //課金
                    if num > 6{
                        if num == 7{ self.startPurchase("stage_120") }
                        if num == 8{ self.startPurchase("bannerDelete_120") }
                    }
                    
                   
                    //購入できないようにする処理
                    if num < 7{
                        if num != 0{ notbuy[num].alpha = 0.5 }
                        if num == 0 && Int(NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.ballHeart)!) == 5{
                            NSUserDefaults.standardUserDefaults().setBool(true, forKey: DefaultKeys.item + "0")
                            notbuy[0].alpha = 0.5
                        }
                        if 4...6 ~= num{
                            for var i = 4; i < 7; i++ {
                                notbuy[i].alpha = 0.5
                            }
                        }

                        //Item2 というキーで保存 コインを減らす
                        if num != 0{
                            NSUserDefaults.standardUserDefaults().setBool(true, forKey: DefaultKeys.item + frameView.number!)
                            NSUserDefaults.standardUserDefaults().setInteger(money! - Int(price[num])!, forKey: DefaultKeys.totalCoins)
                            NSUserDefaults.standardUserDefaults().synchronize()
                        }
                        
                   
                        frameView.remove()
                        frameView = nil
                    
                        frameView = ViewConfirmation()
                        frameView.makeFrame(self, text: "アイテムを購入しました。", twoBtns: false)
                        coinLabel.text = " x \(money! - Int(price[Int(num)])!)"
                    }
            
                                                            
                case "No","OK":
                    frameView.remove()
                    frameView = nil
                    
                case "back":
                    Imobile.sharedInstance.removeBanner()
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.01 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                    
                        let transition = SKTransition.fadeWithDuration(1)
                        let newScene = TitleScene(size: self.scene!.size)
                        newScene.scaleMode = SKSceneScaleMode.AspectFill
                        self.view!.presentScene(newScene,transition: transition)
                    })
                case "ReStore" :
                    
                   self.startRestore()
                   
                   is_Touch = true
                   frameView = ViewConfirmation(number: "ReStore")
                   frameView.makeFrame(self, text: "課金情報を確認しています...", twoBtns: false, noBtn: true)
                    
                default :
                    break
                }
            }
        }
    }
    
    
    
    /// 課金開始
    func startPurchase(productIdentifier : String) {
        
        is_Touch = true
                        
        //プロダクトID達
        let productIdentifiers = ["stage_120", "bannerDelete_120"]
        
                        
        //プロダクト情報取得
        XXXProductManager.productsWithProductIdentifiers(productIdentifiers,
        completion: { (products : [SKProduct]!, error : NSError?) -> Void in
            for product in products {
    
                //価格を抽出
                let priceString = XXXProductManager.priceStringFromProduct(product)
                print(priceString)
                /*
                価格情報を使って表示を更新したり。
                */
            }
        })

        //デリゲード設定
        XXXPurchaseManager.sharedManager().delegate = self
        
        //プロダクト情報を取得
        XXXProductManager.productsWithProductIdentifiers([productIdentifier], completion: { (products, error) -> Void in
            if products.count > 0 {
                
                //課金処理開始
                XXXPurchaseManager.sharedManager().startWithProduct(products[0])
                
            }
        })
    }
    
    
    /// リストア開始
    func startRestore() {
        //デリゲード設定
        XXXPurchaseManager.sharedManager().delegate = self
        
        //リストア開始
        XXXPurchaseManager.sharedManager().startRestore()
    }

    
    
    
    // MARK: - XXXPurchaseManager Delegate
    func purchaseManager(purchaseManager: XXXPurchaseManager!, didFinishPurchaseWithTransaction transaction: SKPaymentTransaction!, decisionHandler: ((complete: Bool) -> Void)!) {
        //課金終了時に呼び出される　->　コンテンツ解放処理
        
        //リストア時
        if frameView.number == "ReStore" {
            
            print(transaction.payment.productIdentifier)
            switch transaction.payment.productIdentifier{
            
            case "bannerDelete_120":
                Imobile.sharedInstance.removeBanner()
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: DefaultKeys.item + "8")
                NSUserDefaults.standardUserDefaults().synchronize()
            
            case "stage_120":
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: DefaultKeys.item + "7")
                
            default:
                break
            }
        }
        NSUserDefaults.standardUserDefaults().synchronize()
        
        
        //課金時
        if frameView.number == "7" || frameView.number == "8"{
            
            let num = Int(frameView.number)!
            print(num)
        
            if num == 8 { Imobile.sharedInstance.removeBanner() }
        
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: DefaultKeys.item + frameView.number!)
            NSUserDefaults.standardUserDefaults().synchronize()
        
        
            frameView.remove()
            frameView = nil
        
            frameView = ViewConfirmation()
            frameView.makeFrame(self, text: "購入が完了しました。", twoBtns: false)
            
            is_Touch = false
            
            
            //レシートの取得
            if let receiptUrl: NSURL = NSBundle.mainBundle().appStoreReceiptURL {
                if let receiptData: NSData = NSData(contentsOfURL: receiptUrl) {
                
                    let receiptBase64Str: String = receiptData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
                    print("\(receiptBase64Str)\nレシートを取得")
                } else {
                    // 取得できないのでエラー処理
                    print("レシートを取得できませんでした")
                }
            }
            
            
            if let receiptUrl: NSURL = NSBundle.mainBundle().appStoreReceiptURL {
                if let receiptData: NSData = NSData(contentsOfURL: receiptUrl) {
                    let receiptBase64Str: String = receiptData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
                    let requestContents: NSDictionary = ["receipt-data": receiptBase64Str] as NSDictionary
                    var requestData: NSData = NSData()
                    
                    do{     //base64エンコードを施したレシートデータをNSDataに変換する
                         requestData = try NSJSONSerialization.dataWithJSONObject(requestContents, options: NSJSONWritingOptions())
                    }catch{
                        print("NSDataに変換できませんでした")
                    }
                    
                    
                    //実稼働環境ではhttps://buy.itunes.apple.com/verifyReceiptを指定します。
                    //テスト環境https://sandbox.itunes.apple.com/verifyReceipt
                    let url: NSURL = NSURL(string: "https://buy.itunes.apple.com/verifyReceipt")!
                    
                    var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
                    
                    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"content-type")
                    request.timeoutInterval = 5.0
                    request.HTTPMethod = "POST"
                    request.HTTPBody = requestData
                    
                    let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler:{data, response, error in
                        
                        do {
                            let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                           
                            let statusCode = String(dict["status"]!)
                            print("statusCode : \(statusCode)")
                            
                            do {
                                if statusCode == "21007"{
                                    //テスト環境のレシートなのでテスト環境に送信する
                                    let sandboxUrl: NSURL = NSURL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!
                                    request = NSMutableURLRequest(URL: sandboxUrl)
                                    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"content-type")
                                    request.timeoutInterval = 5.0
                                    request.HTTPMethod = "POST"
                                    request.HTTPBody = requestData
                                }
                        
                                try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
                                print("正常にレシートを送信しました")
                               
                                
                                } catch let (error){
                                        print(error)
                                        print("レシートを送信できませんでした")
                                }
                            
                            
                            
                
                        } catch let (error){
                            print(error)
                            print("statusを取得できませんでした")
                        }
                    })
                    
                    task.resume()
                }
            }
        }
        
               
        //コンテンツ解放が終了したら、この処理を実行(true: 課金処理全部完了, false 課金処理中断)
        decisionHandler(complete: true)
    }
    
    
    
    //課金終了時に呼び出される(startPurchaseで指定したプロダクトID以外のものが課金された時。) -> コンテンツ解放処理
    func purchaseManager(purchaseManager: XXXPurchaseManager!, didFinishUntreatedPurchaseWithTransaction transaction: SKPaymentTransaction!, decisionHandler: ((complete: Bool) -> Void)!) {
        
        
        //コンテンツ解放が終了したら、この処理を実行(true: 課金処理全部完了, false 課金処理中断)
        decisionHandler(complete: true)
    }
    
    
    
     //課金失敗時に呼び出される -> errorを使ってアラート表示
    func purchaseManager(purchaseManager: XXXPurchaseManager!, didFailWithError error: NSError!) {
        print(error)
       
        if frameView != nil{
            frameView.remove()
            frameView = nil
        }
        
        frameView = ViewConfirmation()
        frameView.makeFrame(self, text: "キャンセルしました。", twoBtns: false)
        
        is_Touch = false
    }
    
    
    
    
    //リストア終了時に呼び出される(個々のトランザクションは”課金終了”で処理) -> インジケータなどを表示していたら非表示に
    func purchaseManagerDidFinishRestore(purchaseManager: XXXPurchaseManager!, queue: SKPaymentQueue) {
        
        frameView.remove()
        frameView = nil

        
        if NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.item + "7") == "1" ||  NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.item + "8") == "1"{
            frameView = ViewConfirmation()
            frameView.makeFrame(self, text: "課金アイテムのリストアが完了しました。", twoBtns: false)
            
        }else{
            frameView = ViewConfirmation()
            frameView.makeFrame(self, text: "課金アイテムはありません。", twoBtns: false)
        }
        
        is_Touch = false
    }
    
    
    
    //承認待ち状態時に呼び出される(ファミリー共有) -> インジケータなどを表示していたら非表示に
    func purchaseManagerDidDeferred(purchaseManager: XXXPurchaseManager!) {
        
        
    }

    
}
