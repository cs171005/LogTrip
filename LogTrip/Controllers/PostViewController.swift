//
//  PostViewController.swift
//  LogTrip
//
//  Created by 河野穣 on 2018/02/03.
//  Copyright © 2018年 河野穣. All rights reserved.
//

import UIKit
import APIKit
import SwiftyJSON
import Social

class PostViewController: UIViewController {
    
    var appDelegate : AppDelegate!
    var allPassedRailWayList :[[String]] = []
    let ScreenShotBasementView : UIView = UIView()
    let ribbonAndCircleWidth : CGFloat = 15.0
    var numOfRow : Int = 0
    let edgeMargin : CGFloat = 100.0
    let circleBounds: CGFloat = 20.0
    var ImageViewSize : CGSize = CGSize()
    
    @IBAction func goBack(_ segue:UIStoryboardSegue) {}
    
    @IBOutlet weak var generateScreenShotBtn: UIButton!
    @IBAction func generateScreenShot(_ sender: Any) {
        let screenShot = ScreenShotBasementView.CaptureScreenShotImage()
        print(screenShot)
        UIImageWriteToSavedPhotosAlbum(screenShot, self, #selector(PostViewController.imageToPhoto(_:didFinishSavingWithError:contextInfo:)), nil)
        let alert: UIAlertController = UIAlertController(title: "画像を保存しました", message: "", preferredStyle:  UIAlertControllerStyle.alert)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    @objc func imageToPhoto(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        if error != nil {
            /* 失敗 */
            print(error)
        }
    }
    
    // セグエ遷移用に追加 ↓↓↓
    override func viewDidLoad() {
        self.navigationItem.title = "LOG TRIP"
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedStringKey.font: UIFont(name: "DIN-BoldAlternate", size: 23)!]
        
        
        
        
        print("postVC")
        appDelegate  = (UIApplication.shared.delegate as! AppDelegate)
        numOfRow = max(appDelegate.savedContentsOfImageView1.count, appDelegate.savedContentsOfImageView2.count)
        
        var SSBVWidth : CGFloat = self.view.frame.size.width-2
        var SSBVHeight : CGFloat = (SSBVWidth/2)*CGFloat(numOfRow)
        ImageViewSize = CGSize(width: SSBVWidth/2, height: SSBVWidth/2)
        
        // 以降、Landscape のみを想定
//        let screenWidth:CGFloat = view.frame.size.width
        let screenHeight:CGFloat = view.frame.size.height
        
        var topPadding:CGFloat = 0
        var bottomPadding:CGFloat = 0
//        var leftPadding:CGFloat = 0
//        var rightPadding:CGFloat = 0
        // iPhone X , X以外は0となる
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topPadding = window!.safeAreaInsets.top
            bottomPadding = window!.safeAreaInsets.bottom
//            leftPadding = window!.safeAreaInsets.left
//            rightPadding = window!.safeAreaInsets.right
        }
        
        // portrait
        //let safeAreaWidth = screenWidth - leftPadding - rightPadding
        let safeAreaHeight = (screenHeight) - topPadding - bottomPadding
        
        if (SSBVHeight >= safeAreaHeight - 100 - navigationBarHeight(callFrom: self)!){
            SSBVHeight = safeAreaHeight - 100 - navigationBarHeight(callFrom: self)!
            SSBVWidth = (SSBVHeight/CGFloat(numOfRow))*2
            ImageViewSize = CGSize(width: SSBVWidth/2, height: SSBVWidth/2)
        }
        
        ScreenShotBasementView.frame = CGRect(x:0,y: 0 ,width: SSBVWidth,height: SSBVHeight) //x:0 y:0 で与える位置座標はcenterで置き換わるので，とりあえず入れている．
        ScreenShotBasementView.backgroundColor = UIColor.white
        ScreenShotBasementView.center = self.view.center
        ScreenShotBasementView.layer.borderColor = UIColor.white.cgColor
        ScreenShotBasementView.layer.borderWidth = 1.0
        
        self.view.addSubview(ScreenShotBasementView)
        
        navigationController!.navigationBar.topItem!.title = " "
        
        generateScreenShotBtn.layer.borderColor = UIColor.black.cgColor
        generateScreenShotBtn.layer.borderWidth = 2.0
        generateScreenShotBtn.layer.cornerRadius = (generateScreenShotBtn.bounds).width/90.0
        // ナビゲーションを透明にする処理
//        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController!.navigationBar.shadowImage = UIImage()
        //self.view.backgroundColor = UIColor(hex: "1d1e1e") //mad black
        
        self.view.bringSubview(toFront: generateScreenShotBtn)
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let KanjiToSameAsDictList :[String:String] = defaults.object(forKey:"STATION_KANJI_TO_SAMEAS") as! [String:String]
        var stationSameAs : [String] = []
        
        appDelegate.savedStationName.forEach {
            stationSameAs.append(KanjiToSameAsDictList[$0]!)
        }
        
        for index in 0..<stationSameAs.count{
            if index != stationSameAs.count - 1{
                allPassedRailWayList.append(RouteSearch.searchRoute(origin: stationSameAs[index], destination: stationSameAs[index+1],isOutputAsStationNames: false))
            }
        }
        
        for row in 0 ..< appDelegate.savedContentsOfImageView1.count {
            initImageView(row: row, IVNumber: 1)
            initImageView(row: row, IVNumber: 2)
        }
        
        for row in 0 ..< appDelegate.savedContentsOfImageView1.count {
            initRailWayRibbon(row: row)
            initRailWayStationCircle(row: row)
            initStationNameLabel(row: row)
        }
        
        
        let creditLabel: UILabel = UILabel(frame: CGRect(x: ScreenShotBasementView.frame.size.width/2, y: ScreenShotBasementView.frame.size.height - 28, width: ScreenShotBasementView.frame.size.width/2 - 2, height: 28))
        creditLabel.text = "powered by LOG TRIP TOKYO"
        creditLabel.textAlignment = .right
        creditLabel.textColor = UIColor.white
        creditLabel.font = UIFont(name: "DIN-Regular", size: 9)
        creditLabel.adjustsFontSizeToFitWidth = true
        ScreenShotBasementView.addSubview(creditLabel)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController!.navigationBar.topItem!.title = "LOG TRIP"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAllCellContetents(){
        //initImageView()
    }
    
    private func navigationBarHeight(callFrom: UIViewController) -> CGFloat? {
        return callFrom.navigationController?.navigationBar.frame.size.height
    }
    
    private func initStationNameLabel(row:Int){
        
        //let strechedIVPositionXInterval:CGFloat = screenWidth/heightSplit
        // UIImageView 初期化
        
        let stationNameLabel = UILabel()
        //y:screenHeight/heightSplit * (CGFloat(row)+1.0)
        
        //let startFrom: CGFloat = ImageViewSize.height * (CGFloat(row)) + 0.1 * ImageViewSize.height
        stationNameLabel.frame.origin = CGPoint(x:ribbonAndCircleWidth + circleBounds/2 + ImageViewSize.height*0.1 , y:ImageViewSize.height * (CGFloat(row)) + 0.1 * ImageViewSize.height - circleBounds/2)
        stationNameLabel.frame.size = CGSize(width:(ImageViewSize.width - stationNameLabel.frame.origin.x)*0.95, height:circleBounds)
        stationNameLabel.contentMode = UIViewContentMode.scaleAspectFill
        stationNameLabel.font = UIFont(name: "HiraKakuProN-W6", size: 18)
        stationNameLabel.adjustsFontSizeToFitWidth = true
        stationNameLabel.textAlignment = .left
        stationNameLabel.baselineAdjustment = .alignCenters
        stationNameLabel.text = appDelegate.savedStationName[row]
        stationNameLabel.textColor = UIColor.white
        

        // UIImageViewのインスタンスをビューに追加
        self.ScreenShotBasementView.addSubview(stationNameLabel)
        
    }
    
    private func initRailWayRibbon(row:Int){
        print(allPassedRailWayList)
        
        if row < numOfRow-1{
            var i = 0
            for eachRailWay in allPassedRailWayList[row]{
                print(RouteSearch.railWayColor[eachRailWay]!)
                let railwayRibbon : UIView = UIView.init()
                //ImageViewSize.height * (CGFloat(row)) + 0.1 * ImageViewSize.height
                let startFrom: CGFloat = ImageViewSize.height * (CGFloat(row)) + 0.1 * ImageViewSize.height + CGFloat(Float(i)/Float(allPassedRailWayList[row].count))*(ImageViewSize.height)
                railwayRibbon.frame = CGRect(x: ribbonAndCircleWidth, y: startFrom, width: 10, height: CGFloat(ImageViewSize.height)/CGFloat(allPassedRailWayList[row].count))
                railwayRibbon.backgroundColor = RouteSearch.railWayColor[eachRailWay]!
                railwayRibbon.layer.borderColor = UIColor.white.cgColor
                railwayRibbon.layer.borderWidth = 1.5
                ScreenShotBasementView.addSubview(railwayRibbon)
                i = i + 1
            }
        }
        
    }
    
    private func initRailWayStationCircle(row:Int){
        // 画面の縦幅を取得
        //let screenHeight:CGFloat = ScreenShotBasementView.frame.size.height
        //let heightSplit: CGFloat = CGFloat(numOfRow)+1.0
        
        
        print(allPassedRailWayList)
        let startFrom: CGFloat = ImageViewSize.height * (CGFloat(row)) + 0.1 * ImageViewSize.height
        let StationCircle : UIView = UIView(frame:CGRect(x: ribbonAndCircleWidth - circleBounds/4, y: startFrom - 10, width: circleBounds, height: circleBounds))
        StationCircle.layer.cornerRadius = (StationCircle.bounds).width/2.0
        StationCircle.layer.borderColor = UIColor.white.cgColor
        StationCircle.layer.borderWidth = 2.0
        if row < numOfRow - 1 {
            StationCircle.backgroundColor = RouteSearch.railWayColor[allPassedRailWayList[row].first!]
        }else if(row == numOfRow - 1){
            StationCircle.backgroundColor = RouteSearch.railWayColor[allPassedRailWayList.last!.last!]
        }
        ScreenShotBasementView.addSubview(StationCircle)
    }
    private func initImageView(row:Int,IVNumber:Int){
        // 画面の横幅を取得
        let screenWidth:CGFloat = ScreenShotBasementView.frame.size.width
//        let screenHeight:CGFloat = ScreenShotBasementView.frame.size.height
        
        // UIImageView 初期化
        let rect:CGRect = CGRect(x:0, y:0, width:ImageViewSize.width - 1, height:ImageViewSize.height - 1)
        var imageView = UIImageView()
        var imageViewPosition: CGPoint = CGPoint()
        
        switch IVNumber {
        case 1:
            if appDelegate.savedContentsOfImageView1[row] != UIImage(named:"InitialImageFramed"){
                    imageView  = UIImageView(image:appDelegate.savedContentsOfImageView1[row])
            }else{
                    imageView  = UIImageView(image:UIImage(named:"blankWhite"))
            }
            
            imageViewPosition = CGPoint(x:screenWidth/4.0, y:rect.height * CGFloat(Double(row) + 0.5) + CGFloat(Double(row)))
        case 2:
            if appDelegate.savedContentsOfImageView2[row] != UIImage(named:"InitialImageFramed"){
                imageView  = UIImageView(image:appDelegate.savedContentsOfImageView2[row])
            }else{
                imageView  = UIImageView(image:UIImage(named:"blankWhite"))
            }
            imageViewPosition = CGPoint(x:(screenWidth/4.0)*3.0 , y:rect.height * CGFloat(Double(row) + 0.5) + CGFloat(Double(row)))
        default:
            break
        }
        
        // 画像の中心を画面の中心に設定
        imageView.frame = rect
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.center = imageViewPosition
        imageView.clipsToBounds = true
        // UIImageViewのインスタンスをビューに追加
        self.ScreenShotBasementView.addSubview(imageView)
        
    }
}

extension UIView {
    func CaptureScreenShotImage() -> UIImage{
        // キャプチャする範囲を取得.
        
        let rect = self.bounds
        // ビットマップ画像のcontextを作成.
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        // 対象のview内の描画をcontextに複写する.
        self.layer.render(in: context)
    
        // 現在のcontextのビットマップをUIImageとして取得.
        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    
        // contextを閉じる.
        UIGraphicsEndImageContext()
        
        return capturedImage
    }
    
}


