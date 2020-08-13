//
//  SearchCommuCollectionViewCell.swift
//  innkeeper
//
//  Created by orca on 2020/08/11.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class DecksCommuCollectionViewCell: UICollectionViewCell {
    static let identifier = "DecksCommuCollectionViewCell"

    var url: String = ""
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    func configure(data: CommuCellData) {
        img.image = UIImage(named: data.imgName)
        name.text = data.title
        url = data.url
        print("community url: \(url)")
    }
}
