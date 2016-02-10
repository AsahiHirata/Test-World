//
//  AnswerViewController.swift
//  First Original App
//
//  Created by 平田朝飛 on 2015/10/16.
//  Copyright © 2015年 Asahi. All rights reserved.
//

import UIKit
import iAd

class AnswerViewController: UIViewController {
    
    @IBOutlet weak var mondaiImageView: UIImageView!

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
 
    @IBOutlet weak var kaitouLabel: UILabel!
    @IBOutlet weak var hanteiImageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var mondaiTextView: UITextView!
    var data = 0//SelectViewControllerから送られてきた値を入れるための変数
    var mondaiCount = 1
    var csvArray = [String]()
    var mondaiArray = [String]()
    var kaitou = 0
    var taimer:AnyObject!
    var seikaiCount = 0 //正解した数
    var value = 0//ResultViewControllerに値を送るための変数
  
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //広告の表示
        self.canDisplayBannerAds = true
        //csvを読み込む
        var csvName = ""
        switch data{
        case 0:
            csvName = "anime"
        case 1:
            csvName = "nazonazo"
        case 2:
            csvName = "joushiki"
        case 3:
            csvName = "sports"
        case 4:
            csvName = "geinou"
       default:
            break
            }
        
        let csvBundle = NSBundle.mainBundle().pathForResource(csvName, ofType: "csv")
        let csvData: NSString!
        do{
            csvData = try NSString(contentsOfFile: csvBundle!, encoding: NSUTF8StringEncoding)
        }catch {
            csvData = nil
        }
        
        let linechange = csvData!.stringByReplacingOccurrencesOfString("\r", withString: "")
        csvArray = linechange.componentsSeparatedByString("\n")
        
        //配列csvArrayの中身を出力
        print("\(csvArray)")
        
        csvArray = mondaishuffle()
        //問題文セット
        // 行ごとに区切られた配列をさらに　, ごとに区切る
        mondaiArray = csvArray[mondaiCount].componentsSeparatedByString(",")
        mondaiTextView.text = mondaiArray[0]
        countLabel.text = "\(mondaiCount) 問目"
        //テキスト入力不可
        mondaiTextView.editable = false
        
        //選択肢セット
        btn1.setTitle(mondaiArray[2], forState: .Normal)
        btn2.setTitle(mondaiArray[3], forState: .Normal)
        btn3.setTitle(mondaiArray[4], forState: .Normal)
        btn4.setTitle(mondaiArray[5], forState: .Normal)
        
        //タグ設定
        btn1.tag = 1
        btn2.tag = 2
        btn3.tag = 3
        btn4.tag = 4
        // Do any additional setup after loading the view.
    }
    
    //四択のボタンを押したらこのメソッドが呼ばれる
    @IBAction func btnAction(sender: UIButton){
    
        kaitou = Int(mondaiArray[1])!
        if sender.tag == Int(mondaiArray[1]){
            
           UIView.animateWithDuration(5, animations: { () -> Void in self.hanteiImageView.image = UIImage(named: "maru.png")})
            kaitouLabel.text = "答え　\(mondaiArray[sender.tag + 1])"
            seikaiCount++
        }else{
            hanteiImageView.image = UIImage(named: "batsu.png")
            kaitouLabel.text = "答え　\(mondaiArray[kaitou + 1])"
       }
        //ボタン停止
        btn1.enabled = false
        btn2.enabled = false
        btn3.enabled = false
        btn4.enabled = false
        
        if mondaiCount >= 10{
        //問題数が１０になったら画面遷移させる
            hanteiImageView.tag = 200
            }
       }
    
    //ResultViewControllerに画面遷移した時にこのメソッドが呼ばれる（値渡し）
    override func prepareForSegue(segue: UIStoryboardSegue,sender: AnyObject!){
        let cSV = segue.destinationViewController as! ResultViewController
        cSV.value = seikaiCount
    }
    
    //kaitouLabel(答え)をタッチした時にこのメソッドが呼ばれる
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        switch hanteiImageView.tag{
        case 100:
            NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "nextmondai", userInfo: nil, repeats: false)
            //タッチして0秒ごにnextmondaiメソッドが呼ばれる
        case 200:
            NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "lastmondai", userInfo: nil, repeats: false)
            //タッチして0秒ごにlastmondaiメソッドが呼ばれる
        default:
            break
        }
    }
    
    func nextmondai(){
        if (btn1.enabled == false){
     
        mondaiCount++
        //回答と　⭕️ or ❌を削除
        hanteiImageView.image = nil
        kaitouLabel.text = nil
        //問題セット
        mondaiArray = csvArray[mondaiCount].componentsSeparatedByString(",")
        countLabel.text = "\(mondaiCount) 問目"
        
        mondaiTextView.text = mondaiArray[0]
        btn1.setTitle(mondaiArray[2], forState: .Normal)
        btn2.setTitle(mondaiArray[3], forState: .Normal)
        btn3.setTitle(mondaiArray[4], forState: .Normal)
        btn4.setTitle(mondaiArray[5], forState: .Normal)
        
        //ボタン再開
        btn1.enabled = true
        btn2.enabled = true
        btn3.enabled = true
        btn4.enabled = true
       }
    }
    
    //結果画面に遷移
    func lastmondai(){
        self.performSegueWithIdentifier("to_result", sender: self)
    }
    
    //問題シャッフル
    func mondaishuffle() -> [String]{
        var array = [String]()
        let sortedArray = NSMutableArray(array: csvArray)
        var arrayCount = sortedArray.count
        while(arrayCount > 0){
            let randomIndex = arc4random() % UInt32(arrayCount)
            sortedArray.exchangeObjectAtIndex((arrayCount-1), withObjectAtIndex: Int(randomIndex))
            arrayCount = arrayCount - 1
            array.append(sortedArray[arrayCount] as! String)
        }
    return array
    }
  
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
