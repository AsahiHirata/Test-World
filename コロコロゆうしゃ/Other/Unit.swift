//
//  Obstacle.swift
//  BallGame
//
//  Created by 平田朝飛 on 2015/11/10.
//  Copyright © 2015年 AsahiHirata. All rights reserved.
//

import Foundation
import SpriteKit

let size:CGSize = UIScreen.mainScreen().bounds.size

import Foundation
import SpriteKit

struct DefaultKeys{
    static let stageNumber = "StageNumber"
    static let rank = "Rank"
    static let time = "Time"
    static let totalCoins = "TotalCoins"
    static let clearcount = "ClearCount"
    static let ballHeart = "BallHeart"
    
    static let afterTime = "afterTime"
    static let lifePoint = "lifePoint"
    
    static let item = "Item"
    
    static let sound = "Sound"
    static let share = "Share"

   }


struct SpriteCategory {
    static let Ball:UInt32 = (1 << 0)
    static let Enemy:UInt32 = (1 << 1)
    static let NoCollisionEnemy:UInt32 = (1 << 2)
    static let Label:UInt32 = (1 << 3)
    static let Line:UInt32 = (1 << 4)
    static let Question:UInt32 = (1 << 5)
    static let Coin:UInt32 = (1 << 6)
    static let Brock:UInt32 = (1 << 7)
    static let Hint:UInt32 = (1 << 8)
    static let Btn:UInt32 = (1 << 9)
}

struct FontName {
    static let ChalkboardSE_Regular = "ChalkboardSE-Regular"//かわいい
    static let Chalkduster = "Chalkduster"//ぼろぼろ
    static let Baskerville_BoldItalic = "Baskerville-BoldItalic"//かっこいい
    static let Noteworthy_Bold = "Noteworthy-Bold"//手書きみたい
    static let Verdana_Bold = "HiraKakuProN-W6"//日本語フォント
}

class Unit: SKNode{
    var _size: CGSize!
    var _position: CGPoint!
    var _name: String!
    var _alpha: CGFloat!
    var _zPosition: CGFloat!
    var _color: UIColor!
    
    init(size:CGSize, position:CGPoint, name:String! = nil, alpha:CGFloat = 1, zPosition:CGFloat = 10, color:UIColor! = nil) {
        self._size = size
        self._position = position
        self._name = name
        self._alpha = alpha
        self._zPosition = zPosition
        self._color = color
        super.init()
    }
    
    //必須イニシャライザ
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

