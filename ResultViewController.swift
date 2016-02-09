//
//  ResultViewController.swift
//  First Original App
//
//  Created by 平田朝飛 on 2015/10/16.
//  Copyright © 2015年 Asahi. All rights reserved.
//

import UIKit
import Social

class ResultViewController: UIViewController {
    
    @IBOutlet weak var resultimageView: UIImageView!
    @IBOutlet weak var twbtn: UIButton!
    @IBOutlet weak var fbbtn: UIButton!

    var value = 0//SelectViewControllerから送られてきた値を入れるための変数
    internal var shougou = ""
    //MainStoryBoadを使わずにUILabel作成
    var seikaiLabel = UILabel()
    var seikaiLabelresult = UILabel()
    var shougouLabel = UILabel()
    var shougouLabelresult = UILabel()
    var touch = 0
    var selectbtn = UIButton()
   
    //画面サイズを取得
    let screenSize:CGSize = (UIScreen.mainScreen().bounds.size)
    
    override func viewDidLoad() {
      super.viewDidLoad()
        
        seikaiLabel.frame = CGRect(x: 0,y: 100,width: 300,height: 50)
        shougouLabel.frame = CGRect(x: 0,y: 300,width: 300,height: 50)
        
        //位置の設定
        seikaiLabel.layer.position = CGPoint(x: self.view.bounds.width/2,y: 100)
        shougouLabel.layer.position = CGPoint(x: self.view.bounds.width/2,y: 320)
        
        //センターに揃える
        seikaiLabel.textAlignment = NSTextAlignment.Center
        seikaiLabelresult.textAlignment = NSTextAlignment.Center
        shougouLabel.textAlignment = NSTextAlignment.Center
        shougouLabelresult.textAlignment = NSTextAlignment.Center
        
        //フォント
        seikaiLabel.font = UIFont(name: "Arial", size: 20)
        seikaiLabelresult.font = UIFont(name: "Arial", size: 20)
        shougouLabel.font = UIFont(name: "Arial", size: 20)
        shougouLabelresult.font = UIFont(name: "Arial", size: 20)
        
        seikaiLabel.text = "あなたの正解数は・・・"
        seikaiLabelresult.text = "\(value)問!!"
        shougouLabel.text = "あなたのクイズレベルは・・・"
        //正解数によって称号を決める
        switch value{
        case 0,1:
            shougou = "クイズかけだし!!"
        case 2,3:
            shougou = "クイズ人見知り!!"
        case 4,5:
            shougou = "クイズのものしり!!"
        case 6,7:
            shougou = "クイズ玄人!!"
        case 8,9:
            shougou = "クイズ熟練者!!"
        case 10:
            shougou = "クイズ博士!!"
        default:
            break
        }
        shougouLabelresult.text = shougou
        
        //LabelをResultViewController上に配置
        self.view.addSubview(seikaiLabel)
        self.view.addSubview(seikaiLabelresult)
        self.view.addSubview(shougouLabelresult)
        self.view.addSubview(shougouLabel)
        self.view.addSubview(selectbtn)
    }
    
    //画面をタッチした時に呼ばれるメソッド
   override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        let center = Double(screenSize.width/2) - 320 / 2
    switch touch{
    case 0:
        UIView.animateWithDuration(0.6, animations:{ () -> Void in self.seikaiLabelresult.frame = CGRect(x: center,y: 200, width: 320, height: 50);})
        touch++
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()//タッチイベントを無効にする
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "touchon", userInfo: nil, repeats: false)
        //画面をタッチして２秒後に”touchon”メソッドが呼ばれる
    case 1:
        UIView.animateWithDuration(0.8, animations:{ () -> Void in self.shougouLabelresult.frame = CGRect(x: center,y: 410, width: 320, height: 50);})
        touch++
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "backbtn", userInfo: nil, repeats: false)
        //case:1を読んで２秒後に”backbtn”メソッドが呼ばれる

    default:
        break
    }

}
    
    func touchon(){
        UIApplication.sharedApplication().endIgnoringInteractionEvents()//タッチイベントを有効にする
    }
    
    func backbtn(){
        selectbtn.setImage(UIImage(named: "btnbtnbtn.png"), forState: .Normal)
        selectbtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        //タップしてonClickbtnメソッドを呼び出し
        selectbtn.addTarget(self, action: "onClickselectbtn:", forControlEvents: .TouchUpInside)
        
        let center = Double(screenSize.width/2) - 80 / 2
        UIView.animateWithDuration(0.8, animations:{ () -> Void in self.selectbtn.frame = CGRect(x: center,y: 500, width: 80, height: 30);})
    }
    
    @IBAction func onClickselectbtn(btn :UIButton) {
    //2つ目の画面遷移に戻るメソッド
        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Facebook投稿メソッド
    @IBAction func postFacebook(sender: AnyObject) {
        
        //Facebook投稿用定数を作成
        let fbVC:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
        //投稿テキストを設定
        fbVC.setInitialText("面白クイズアプリ！。私は\(shougou)。正解数は\(value)回です！みんなもあそんでみよう！")
        //投稿画像を設定
        fbVC.addImage(UIImage(named: "iconquiz.png"))
        //投稿用URLを設定
        fbVC.addURL(NSURL(string: "http://onthehammock.com/app/5783"))
        //投稿コントローラーを起動
        self.presentViewController(fbVC, animated: true, completion: nil)
    }
    
    //Twitter投稿メソッド
    @IBAction func postTwitter(sender: AnyObject) {
        //Twitter投稿用定数を作成
        let twVC:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
        //投稿テキストを設定
        twVC.setInitialText("面白クイズアプリ！。私は\(shougou)。合格回数は\(value)回です！みんなもあそんでみよう！")
        //投稿画像を設定
        twVC.addImage(UIImage(named: "iconquiz.png"))
        //投稿用URLを設定
        twVC.addURL(NSURL(string: "http://onthehammock.com/app/5783"))
        //投稿コントローラーを起動
        self.presentViewController(twVC, animated: true, completion: nil)
    }
        // Do any additional setup after loading the view.
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
