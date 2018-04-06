//
//  EditViewController.swift
//  LogTrip
//
//  Created by 河野穣 on 2018/02/03.
//  Copyright © 2018年 河野穣. All rights reserved.
//

import UIKit
import APIKit
import SwiftyJSON
import Photos

class EditViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate,
UITableViewDataSource,UIImagePickerControllerDelegate,TouchImageViewDelegate {
    
    var appDelegate : AppDelegate!
    
    let maximumStationNumber = 5
    var stationName: NSMutableArray = ["吉祥寺", "舞浜"]
    
    @IBAction func goBack(_ segue:UIStoryboardSegue) {}
    
    // セグエ遷移用に追加 ↓↓↓
    @IBAction func goPostBySegue(_ sender:UIButton) {
        if appDelegate.savedStationName.contains(initialStationKanjiTitle){
            let alert: UIAlertController = UIAlertController(title: "駅名未入力", message: "駅名が入力されていない箇所があります", preferredStyle:  UIAlertControllerStyle.alert)
            
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
            
        }else{
            uploadSavedContentsOfImageView()
            uploadSavedStationName()
            performSegue(withIdentifier: "ThirdSegue", sender: nil)
        }
    }
    
    @IBOutlet weak var NextBtn: UIButton!
    func goTrimImageVC(){
        self.present(TrimImageVC(), animated: true, completion: nil)
    }
    
    @IBOutlet weak var AddBtn: UIButton!
    @IBAction func cellAddBtn(_ sender: Any) {
        if EditTableView.numberOfRows(inSection: 0) < maximumStationNumber{
            print("added")
            stationName.add("cat")
            uploadSavedContentsOfImageView()
            uploadSavedStationName()
            EditTableView.reloadData()
            
        }
        
        if EditTableView.numberOfRows(inSection: 0) >= maximumStationNumber{
            AddBtn.isEnabled = false
        }else{
            AddBtn.isEnabled = true
        }
    }
    
    var imageIndex = 0
    var imageList = [UIImage]()
    var imageFileNameList = [String]()
    var imageView: UIImageView!
    let imageFileManager = ImageFileManager()
    let imageListFileManager = ImageListFileManager()
    var photoLibraryManager : PhotoLibraryManager!
    let imageViewCreator = ImageViewCreator()
    let defaults = UserDefaults.standard
    let initialStationKanjiTitle = "[タップして駅名を入力]"
    
    
    @IBOutlet weak var EditTableView: UITableView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        
        self.navigationItem.title = "LOG TRIP"
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedStringKey.font: UIFont(name: "DIN-BoldAlternate", size: 23)!]
        
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = editButtonItem
                    self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: .plain,
            target: self,
            action: #selector(self.back(sender:)
            )
        )
        
        self.navigationItem.leftBarButtonItem = newBackButton
        navigationController!.navigationBar.topItem!.leftBarButtonItem?.title = ""
        
        //navigationController!.navigationBar.topItem!.title = ""
        
        NextBtn.layer.borderColor = UIColor.black.cgColor
        NextBtn.layer.borderWidth = 2.0
        NextBtn.layer.cornerRadius = (NextBtn.layer.bounds).width/60.0
        
        AddBtn.layer.borderColor = UIColor.black.cgColor
        AddBtn.layer.borderWidth = 2.0
        AddBtn.layer.cornerRadius = (AddBtn.layer.bounds).width/60.0
        
        EditTableView.delegate = self
        EditTableView.dataSource = self
        EditTableView.isScrollEnabled = false
        EditTableView.allowsSelectionDuringEditing = false
        EditTableView.allowsSelection = false
        
        
        
        photoLibraryManager = PhotoLibraryManager(parentViewController: self)
        appDelegate  = (UIApplication.shared.delegate as! AppDelegate)
        
        appDelegate.savedContentsOfImageView1 =  [UIImage](repeating: UIImage(named:"InitialImageFramed")!, count: maximumStationNumber)
        appDelegate.savedContentsOfImageView2 =  [UIImage](repeating: UIImage(named:"InitialImageFramed")!, count: maximumStationNumber)
        appDelegate.savedStationName = [initialStationKanjiTitle, initialStationKanjiTitle]
        
        print("did load")
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        
        print("did appear")
        //EditTableView.reloadData()
        uploadSavedContentsOfImageView()
        updateContentOfImageViewOfAllCells()
        updateContentOfStationNameOfAllCells()
        print(appDelegate.savedStationName)
        print("did reload")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController!.navigationBar.topItem!.title = ""
        
        let viewControllers = self.navigationController?.viewControllers
        if indexOfArray(array: viewControllers!, searchObject: self) == nil {
            // Perform your custom actions
            // ...
            // ① UIAlertControllerクラスのインスタンスを生成
            // タイトル, メッセージ, Alertのスタイルを指定する
            // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
            let alert: UIAlertController = UIAlertController(title: "制作途中のデータは保存されません", message: "現在のデータを破棄して最初の画面に戻りますか？", preferredStyle:  UIAlertControllerStyle.actionSheet)
            
            // ② Actionの設定
            // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
            // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
            // OKボタン
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                // Go back to the previous ViewController
                self.navigationController?.popViewController(animated: true)
                print("OK")
            })
            // キャンセルボタン
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("Cancel")
            })
            
            // ③ UIAlertControllerにActionを追加
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            
            // ④ Alertを表示
            present(alert, animated: true, completion: nil)
            // Go back to the previous ViewController
            self.navigationController?.popViewController(animated: true)
        }
        
        super.viewWillDisappear(animated)
    }
    
    func indexOfArray(array:[AnyObject], searchObject: AnyObject)-> Int? {
        for (index, value) in array.enumerated() {
            if value as! UIViewController == searchObject as! UIViewController {
                return index
            }
        }
        return nil
    }

    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "制作途中のデータは保存されません", message: "現在のデータを破棄して最初の画面に戻りますか？", preferredStyle:  UIAlertControllerStyle.actionSheet)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            // Go back to the previous ViewController
            self.navigationController?.popViewController(animated: true)
            print("OK")
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
        // Go back to the previous ViewController
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return stationName.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EditTableView.bounds.height/CGFloat(maximumStationNumber)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editTableCell") as! EditTableViewCell
        print("new cells genarated")
        print(appDelegate.savedContentsOfImageView1.count)
        //cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 90
        
        cell.stationNameLabel.text = (stationName[indexPath.row] as! String)
        cell.stationNameLabel.adjustsFontSizeToFitWidth = true
        
        cell.delegate = self
        cell.indexPath = indexPath
        
        updateContentOfImageViewOfOneCell(cell: cell, index: indexPath.row)
        updateContentOfStationNameOfOneCell(cell: cell, index: indexPath.row)
        
        if EditTableView.numberOfRows(inSection: 0) < 2{
            NextBtn.isEnabled = false
        }else{
            NextBtn.isEnabled = true
        }
        
        return cell
    }
    
    func tapIcon(gestureRecognizer: UITapGestureRecognizer) {
        let tappedLocation = gestureRecognizer.location(in: EditTableView)
        let tappedIndexPath = EditTableView.indexPathForRow(at: tappedLocation)
        let tappedRow = tappedIndexPath?.row
        print("tappedRow:", tappedRow ?? "error")
    }
    
    
    /*
     * 各indexPathのcellが編集(削除，移動等)を行えるか指定します．
     * また，tableViewが編集モードにはいった際にも呼ばれます．
     */
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool{
        return false
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        EditTableView.isEditing = editing
    }
    
    /*
     * 各indexPathのcellのスワイプメニューのうちいずれかがタップされた際に呼ばれます．
     * tableView(_:editActionsForRowAt:)でスワイプメニューをカスタマイズしている際には
     * そのメソッド内で設定したクロージャが呼ばれ，本メソッドは呼ばれません．
     */
    
    //削除時の処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("commit: \(editingStyle), \(indexPath)")
        if editingStyle == UITableViewCellEditingStyle.delete {
            stationName.removeObject(at:indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
        
        if EditTableView.numberOfRows(inSection: 0) >= maximumStationNumber{
            AddBtn.isEnabled = false
        }else{
            AddBtn.isEnabled = true
        }
        
        if EditTableView.numberOfRows(inSection: 0) < 2{
            NextBtn.isEnabled = false
        }else{
            NextBtn.isEnabled = true
        }
        
        print("deleted")
        uploadSavedContentsOfImageView()
        uploadSavedStationName()
        print("image count:",appDelegate.savedContentsOfImageView1.count)
    }
    
    //移動時の処理
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // データの順番を整える
        let targetTitle = stationName[sourceIndexPath.row]
        stationName.removeObject(at: sourceIndexPath.row)
        stationName.insert(targetTitle, at: destinationIndexPath.row)
        
        let targetImage1 = appDelegate.savedContentsOfImageView1[sourceIndexPath.row]
        appDelegate.savedContentsOfImageView1.remove(at: sourceIndexPath.row)
        appDelegate.savedContentsOfImageView1.insert(targetImage1, at: sourceIndexPath.row)
        
        let targetImage2 = appDelegate.savedContentsOfImageView2[sourceIndexPath.row]
        appDelegate.savedContentsOfImageView2.remove(at: sourceIndexPath.row)
        appDelegate.savedContentsOfImageView2.insert(targetImage2, at: sourceIndexPath.row)
        
        
        print("moved")
        uploadSavedContentsOfImageView()
        uploadSavedStationName()
        print("image count:",appDelegate.savedContentsOfImageView1.count)
    }
    
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        print(stationName,[indexPath.row])
    }
    
    func callPhotoLibrary(){
        photoLibraryManager.callPhotoLibrary()
    }
    
    func performSeguetoStationNameSrcVC(){
        performSegue(withIdentifier: "stationNameSrcSegue", sender: nil)
    }
    
    //MARK: Delegates
    //写真選択完了後に呼ばれる標準メソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("IPCC ran")
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            if appDelegate.tappedIndex >= 0 && appDelegate.tappedIndex < appDelegate.savedContentsOfImageView1.count{
                switch appDelegate.tappedComponents{
                case EditTableViewCell.spotImageTag:
                    appDelegate.savedContentsOfImageView1.remove(at: appDelegate.tappedIndex)
                    appDelegate.savedContentsOfImageView1.insert(pickedImage, at: appDelegate.tappedIndex)
                    //appDelegate.savedContentsOfImageView1[appDelegate.tappedIndex] =
                    break
                case EditTableViewCell.spotImage2Tag:
                    appDelegate.savedContentsOfImageView2.remove(at: appDelegate.tappedIndex)
                    appDelegate.savedContentsOfImageView2.insert(pickedImage, at: appDelegate.tappedIndex)
                    break
                default:
                    
                    break
                }
                
            }else{
                print("index out")
                switch appDelegate.tappedComponents{
                case EditTableViewCell.spotImageTag:
                    appDelegate.savedContentsOfImageView1.append(pickedImage)
                    //appDelegate.savedContentsOfImageView1[appDelegate.tappedIndex] =
                    break
                case EditTableViewCell.spotImage2Tag:
                    appDelegate.savedContentsOfImageView2.append(pickedImage)
                    break
                default:
                    
                    break
                }
            }
            uploadSavedStationName()
            updateContentOfImageViewOfAllCells()
            dismiss(animated: true)
        }
    }
    
    func uploadSavedStationName(){
        appDelegate.savedStationName.removeAll(keepingCapacity: true)
        for index in (0..<EditTableView.numberOfRows(inSection: 0)){
            print("uploadSavedStationName:",index)
            appDelegate.savedStationName.append((EditTableView.cellForRow(at: IndexPath(row: index, section: 0)) as! EditTableViewCell).stationNameLabel.text!)
        }
    }
    
    func updateContentOfStationNameOfOneCell(cell:EditTableViewCell,index:Int){
        if index >= 0 && index < appDelegate.savedStationName.count{
            cell.stationNameLabel.text = appDelegate.savedStationName[index]
        }else{
            cell.stationNameLabel.text = initialStationKanjiTitle
            appDelegate.savedStationName.append(cell.stationNameLabel.text!)
        }
    }
    
    public func updateContentOfStationNameOfAllCells(){
        for index in (0..<EditTableView.numberOfRows(inSection: 0)){
            print("updateContentOfImageView",index)
            if index >= 0 && index < appDelegate.savedStationName.count{
                (EditTableView.cellForRow(at: IndexPath(row: index, section: 0)) as! EditTableViewCell).stationNameLabel.text = appDelegate.savedStationName[index]
            }else{
                (EditTableView.cellForRow(at: IndexPath(row: index, section: 0)) as! EditTableViewCell).stationNameLabel.text = initialStationKanjiTitle
            }
        }
    }
    
    func uploadSavedContentsOfImageView(){
        appDelegate.savedContentsOfImageView1.removeAll(keepingCapacity: true)
        appDelegate.savedContentsOfImageView2.removeAll(keepingCapacity: true)
        for index in (0..<EditTableView.numberOfRows(inSection: 0)){
            print("uploadSavedContentsOfImageView:",index)
            appDelegate.savedContentsOfImageView1.append((EditTableView.cellForRow(at: IndexPath(row: index, section: 0)) as! EditTableViewCell).spotImage.image!)
            appDelegate.savedContentsOfImageView2.append((EditTableView.cellForRow(at: IndexPath(row: index, section: 0)) as! EditTableViewCell).spotImage2.image!)
        }
    }
    
    func updateContentOfImageViewOfOneCell(cell:EditTableViewCell,index:Int){
        if index >= 0 && index < appDelegate.savedContentsOfImageView1.count{
            cell.spotImage.image = appDelegate.savedContentsOfImageView1[index]
        }else{
            cell.spotImage.image = UIImage(named:"InitialImageFramed")
            appDelegate.savedContentsOfImageView1.append(cell.spotImage.image!)
        }
        
        if index >= 0 && index < appDelegate.savedContentsOfImageView2.count{
            cell.spotImage2.image = appDelegate.savedContentsOfImageView2[index]
        }else{
            cell.spotImage2.image = UIImage(named:"InitialImageFramed")
            appDelegate.savedContentsOfImageView2.append(cell.spotImage2.image!)
        }
    }
    
    public func updateContentOfImageViewOfAllCells(){
        for index in (0..<EditTableView.numberOfRows(inSection: 0)){
            print("updateContentOfImageView",index)
            if index >= 0 && index < appDelegate.savedContentsOfImageView1.count{
                (EditTableView.cellForRow(at: IndexPath(row: index, section: 0)) as! EditTableViewCell).spotImage.image = appDelegate.savedContentsOfImageView1[index]
            }else{
                (EditTableView.cellForRow(at: IndexPath(row: index, section: 0)) as! EditTableViewCell).spotImage.image =  UIImage(named:"InitialImageFramed")
            }
            
            if index >= 0 && index < appDelegate.savedContentsOfImageView2.count{
                (EditTableView.cellForRow(at: IndexPath(row: index, section: 0)) as! EditTableViewCell).spotImage2.image = appDelegate.savedContentsOfImageView2[index]
            }else{
                (EditTableView.cellForRow(at: IndexPath(row: index, section: 0)) as! EditTableViewCell).spotImage2.image = UIImage(named:"InitialImageFramed")
            }
            
        }
    }
}
