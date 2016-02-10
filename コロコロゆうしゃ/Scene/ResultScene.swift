//
//  ResultScene.swift
//  BallGame
//
//  Created by 平田朝飛 on 2016/01/26.
//  Copyright © 2016年 AsahiHirata. All rights reserved.
//

import Foundation
import SpriteKit

class ResultSecne:SKScene, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var myCollectionView : UICollectionView!

    override func didMoveToView(view: SKView) {
        Imobile.sharedInstance.makeBanner(self, under:false)
        
        Particle.makeParticle(self, position: CGPoint(x: size.width * 0.5, y: size.height), zPosition: 13, fileName: "snowParticle")
        
        //背景
        let back = Sprite(size: self.size, position: CGPoint(x: size.width * 0.5, y: size.height * 0.5), alpha: 1, zPosition: 12, color: UIColor.blackColor())
        back.making()
        self.addChild(back)
        
        //戻る
        let backBtn = Sprite(size: CGSize(width: 30, height: 30), position: CGPoint(x: size.width * 0.1, y: size.height - 85), name: "back", alpha: 1, zPosition: 101)
        backBtn.making("home")
        self.addChild(backBtn)
        
        //リザルト
        let result = Sprite(size: CGSize(width: size.width * 0.65, height: size.height * 0.11), position: CGPoint(x: size.width * 0.65, y: size.height - 87), alpha: 1, zPosition: 12)
        result.making("result")
        self.addChild(result)
                
        // CollectionViewのレイアウトを生成.
        let layout = UICollectionViewFlowLayout()
        
        // Cell一つ一つの大きさ.
        layout.itemSize = CGSizeMake(size.width, 50)
        
        // Cellのマージン.
        layout.sectionInset = UIEdgeInsetsMake(0, 32, 32, 16)
        
        // セクション毎のヘッダーサイズ.
        layout.headerReferenceSize = CGSizeMake(100,30)
        
    
        
        // CollectionViewを生成.
        myCollectionView = UICollectionView(frame: CGRectMake(0, 55 + size.height * 0.1, size.width, size.height - 55 - size.height * 0.1), collectionViewLayout: layout)
        
        //バウンド
        myCollectionView.bounces = true
        
        myCollectionView.backgroundColor = UIColor.clearColor()

        // Cellに使われるクラスを登録.
        myCollectionView.registerClass(CustomUICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
            
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        self.view!.addSubview(self.myCollectionView)
       
    
    }
    
        //Cellが選択された際に呼び出される
        func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
            
            print("Num: \(indexPath.row)")
            
        }
        
    
        //Cellの総数を返す
        func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 50
        }
        
    
        //Cellに値を設定する
        func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cell : CustomUICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("MyCell", forIndexPath: indexPath) as! CustomUICollectionViewCell
            let idx = Int(indexPath.row.description)! + 1
           
            let value = NSString(format: "Stage %02d",idx)
            var arr = [value,"ー","ー","ー"]
            let score =  NSUserDefaults.standardUserDefaults().dictionaryForKey(String(idx))
            let star = ["★ ☆ ☆","★ ★ ☆","★ ★ ★"]
            
            
            //各データの読み込み
            if score != nil{
                if score![DefaultKeys.rank] != nil{ arr[2] = star[score![DefaultKeys.rank]! as! Int] }
                if score![DefaultKeys.clearcount] != nil{ arr[3] = String(score![DefaultKeys.clearcount]! as! Int)}
                if score![DefaultKeys.time] != nil{ arr[1] = String(score![DefaultKeys.time]! as! Double)}
            }
            if idx > 50{ arr = ["","","",""] }
            
            for var i = 0; i < 4; i++ { cell.textLabel[i]?.text = arr[i] as String }
            
            return cell
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
            touchedNode.runAction(SKAction.fadeAlphaTo(1, duration: 0.1))
            //アニメーション
            let transition = SKTransition.fadeWithDuration(1)
             print(touchedNode.name)
            if (touchedNode.name != nil) {
               
                switch touchedNode.name! {
                    
                case "back":
                    Music.soundSE("click.mp3", scene: self)
                    
                    myCollectionView.removeFromSuperview()
                    myCollectionView = nil
                    
                    Imobile.sharedInstance.removeBanner()
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.01 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                        let newScene = TitleScene(size: self.scene!.size)
                        newScene.scaleMode = SKSceneScaleMode.AspectFill
                        self.view!.presentScene(newScene,transition: transition)
                    })
                    
                    
                default :
                    break
                }
            }
        }
    }
}


class CustomUICollectionViewCell : UICollectionViewCell{
    
    var textLabel = [UILabel?]()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        // UILabelを生成.
        var x = [0.02, 0.36, 0.54, 0.85]
        for var i = 0; i < 4; i++ {
            textLabel.append(UILabel(frame: CGRectMake(size.width * CGFloat(x[i]), 0, frame.width, frame.height)))
            textLabel[i]?.text = "nil"
            textLabel[i]?.font = UIFont(name: FontName.ChalkboardSE_Regular, size: size.width * 0.06)
            textLabel[i]?.textColor = UIColor.whiteColor()
            textLabel[i]?.backgroundColor = UIColor.clearColor()
            textLabel[i]?.textAlignment = NSTextAlignment.Left
            textLabel[i]?.alpha = 0
            
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.textLabel[i]!.alpha = 1
            })
            
            
        
        // Cellに追加.
        self.contentView.addSubview(textLabel[i]!)
        }
    }
}

