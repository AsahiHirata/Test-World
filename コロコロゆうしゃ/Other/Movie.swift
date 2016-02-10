//
//  Movie.swift
//  BallGame
//
//  Created by 平田朝飛 on 2016/01/26.
//  Copyright © 2016年 AsahiHirata. All rights reserved.
//

import Foundation
import SpriteKit

class Movie:Maio,MaioDelegate{
    static let instance:Movie = Movie()
    var scene:SKScene!
    
    
   

    func make(){
        Maio.setAdTestMode(true) //開発環境で再生する際には必ずテストモードにしましょう
        Maio.startWithMediaId("********", delegate: self)
           }
    
    func showMovie(scene:SKScene, inout view:ViewConfirmation!){
        self.scene = scene
        if Maio.canShow(){ Maio.show() }
        if Maio.canShow() == false{
            
            Life.selectView.remove()
            Life.selectView = nil
            view = ViewConfirmation()
            view.makeFrame(scene, text: "時間をしばらく置いてから再度お試しください。", twoBtns: false)
        }
    }
    
    //動画を見たらデリゲートで呼ばれる
    func maioDidCloseAd(zoneId: String) {
        print("動画視聴完了")
        
        var y:CGFloat!
    
        if Life.label.position.y < size.height * 0.5{ y = size.width * 0.15 + 50 + size.width * 0.15 + 10 }
        if Life.label.position.y > size.height * 0.5{ y = size.height * 0.88 }
        
        Life.saveLife(Life.max)
        
        Life.movieFinishAnimation(scene, y: y)
        Life.selectView.remove()
        Life.selectView = nil
    }
}
