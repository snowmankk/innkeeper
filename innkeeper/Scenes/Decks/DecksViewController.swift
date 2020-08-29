//
//  DecksViewController.swift
//  innkeeper
//
//  Created by orca on 2020/08/07.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class DecksViewController: UIViewController {

    @IBOutlet weak var menuView: MenuView!
    @IBOutlet weak var myDeck: MyDecks!
    @IBOutlet weak var searchDeck: SearchDecks!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuView.menuViewDelegate = self
        menuView.setMenuItems(titles: ["내 덱", "덱 검색"], views: [myDeck, searchDeck])
        HearthStoneAPI.shared.requestMetaDatas()
    }
}

extension DecksViewController: MenuViewDelegate {
    func onMenuSelected(selectedView: UIView) {
        if selectedView === myDeck {
            myDeck.refresh()
            searchDeck.hideKeyboard()
        }
    }
    
    
}

