//
//  ViewConfirmation.swift
//  BallGame
//
//  Created by 平田朝飛 on 2016/01/01.
//  Copyright © 2016年 AsahiHirata. All rights reserved.
//

import Foundation
import SpriteKit

class ViewConfirmation{
    var frame:Sprite!
    var comment:UILabel!
    var number:String!
    
    init(number:String = ""){
        self.number = number
    }
    
    func makeFrame(scene:SKScene, text:String, twoBtns:Bool, yesName:String = "Yes", noName:String = "No", noBtn:Bool = false ){
        
        //タッチ防止の背景
        frame = Sprite(size: size, position: CGPoint(x: size.width * 0.5, y: size.height * 0.5), alpha: 0.01, zPosition: 300, color: UIColor.whiteColor())
        frame.making()
        scene.addChild(frame)
        
        //フレーム
        let m = Sprite(size: CGSize(width: size.width * 0.8, height: size.height * 0.3), position: CGPoint(x: size.width * 0.5, y: size.height * 0.5), alpha: 0.95, zPosition: 320)
        m.making("frame")
        frame.addChild(m)
        
        //UILabelを生成する
        comment = UILabel(frame: CGRectMake(0, 0, size.width * 0.7 ,size.width * 0.5))
        comment.layer.position = CGPoint(x: size.width * 0.5, y: size.height * 0.44)
        if noBtn == true{  comment.layer.position.y = size.height * 0.5 }
        comment.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        comment.text = text
        //改行させる
        comment.numberOfLines = 0
        comment.font = UIFont(name: FontName.Verdana_Bold, size: size.width * 0.047)
        comment.textColor = UIColor.whiteColor()
        comment.textAlignment = NSTextAlignment.Center //中央揃え
        // 影の濃さを設定する.
        comment.layer.shadowOpacity = 0.5
        
        scene.view!.addSubview(comment)
        
        
        //ボタン
        if twoBtns == false && noBtn == false{
          let btn = Sprite(size: CGSize(width: size.width * 0.18, height: size.width * 0.18), position: CGPoint(x: size.width * 0.5, y: size.height * 0.42), name: "OK", alpha: 1, zPosition: 350)
            btn.making("OK")
            frame.addChild(btn)
        }
        
        if twoBtns == true && noBtn == false{
            let yes = Sprite(size: CGSize(width: size.width * 0.18, height: size.width * 0.18), position: CGPoint(x: size.width * 0.3, y: size.height * 0.42), name: yesName, alpha: 1, zPosition: 350)
            yes.making("Yes")
            frame.addChild(yes)
            
            let no = Sprite(size: CGSize(width: size.width * 0.18, height: size.width * 0.18), position: CGPoint(x: size.width * 0.7, y: size.height * 0.42), name: noName, alpha: 1, zPosition: 350)
            no.making("No")
            frame.addChild(no)
        }
    }
    
    // wait秒フェードインする
    func action(wait: Double){
        
        comment.alpha = 0
        frame.runAction(SKAction.group([SKAction.fadeAlphaTo(0.01, duration: 0) ,SKAction.waitForDuration(wait)])) { () -> Void in
            self.comment.alpha = 1
            self.frame.alpha = 1
        }
    }

    func remove(){
        frame.removeFromParent()
        comment.removeFromSuperview()
    }
}