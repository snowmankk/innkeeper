//
//  CommuCollectionViewCell.swift
//  innkeeper
//
//  Created by orca on 2020/07/13.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class CommuCollectionViewCell: UICollectionViewCell {
    static let identifier = "CommuCollectionViewCell"
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var title: UILabel!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(data: CommuCellData) {
        self.image.image = UIImage(named: data.imgName)
        self.title.text = data.title
        
        self.image.isHidden = data.hidden
        self.title.isHidden = data.hidden
    }
}
