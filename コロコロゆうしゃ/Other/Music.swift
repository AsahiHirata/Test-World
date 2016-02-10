//
//  Music.swift
//  BallGame
//
//  Created by 平田朝飛 on 2016/01/31.
//  Copyright © 2016年 AsahiHirata. All rights reserved.
//

import Foundation
import SpriteKit
// ライブラリインポート：AVFoundation FlameWork
import AVFoundation

class Music:SKScene{
    
    static var player:AVAudioPlayer = AVAudioPlayer()
    
       
    class func soundSE(fileName:String, scene:SKScene, wait:Double = 0){
        
        if NSUserDefaults.standardUserDefaults().stringForKey(DefaultKeys.sound)! == "0"{ return }
        
        let play = SKAction.playSoundFileNamed(fileName, waitForCompletion: false)
        
        scene.runAction(SKAction.sequence([SKAction.waitForDuration(wait), play]))
    }
    
    
     // 音楽コントローラ AVAudioPlayerを定義(変数定義、定義実施、クリア）
    class func audioPlayerDif(){
        
        // 音声ファイルのパスを定義 ファイル名, 拡張子を定義
        let audioPath = NSBundle.mainBundle().pathForResource("GameSceneBGM", ofType: "m4a")!
            
        //ファイルが存在しない、拡張子が誤っている、などのエラーを防止するために実行テスト(try)する。
        do{
                
            //tryで、ファイルが問題なければ player変数にaudioPathを定義
            try player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioPath))
            player.volume = 0.9
            
                
        }catch{
            //エラー処理
            print("MusicFile Error")
            
        }
    }
}



