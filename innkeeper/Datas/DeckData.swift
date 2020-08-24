//
//  DeckData.swift
//  innkeeper
//
//  Created by orca on 2020/08/07.
//  Copyright © 2020 example. All rights reserved.
//

import Foundation

struct DeckData: Decodable {
    /*
    var name: String = ""
    var code: String = ""
    var cls: Classes = .NEUTRAL
    var cards: [CardData] = []
    //var thumbnails: [String] = []         // 카드 썸네일 이미지의 base64 string
    */
    
    struct ClassData: Decodable {
        var id: Int?
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
        }
    }
 
    var name: String?
    var code: String?
    var cls: Classes?
    var cards: [CardData]?
    //var thumbnails: [String] = []         // 카드 썸네일 이미지의 base6
    
    enum CodingKeys: String, CodingKey {
        case code = "deckCode"
        case cards = "cards"
        case cls = "class"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decodeIfPresent(String.self, forKey: .code)
        
        if let classData = try container.decodeIfPresent(ClassData.self, forKey: .cls) {
            cls = Classes(rawValue: classData.id ?? 0)
        }
        
        cards = try container.decodeIfPresent([CardData].self, forKey: .cards)
    }
    
    init() {
        name = ""
        code = ""
        cls = .NEUTRAL
        cards = [CardData]()
    }
}

class DeckDatas {
    static let shared = DeckDatas()
    
    var searchedDeck: DeckData?
    var myDecks: [DeckData] = []
    
    private init() {}
}


