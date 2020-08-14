//
//  DeckData.swift
//  innkeeper
//
//  Created by orca on 2020/08/07.
//  Copyright © 2020 example. All rights reserved.
//

import Foundation

struct DeckData {
    var name: String = ""
    var code: String = ""
    var cls: Classes = .NEUTRAL
    var cards: [CardData] = []
    var thumbnails: [String] = []         // 카드 썸네일 이미지의 base64 string
}

class DeckDatas {
    static let shared = DeckDatas()
    
    var searchedDeck: DeckData?
    var myDecks: [DeckData] = []
    
    private init() {}
}
