//
//  EditTableViewCell.swift
//  LogTrip
//
//  Created by 河野穣 on 2018/02/09.
//  Copyright © 2018年 河野穣. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import AssetsLibrary

protocol TouchImageViewDelegate {
    func callPhotoLibrary() -> Void
    func uploadSavedContentsOfImageView() -> Void
    func performSeguetoStationNameSrcVC() -> Void
}
class EditTableViewCell: UITableViewCell,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    @IBOutlet weak var spotName: UILabel!
    @IBOutlet weak var spotName2: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var spotImage: UIImageView!
    @IBOutlet weak var spotImage2: UIImageView!
    
    var delegate: TouchImageViewDelegate?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var picker = UIImagePickerController()
    
    class var stationNameLabelTag: Int {return 0}
    class var spotImageTag: Int {return 1}
    class var spotImage2Tag: Int {return 2}
    
    var indexPath = IndexPath()
    
    // Initialization code
    override func awakeFromNib() {
        stationNameLabel.isUserInteractionEnabled = true
        stationNameLabel.tag = EditTableViewCell.stationNameLabelTag
        spotImage.isUserInteractionEnabled = true
        spotImage.tag = EditTableViewCell.spotImageTag
        spotImage2.isUserInteractionEnabled = true
        spotImage2.tag = EditTableViewCell.spotImage2Tag
        
        picker.delegate = self
        
        super.awakeFromNib()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch: UITouch in touches {
            let tag = touch.view!.tag
            appDelegate.tappedComponents = tag
            switch tag{
            case EditTableViewCell.stationNameLabelTag:
                print(stationNameLabel.text!)
                self.delegate?.performSeguetoStationNameSrcVC()
                appDelegate.tappedIndex = self.indexPath.row
                break
            
            case EditTableViewCell.spotImageTag:
                self.delegate?.callPhotoLibrary()
                print("called")
                appDelegate.tappedIndex = self.indexPath.row
                print("tapped:",self.indexPath.row,"delgate:",appDelegate.tappedIndex)
                print("imageview tapped")
                
                break
            
            case EditTableViewCell.spotImage2Tag:
                self.delegate?.callPhotoLibrary()
                print("called")
                appDelegate.tappedIndex = self.indexPath.row
                print("tapped:",self.indexPath.row,"delgate:",appDelegate.tappedIndex)
                print("imageview2 tapped")
                
                break
            
            default:
                break
            }
        }
    }
}


