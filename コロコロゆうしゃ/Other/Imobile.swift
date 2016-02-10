//
//  Imobile.swift
//  BallGame
//
//  Created by 平田朝飛 on 2016/01/25.
//  Copyright © 2016年 AsahiHirata. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Imobile{
    static let sharedInstance: Imobile = Imobile()
    var bannerView:UIView!
    let benner_height = size.height * 0.09
 
    let IMOBILE_BANNER_PID = ""
    let IMOBILE_BANNER_MID = ""
    let IMOBILE_BANNER_SID = ""
    
    func makeBanner(target:SKScene, under:Bool){
        
        if bannerView == nil && Int(NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.item + "8")!)! == 0{
            // スポット情報を設定します
            ImobileSdkAds.registerWithPublisherID(IMOBILE_BANNER_PID, mediaID:IMOBILE_BANNER_MID, spotID:IMOBILE_BANNER_SID)
            // 広告の取得を開始します
            ImobileSdkAds.startBySpotID(IMOBILE_BANNER_SID)
        
            // 表示する広告のサイズ
            let imobileAdSize = CGSizeMake(size.width, size.height * 0.09)
            // デバイスの画面サイズlet
            let screenSize = UIScreen.mainScreen().bounds.size
        
            // 広告の表示位置を算出(画面中央下)
            let imobileAdPosX: CGFloat = (screenSize.width - imobileAdSize.width) / 2
            var imobileAdPosY: CGFloat = screenSize.height - imobileAdSize.height
            
            if under == false{ imobileAdPosY = 0 }
        
            // 広告を表示するViewを作成します
            bannerView = UIView(frame: CGRectMake(imobileAdPosX, imobileAdPosY, imobileAdSize.width, imobileAdSize.height))
            //広告を表示するViewをViewControllerに追加します
            target.view!.addSubview(bannerView)
        
            // 広告を表示します
            ImobileSdkAds.showBySpotID(IMOBILE_BANNER_SID, view: bannerView, sizeAdjust: true)
        }
        
    }
    
    func removeBanner(){
        if Int(NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.item + "8")!)! == 0 {
            bannerView.removeFromSuperview()
            bannerView = nil
        }
        
    }
}