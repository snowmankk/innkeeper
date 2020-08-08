//
//  DecksViewController.swift
//  innkeeper
//
//  Created by orca on 2020/08/07.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class DecksViewController: UIViewController {

    @IBOutlet weak var collection: UICollectionView!
    
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
        
        
        
        collection.delegate = self
        collection.dataSource = self
    }
}

// MARK:- UICollectionViewDelegate
extension DecksViewController: UICollectionViewDelegate {
    
}

extension DecksViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return decks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DecksCollectionViewCell.identifier, for: indexPath) as! DecksCollectionViewCell
        cell.configure(deckData: decks[indexPath.row])
        
        return cell
    }
    
    
}
