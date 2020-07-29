//
//  HowViewController.swift
//  innkeeper
//
//  Created by orca on 2020/07/06.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class HowViewController: UIViewController {
    
    @IBOutlet weak var menuView: MenuView!
    @IBOutlet weak var infoView: HSInfoView!
    @IBOutlet weak var prePlayView: PrePlayView!
    
    var verticalRate: CGFloat = 0
    var horizontalRate: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuView.menuViewDelegate = self
        self.menuView.setMenuItems(titles: ["게임 정보", "플레이 맛보기"])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = ""
    }
}

extension HowViewController: MenuViewDelegate {
    func onMenuSelected(selectedIndex: Int) {
        switch selectedIndex {
        case InnTags.TAG_MENU_VIEW_ITEM_INFO:
            self.infoView.isHidden = false
            self.prePlayView.isHidden = true
            
        case InnTags.TAG_MENU_VIEW_ITEM_PLAY:
            self.infoView.isHidden = true
            self.prePlayView.isHidden = false
            
        default: break
            
        }
    }
}
