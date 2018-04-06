//
//  ViewController.swift
//  LogTrip
//
//  Created by 河野穣 on 2018/02/02.
//  Copyright © 2018年 河野穣. All rights reserved.
//

import UIKit
import APIKit
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBAction func goBack(_ segue:UIStoryboardSegue) {}
    
    @IBOutlet weak var startBtn: UIButton!
    // セグエ遷移用に追加 ↓↓↓
    @IBAction func goEditBySegue(_ sender:UIButton) {
        performSegue(withIdentifier: "toEditSegue", sender: nil)
        //StationInfo.testPrint(stationTitle: "新宿")
        
    }
    
    @IBAction func goResumeBySegue(_ sender:UIButton) {
        performSegue(withIdentifier: "toResumeSegue", sender: nil)
        //StationInfo.testPrint(stationTitle: "新宿")
        
    }
    
    
    override func viewDidLoad() {
        // タイトルをセット
        self.navigationItem.title = "LOG TRIP"
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedStringKey.font: UIFont(name: "DIN-BoldAlternate", size: 23)!]
        super.viewDidLoad()
        
        startBtn.layer.borderColor = UIColor.black.cgColor
        startBtn.layer.borderWidth = 2.0
        startBtn.layer.cornerRadius = (startBtn.bounds).width/90.0
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: "戻ります", style: .plain, target: nil, action: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController!.navigationBar.topItem!.title = "LOG TRIP"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

