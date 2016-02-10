//
//  SelectViewController.swift
//  First Original App
//
//  Created by 平田朝飛 on 2015/10/16.
//  Copyright © 2015年 Asahi. All rights reserved.
//

import UIKit

class SelectViewController: UIViewController {

    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var selectbutton1: UIButton!
    @IBOutlet weak var selectbutton2: UIButton!
    @IBOutlet weak var selectbutton3: UIButton!
    @IBOutlet weak var selectbutton4: UIButton!
    @IBOutlet weak var selectbutton5: UIButton!
    @IBOutlet weak var backbutton: UIButton!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    var data = 0//AnswerViewControllerに値を送るための変数
    var number = 0//タグが入る
    var flg = false
    //画面がロードされた時に呼ばれるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ボタンを押すと　nextBtnActionメソッドが呼ばれる
        //引く数がある時は　: をつける
        selectbutton1 .addTarget(self, action: "nextBtnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        selectbutton2 .addTarget(self, action: "nextBtnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        selectbutton3 .addTarget(self, action: "nextBtnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        selectbutton4 .addTarget(self, action: "nextBtnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        selectbutton5 .addTarget(self, action: "nextBtnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
   
    @IBAction func nextBtnAction(btn :UIButton) {
        
        print(flg)
       print(btn.tag)
        number = btn.tag
        self.performSegueWithIdentifier("to_mondai", sender: self)
    }
    
    @IBAction func backBtnAction(sender: AnyObject) {
        //もどる
        self .dismissViewControllerAnimated(true, completion: nil)
    }
  
        //AnswerViewControllerに値を渡す
    
        override func prepareForSegue(segue: UIStoryboardSegue,sender: AnyObject!){
        //segueを使用した時に呼ばれるメソッド
        //戻る時にはこのメソッドは必要ないので、戻るボタンにはsegueをつかわない
        let cSV = segue.destinationViewController as! AnswerViewController
        cSV.data = number
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
