//
//  WordCollectionViewCell.swift
//  innkeeper
//
//  Created by orca on 2020/07/28.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class WordCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "WordCollectionViewCell"
    
    @IBOutlet weak var title: UILabel!
    
    func configure(title: String) {
        self.title.text = title
    }
    
    @IBAction func onDelete(_ sender: UIButton) {
        
        guard let keyword = title.text else { return }
        SelectedDatas.shared.setKeywordDatas(keyword: keyword, add: false)
    }
}
