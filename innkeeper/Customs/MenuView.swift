//
//  MenuView.swift
//  innkeeper
//
//  Created by orca on 2020/07/06.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

protocol MenuViewDelegate {
    func onMenuSelected(selectedView: UIView)
}

class MenuView: UIView {

    class MenuItem {
        var title: UILabel
        var selectedBar: UIView
        var selectedView: UIView
        var tag: Int = 0
        
        init(title: UILabel, selectedBar: UIView, selectedView: UIView, tag: Int) {
            self.title = title
            self.selectedBar = selectedBar
            self.selectedView = selectedView
            self.tag = tag
        }
    }
    
    var menuItems: [MenuItem] = []
    var selectedTag = 0//InnTags.MENU_VIEW_ITEM_INFO.rawValue
    var menuViewDelegate: MenuViewDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // 타이틀의 개수 만큼 메뉴 아이템 생성
    func setMenuItems(titles: [String], views: [UIView]) {
        
        if titles.count != views.count {
            print("Each count does not match..")
            return
        }
        
        let screenWidth = UIScreen.main.bounds.width
        let itemCount = titles.count
        let itemWidth = screenWidth / CGFloat(itemCount)
        let itemHeightHalf = self.frame.height / 2
        
        // 하단 구분선 추가
        let bottomLineView: UIView = UIView(frame: CGRect(x: 0, y: self.frame.height - 1, width: screenWidth, height: 1))
        bottomLineView.backgroundColor = .white
        bottomLineView.alpha = 0.5
        self.addSubview(bottomLineView)
        
        let labelHeight: CGFloat = 32
        
        let selectedViewHeight: CGFloat = 3
        let selectedViewPosY = self.frame.height - selectedViewHeight
        
        var tag = 0//InnTags.MENU_VIEW_ITEM_INFO.rawValue
        var itemPosX: CGFloat = 0
        for title in titles {
            // ──────────── 각 아이템에 해당하는 view를 생성하고 width/tag/gesture ──────────── //
            let itemView: UIView = UIView(frame: CGRect(x: itemPosX, y: 0, width: itemWidth, height: self.frame.height))
            itemView.tag = tag
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tappedItem(_:)))
            itemView.addGestureRecognizer(gesture)
            // ──────────────────────────────────────────────────────────────────────── //
            
            // ──────────────── 아이템안의 label과 선택됐음을 표시하는 view 생성 ──────────────── //
            let labelPosY = itemHeightHalf - (labelHeight / 2)
            let labelTitle: UILabel = UILabel(frame: CGRect(x: 0, y: labelPosY, width: itemWidth, height: labelHeight))
            labelTitle.text = title
            labelTitle.textColor = .white
            labelTitle.textAlignment = .center
        
            let selectedBar: UIView = UIView(frame: CGRect(x: 0, y: selectedViewPosY, width: itemWidth, height: selectedViewHeight))
            selectedBar.backgroundColor = .white
            selectedBar.alpha = 0.7
            
            itemView.addSubview(labelTitle)
            itemView.addSubview(selectedBar)
            // ──────────────────────────────────────────────────────────────────────── //
            
            self.addSubview(itemView)
            
            let menuItem: MenuItem = MenuItem(title: labelTitle, selectedBar: selectedBar, selectedView: views[tag], tag: tag)
            menuItems.append(menuItem)
            
            itemPosX += itemWidth
            tag += 1
        }
        
        self.setSelected()
    }
    
    @objc func tappedItem(_ sender: UIGestureRecognizer) {
        guard let selectedView = sender.view else { return }
        
        selectedTag = selectedView.tag
//        print("selected tag : \(selectedTag)")
        
        setSelected()
    }
    
    func setSelected()
    {
        for item in menuItems {
            if item.tag == selectedTag {
                item.selectedBar.alpha = 0.7
                item.selectedView.isHidden = false                
                menuViewDelegate?.onMenuSelected(selectedView: item.selectedView)
            }
            else {
                item.selectedBar.alpha = 0.0
                item.selectedView.isHidden = true
            }
        }
    }

}
