//
//  KeywordsCollectionViewCell.swift
//  innkeeper
//
//  Created by orca on 2020/07/19.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit


class KeywordsCollectionViewCell: UICollectionViewCell {
    static let identifier = "KeywordsCollectionViewCell"
    
    let btnHorizontalSpaing: CGFloat = 8
    let btnVerticalSpacing: CGFloat = 8
    let btnExtraBorderWidth: CGFloat = 16
    let btnTrailBound: CGFloat = UIScreen.main.bounds.size.width - 15
    let btnCornerRadius: CGFloat = 8
    
    @IBOutlet weak var title: UILabel!
    var draggedBtn: UIButton!
    var cellHeight: CGFloat = 80
    var category: MetadataCategory = .NONE
    
    
    func configure(category: MetadataCategory) {
        self.category = category
        self.title.text = category.localName
        self.setButtons()
    }
    
    // 스크린 바깥으로 나가지 않도록 좌상단 -> 우하단 방향으로 버튼들을 생성하고
    // 버튼들을 모두 포함하는 셀의 높이를 설정한다
    func setButtons() {
        let datas = HearthStoneData.shared.getDatas(category: category)
        
        let startPos = CGPoint(x: 10, y: 36)
        var pos = startPos
        for data in datas {
            
            let button = UIButton(type: .roundedRect)
            button.setTitle(data.name, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemGray2
            button.layer.cornerRadius = btnCornerRadius
            button.sizeToFit()
            button.addTarget(self, action: #selector(onSelected), for: .touchUpInside)
            
            let buttonWidth = button.frame.width + btnExtraBorderWidth
            let buttonHeight = button.frame.height
            let endX = pos.x + buttonWidth + btnHorizontalSpaing
            if endX >= btnTrailBound {
                pos.x = startPos.x
                pos.y = pos.y + buttonHeight + btnVerticalSpacing
                
                cellHeight = pos.y + buttonHeight + btnVerticalSpacing
            }
            
            button.frame = CGRect(x: pos.x, y: pos.y, width: buttonWidth, height: button.frame.height)
            pos.x = pos.x + buttonWidth + btnHorizontalSpaing
            
            let selectedDatas = SelectedDatas.shared.getData(category: category)
            if selectedDatas.contains(data.name) {
                onSelected(button)
            }
            
            self.addSubview(button)
        }
    }
    
    @objc func onSelected(_ sender: UIButton) {
        if category == .OPTIONS { offAllButton() }
        setButtonSelect(button: sender)
        //delegate.collectionViewCell(selected: selectedKeyword, add: add)
    }
    
    func setButtonSelect(button: UIButton) {
        guard let selectedKeyword = button.currentTitle else { return }
        
        var add: Bool = true
        if button.backgroundColor == .orange {
            button.backgroundColor = .systemGray2
            add = false
        } else {
            button.backgroundColor = .orange
        }
        
        SelectedDatas.shared.setKeywordDatas(category: category, keyword: selectedKeyword, add: add)
    }
    
    func offAllButton() {
        for subView in self.subviews {
            guard let button = subView as? UIButton else { continue }
            guard button.backgroundColor == .orange else { continue }
            
            setButtonSelect(button: button)
        }
    }
    
}
