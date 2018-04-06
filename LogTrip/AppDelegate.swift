//
//  AppDelegate.swift
//  LogTrip
//
//  Created by 河野穣 on 2018/02/02.
//  Copyright © 2018年 河野穣. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var photoLibraryImage : UIImage!
    var savedContentsOfImageView1 : Array<UIImage> = []
    var savedContentsOfImageView2 : Array<UIImage> = []
    var savedStationName: Array<String> = ["吉祥寺", "舞浜"]
    var tappedIndex: Int = 0
    var tappedComponents: Int = 0
    
   

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().tintColor = UIColor.black
        
        let userDefault = UserDefaults.standard
        
        // "firstLaunch"をキーに、Bool型の値を保持する
        let fldict = ["firstLaunch": true]
        
        // デフォルト値登録
        // ※すでに値が更新されていた場合は、更新後の値のままになる
        userDefault.register(defaults: fldict)
        
        if userDefault.bool(forKey: "firstLaunch") {
            userDefault.set(false, forKey: "firstLaunch")
            
            let prefs = Bundle.main.path(forResource: "jp.ac.meiji.LogTrip", ofType: "plist")
            let dict = NSDictionary(contentsOfFile: prefs!)
            
            for eachDefault in dict! {
                switch (eachDefault.key as! String){
                case "STATION_KANJI_TO_SAMEAS","STATION_NAME_MASTER":
                    userDefault.set(eachDefault.value as! [String:String], forKey: eachDefault.key as! String)
                    break
                    
                case "NB_STATION_LIST":
                    userDefault.set(eachDefault.value as! [String:[String]], forKey: eachDefault.key as! String)
                    break
                    
                default:
                    break
                }
            }
            print("初回起動の時だけ呼ばれるよ")
        }
        
        print("初回起動じゃなくても呼ばれるアプリ起動時の処理だよ")
        return true
        
        /*
         // Override point for customization after application launch.
         let userDefault = UserDefaults.standard
         // "firstLaunch"をキーに、Bool型の値を保持する
         let dict = ["firstLaunch": true]
         // デフォルト値登録
         // ※すでに値が更新されていた場合は、更新後の値のままになる
         userDefault.register(defaults: dict)
         
         // "firstLaunch"に紐づく値がtrueなら(=初回起動)、値をfalseに更新して処理を行う
         if userDefault.bool(forKey: "firstLaunch") {
         userDefault.set(false, forKey: "firstLaunch")
         let stationNameMaster = StationInfo.initStationNameMaster()
         userDefault.set(stationNameMaster, forKey: "STATION_NAME_MASTER")
         
         let path = Bundle.main.path(forResource: "sourceOfNBStationDictList", ofType: "json")
         let jsondata = try? Data(contentsOf: URL(fileURLWithPath: path!))
         let jsonArray = (try! JSONSerialization.jsonObject(with: jsondata!, options: [])) as! [String:[String]]
         userDefault.set(jsonArray, forKey: "NB_STATION_LIST")
         
         let path2 = Bundle.main.path(forResource: "sourceOfStationTitleKanjiToSameAs", ofType: "json")
         let jsondata2 = try? Data(contentsOf: URL(fileURLWithPath: path2!))
         let jsonArray2 = (try! JSONSerialization.jsonObject(with: jsondata2!, options: [])) as! [String:String]
         userDefault.set(jsonArray2, forKey: "STATION_KANJI_TO_SAMEAS")
         print("初回起動の時だけ呼ばれるよ")
         }
         */
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

