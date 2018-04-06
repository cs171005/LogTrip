//
//  StationNameSearchTableViewCell.swift
//  LogTrip
//
//  Created by 河野穣 on 2018/02/26.
//  Copyright © 2018年 河野穣. All rights reserved.
//

import UIKit

class StationNameSearchTableViewCell: UITableViewCell {

    @IBAction func goBack(_ segue:UIStoryboardSegue) {}
    @IBOutlet weak var StationNameLbl: UILabel!
    @IBOutlet weak var StationHiraganaLbl: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        appDelegate.savedStationName.remove(at: appDelegate.tappedIndex)
        appDelegate.savedStationName.insert(StationNameLbl.text!, at: appDelegate.tappedIndex)
        print(StationNameLbl.text!)
        super.touchesEnded(touches, with: event)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
