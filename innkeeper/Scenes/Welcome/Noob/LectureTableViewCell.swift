//
//  LectureTableViewCell.swift
//  innkeeper
//
//  Created by orca on 2020/07/13.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class LectureTableViewCell: UITableViewCell {

    static var identifier = "LectureTableViewCell"

    @IBOutlet var img: UIImageView!
    @IBOutlet var title: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(imgName: String, title: String) {
        self.img.image = UIImage(named: imgName)
        self.title.text = title
    }

}
