//
//  DecksViewController.swift
//  innkeeper
//
//  Created by orca on 2020/08/07.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class DecksViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    var decks: [DeckData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // test! (임시 데이터)
        decks.append(DeckData(name: "모자키 마법사", cls: .MAGE, cards: []))
        decks.append(DeckData(name: "야수 드루이드", cls: .DRUID, cards: []))
        decks.append(DeckData(name: "은신 갈라크론드 도적", cls: .ROGUE, cards: []))
        decks.append(DeckData(name: "멀록 성기사", cls: .PALADIN, cards: []))
        decks.append(DeckData(name: "부활 사제", cls: .PRIEST, cards: []))
        decks.append(DeckData(name: "토템 주술사", cls: .SHAMAN, cards: []))
        decks.append(DeckData(name: "폭탄 전사", cls: .WARRIOR, cards: []))
        decks.append(DeckData(name: "퀘스트 흑마법사", cls: .WARLOCK, cards: []))
        decks.append(DeckData(name: "용 사냥꾼", cls: .HUNTER, cards: []))
        decks.append(DeckData(name: "템포 악마사냥꾼", cls: .DEMONHUNTER, cards: []))
        
        
        
        table.delegate = self
        table.dataSource = self
    }
}

// MARK:- UITableViewDelegate
extension DecksViewController: UITableViewDelegate {
    
}

// MARK:- UITableViewDataSource
extension DecksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DecksTableViewCell.identifier, for: indexPath) as! DecksTableViewCell
        cell.configure(deckData: decks[indexPath.row])
        
        return cell
    }
}
