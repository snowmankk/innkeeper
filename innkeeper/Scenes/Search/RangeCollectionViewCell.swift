//
//  RangeCollectionViewCell.swift
//  innkeeper
//
//  Created by orca on 2020/07/23.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

protocol RangeCollectionViewCellDelegate {
    func collectionViewCell(category: MetadataCategory, selectedRange: String)
}

class RangeCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "RangeCollectionViewCell"
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var plus: UILabel!
    @IBOutlet weak var lowerField: UITextField!
    @IBOutlet weak var upperField: UITextField!
    
    var category: MetadataCategory = .NONE
    
    var lowerValue: Int = 0 {
        didSet {
            if lowerValue < 0 { lowerValue = 0}
            if lowerValue > HearthStoneData.shared.rangeMax { lowerValue = 10 }
            
            lowerField.text = "\(lowerValue)"
        }
    }
    
    var upperValue: Int = HearthStoneData.shared.rangeMax {
        didSet {
            if upperValue > HearthStoneData.shared.rangeMax { upperValue = 10 }

            upperField.text = "\(upperValue)"
            plus.isHidden = upperValue < 10
        }
    }
    
    var delegate: RangeCollectionViewCellDelegate! = nil
    var cellHeight: CGFloat = 50
    
    override func removeFromSuperview() {
    }
    
    func configure(category: MetadataCategory) {
        self.category = category
        title.text = category.localName
        lowerField.addTarget(self, action: #selector(lowerFieldChange(_:)), for: .editingChanged)
        lowerField.placeholder = "\(lowerValue)"
        upperField.addTarget(self, action: #selector(upperFieldChange(_:)), for: .editingChanged)
        upperField.addTarget(self, action: #selector(upperFieldEditEnd(_:)), for: .editingDidEnd)
        upperField.addTarget(self, action: #selector(upperFieldEditEndOnExit(_:)), for: .editingDidEndOnExit)
        upperField.placeholder = "\(upperValue)"
    }
    
    @objc func lowerFieldChange(_ field: UITextField) {
        
        guard let text = field.text else { return }
        if let value = NumberFormatter().number(from: text)?.intValue {
            lowerValue = value
        } else {
            lowerValue = 0
            lowerField.text = ""
        }
        
        SelectedDatas.shared.setRangeDatas(category: category, lowerValue: lowerValue, upperValue: upperValue)
    }
    
    @objc func upperFieldChange(_ field: UITextField) {
        
        guard let text = field.text else { return }
        if let value = NumberFormatter().number(from: text)?.intValue {
            upperValue = value
        } else {
            upperValue = HearthStoneData.shared.rangeMax
            upperField.text = ""
        }
    
        SelectedDatas.shared.setRangeDatas(category: category, lowerValue: lowerValue, upperValue: upperValue)
    }
    
    @objc func upperFieldEditEnd(_ field: UITextField) {
        print("upperFieldEditEnd")
    }
    
    @objc func upperFieldEditEndOnExit(_ field: UITextField) {
        print("upperFieldEditEndOnExit")
    }
}
