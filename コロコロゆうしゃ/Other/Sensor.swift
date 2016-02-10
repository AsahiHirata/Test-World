//
//  Read.swift
//  BallGame
//
//  Created by 平田朝飛 on 2015/12/23.
//  Copyright © 2015年 AsahiHirata. All rights reserved.
//

import Foundation
import CoreMotion

class Sensor:CMMotionManager{
    static let sharedInstance: Sensor = Sensor()
    private override init() {}
}

