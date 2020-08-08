//
//  DecksCollectionViewCell.swift
//  innkeeper
//
//  Created by orca on 2020/08/07.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class DecksCollectionViewCell: UICollectionViewCell {
    static let identifier = "DecksCollectionViewCell"
    
    @IBOutlet weak var classImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    var deck = DeckData()
    
    func configure(deckData: DeckData) {
        deck = deckData
        classImg.image = UIImage(named: "icon-deck-\(deck.cls.rawValue)")
        name.text = deck.name
    }
}
