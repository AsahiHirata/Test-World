//
//  Label.swift
//  BallGame
//
//  Created by 平田朝飛 on 2015/12/16.
//  Copyright © 2015年 AsahiHirata. All rights reserved.
//

import Foundation
import SpriteKit

class Label: Unit {
    var label = SKLabelNode()

    func makeLabel(fontName:String, size: CGFloat, text:String = "") ->SKLabelNode{
        let label = SKLabelNode(fontNamed: fontName)
        label.position = self._position
        label.fontColor = self._color
        label.zPosition = self._zPosition
        label.alpha = self._alpha
        label.name = self._name
        label.fontSize = size
        label.text = text
        
        self.addChild(label)
        return label
    }
}
