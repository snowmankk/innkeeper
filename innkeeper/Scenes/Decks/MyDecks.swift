//
//  MyDecks.swift
//  innkeeper
//
//  Created by orca on 2020/08/09.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class MyDecks: UIView {

    @IBOutlet weak var parent: DecksViewController!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var menuView: MenuView!
    
    override func didMoveToWindow() {
        
        table.delegate = self
        table.dataSource = self
        menuView.menuViewDelegate = self
    }
}

// MARK:- UITableViewDelegate
extension MyDecks: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DeckDatas.shared.searchedDeck = DeckDatas.shared.myDecks[indexPath.row]
        parent.performSegue(withIdentifier: InnIdentifiers.SEGUE_DECK_DETAIL.rawValue, sender: self)
    }
}

// MARK:- UITableViewDataSource
extension MyDecks: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DeckDatas.shared.myDecks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DecksTableViewCell.identifier, for: indexPath) as! DecksTableViewCell
        cell.configure(deckData: DeckDatas.shared.myDecks[indexPath.row])
        
        return cell
    }
}

extension MyDecks: MenuViewDelegate {
    func onMenuSelected(selectedView: UIView) {
        if selectedView !== self { return }
        table.reloadData()
    }
}

