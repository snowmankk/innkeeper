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
    
    var initialized: Bool = false
    
    override func didMoveToWindow() {
        initialize()
    }
    
    func initialize() {
        if initialized { return }
        
        table.delegate = self
        table.dataSource = self
        
        HearthStoneAPI.shared.delegates.append(self)
//        FirebaseRequest.shared.delegates.append(self)
        FirebaseRequest.shared.readMyDecks()
        initialized = true
    }
    
    func refresh() {
        table.reloadData()
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


/*
extension MyDecks: FirebaseRequestDelegate {
    func responseReadMyDecks(deckInfos: [String]) {
        for deckInfo in deckInfos {
            let arr = deckInfo.components(separatedBy: InnIdentifiers.SEPERATOR_DECK_STRING.rawValue)
            guard arr.count > 0 else { continue }
            HearthStoneAPI.shared.requestDeck(deckCode: arr[0], deckName: arr[1], addToMyDecks: true)
        }
    }
}
*/

extension MyDecks: HearthStoneAPIDelegate {
    func responseDeckData(deck: Any?) {
        if self.isHidden { return }
        /*
        guard let _deck = deck as? DeckData else { return }
        
        let _duplicateDeck = DeckDatas.shared.myDecks.filter { $0.code == _deck.code }
        if _duplicateDeck.count > 0 { return }
        
        print("\n My deck (name: \(_deck.name ?? "") / code: \(_deck.code ?? "")")
        DeckDatas.shared.myDecks.append(_deck)
 */
        table.reloadData()
    }
}

