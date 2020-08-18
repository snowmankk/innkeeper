//
//  SettingsTableViewCell.swift
//  innkeeper
//
//  Created by orca on 2020/08/18.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    static let identifier = "SettingsTableViewCell"
    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(title: String) {
        self.title.text = title
        
        let indicatorImg = UIImage(named: "icon-indicator")?.withTintColor(self.title.textColor)
        self.accessoryView = UIImageView(image: indicatorImg)
        
        let selectedBg = UIView()
        selectedBg.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        self.selectedBackgroundView = selectedBg
    }

}
