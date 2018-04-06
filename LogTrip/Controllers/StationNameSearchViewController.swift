//
//  StationNameSearchViewController.swift
//  
//
//  Created by 河野穣 on 2018/02/26.
//

import UIKit

class StationNameSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{

    @IBOutlet weak var StationNameSearchTableView: UITableView!
    @IBOutlet weak var StationNameSearchBar: UISearchBar!
    
    var stationNameMaster:[String : String] = [:]
    var dataList : [String] = []
    
    override func viewDidLoad() {
        
        self.navigationItem.title = "LOG TRIP"
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedStringKey.font: UIFont(name: "DIN-BoldAlternate", size: 23)!]
        
        let defaults = UserDefaults.standard
        stationNameMaster = defaults.object(forKey:"STATION_NAME_MASTER") as! [String:String]
        dataList = [String](stationNameMaster.keys)
        dataList = dataList.sorted { (lhs, rhs) in return stationNameMaster[lhs]! < stationNameMaster[rhs]! }

        currentDataList = dataList
        setUpSearchBar()
        
        navigationController!.navigationBar.topItem!.title = ""
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController!.navigationBar.topItem!.title = "LOG TRIP"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setUpSearchBar(){
        StationNameSearchBar.delegate = self
        StationNameSearchBar.showsCancelButton = true
    }
    
    // キーボードが表示されるときにキャンセルボタンを有効に
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        StationNameSearchBar.showsCancelButton = true
    }
    
    // キャンセルボタンが押されたらキャンセルボタンを無効にしてフォーカスをはずす
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    //データ
    var currentDataList = [String]()
    
    //table view
    //データを返すメソッド
    func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        //セルを取得する。
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationNameSearchTableViewCell", for:indexPath as IndexPath) as UITableViewCell
        
        (cell as! StationNameSearchTableViewCell).StationNameLbl?.text = currentDataList[indexPath.row]
        (cell as! StationNameSearchTableViewCell).StationHiraganaLbl?.text = stationNameMaster[currentDataList[indexPath.row]]
        return cell
    }
    
    
    
    //データの個数を返すメソッド
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return currentDataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //search bar
    //テキスト変更時の呼び出しメソッド
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        StationNameSearchBar.showsCancelButton = true
        //検索結果配列を空にする。
        currentDataList.removeAll()
        
        if(StationNameSearchBar.text == "") {
            //検索文字列が空の場合はすべてを表示する。
            currentDataList = dataList
        } else {
            //検索文字列を含むデータを検索結果配列に追加する。
            for data in dataList {
                //Exact match in Kanji||Exact match in Hiragana
                if data.contains(StationNameSearchBar.text!) || (stationNameMaster[data]?.contains(StationNameSearchBar.text!))! {
                    currentDataList.append(data)
                }
            }
        }
        
        
        //テーブルを再読み込みする。
        StationNameSearchTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        StationNameSearchBar.showsCancelButton = true
        //検索結果配列を空にする。
        currentDataList.removeAll()
        
        if(StationNameSearchBar.text == "") {
            //検索文字列が空の場合はすべてを表示する。
            currentDataList = dataList
        } else {
            //検索文字列を含むデータを検索結果配列に追加する。
            for data in dataList {
                //Exact match in Kanji||Exact match in Hiragana
                if data.contains(StationNameSearchBar.text!) || (stationNameMaster[data]?.contains(StationNameSearchBar.text!))! {
                        currentDataList.append(data)
                }
            }
        }
        
//        for eachSta in currentDataList{
//            print(StationInfo.isExistStationInList(stationName: eachSta))
//        }
        //テーブルを再読み込みする。
        StationNameSearchTableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        self.StationNameSearchTableView.scrollToRow(at: [0, index], at: .top, animated: true)
        return index
    }
}


