//
//  GameViewController.swift
//  BallGame
//
//  Created by 平田朝飛 on 2015/11/09.
//  Copyright (c) 2015年 AsahiHirata. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //動画広告準備
        Movie.instance.make()
        
        //シーンの作成
        let scene = TitleScene()
        
        //ViewControllerのViewをSKView型として取り出す
        let skView = self.view as? SKView
        
        //シーンのサイズにビューを合わせる
        scene.size = skView!.frame.size
        
        //ビュー上にシーンを表示
        skView!.presentScene(scene)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
