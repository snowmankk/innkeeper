//
//  CardData.swift
//  innkeeper
//
//  Created by orca on 2020/07/19.
//  Copyright © 2020 example. All rights reserved.
//

import Foundation

struct CardResponse: Decodable {
    var cards: [CardData]?
    var cardCount: Int?
    var pageCount: Int?
    var page: Int?
    
    enum CodingKeys: String, CodingKey {
        case cards = "cards"
        case cardCount = "cardCount"
        case pageCount = "pageCount"
        case page = "page"
    }
}

struct CardData: Decodable, Hashable {
    var name: String?
    var type: CardTypes?
    var mana: Int?
    var attack: Int?
    var hp: Int?
    var durability: Int?
    var armor: Int?
    var imgUrl: String?
    var flavorText: String?
    var rarity: Int?
    var set: Int?
    var cropImgUrl: String?
    var multiClassIds: [Int]?
    var classId: Int?
    var classIds: [Classes] = []
    var imageCache: Data?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case type = "cardTypeId"
        case mana = "manaCost"
        case attack = "attack"
        case hp = "health"
        case durability = "durability"
        case armor = "armor"
        case imgUrl = "image"
//        case classIds = "classId"
        case flavorText = "flavorText"
        case rarity = "rarityId"
        case set = "cardSetId"
        case cropImgUrl = "cropImage"
        case multiClassIds = "multiClassIds"
        case classId = "classId"
    }
    
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decodeIfPresent(String.self, forKey: .name)
            mana = try container.decodeIfPresent(Int.self, forKey: .mana)
            attack = try container.decodeIfPresent(Int.self, forKey: .attack)
            hp = try container.decodeIfPresent(Int.self, forKey: .hp)
            durability = try container.decodeIfPresent(Int.self, forKey: .durability)
            armor = try container.decodeIfPresent(Int.self, forKey: .armor)
            imgUrl = try container.decodeIfPresent(String.self, forKey: .imgUrl)
            flavorText = try container.decodeIfPresent(String.self, forKey: .flavorText)
            rarity = try container.decodeIfPresent(Int.self, forKey: .rarity)
            set = try container.decodeIfPresent(Int.self, forKey: .set)
            cropImgUrl = try container.decodeIfPresent(String.self, forKey: .cropImgUrl)
            multiClassIds = try container.decodeIfPresent([Int].self, forKey: .multiClassIds)
            classId = try container.decodeIfPresent(Int.self, forKey: .classId)
            
            if let multiClassIds = multiClassIds, multiClassIds.count > 0 {
                for classId in multiClassIds {
                    classIds.append(Classes(rawValue: classId) ?? Classes.NEUTRAL)
                }
            } else {
                let classId = self.classId ?? 0
                classIds.append(Classes(rawValue: classId) ?? Classes.NEUTRAL)
            }
            
            if let type = try container.decodeIfPresent(Int.self, forKey: .type) {
                self.type = CardTypes(rawValue: type)
            }
            
        } catch {
            print("\nCardData2 init error: \(error)")
        }
    }
    
    init() {
        name = ""
        type = CardTypes.MINION
        mana = 0
        attack = 0
        hp = 0
        durability = 0
        armor = 0
        imgUrl = ""
        classIds = []
        flavorText = ""
        rarity = 0
        set = 0
        cropImgUrl = ""
    }
    
    func getRarityName() -> String {
        let data = HearthStoneData.shared.rarity.filter { $0.id == rarity }
        return data.first?.name ?? ""
    }
    
    func getSetName() -> String {
        let data = HearthStoneData.shared.sets.filter { $0.id == set }
        return data.first?.name ?? ""
    }
}

/*
struct CardData: Hashable {
    var name: String = ""
    var type: CardTypes = .MINION
    var mana: Int = 0
    var attack: Int = 0
    var hp: Int = 0
    var durability: Int = 0
    var armor: Int = 0
    var imgUrl: String = ""
    var classIds: [Classes] = []
    var flavorText: String = ""
    var rarity: Int = 0
    var set: Int = 0
    var cropImgUrl: String = ""
    
    func getRarityName() -> String {
        let data = HearthStoneData.shared.rarity.filter { $0.id == rarity }
        return data.first?.name ?? ""
    }
    
    func getSetName() -> String {
        let data = HearthStoneData.shared.sets.filter { $0.id == set }
        return data.first?.name ?? ""
    }
}
 */

enum CardTypes: Int {
    case HERO = 3
    case MINION = 4
    case SPELL = 5
    case WEAPON = 7
    
    var name: String {
        get {
            let types = HearthStoneData.shared.types.filter { $0.id == self.rawValue }
            return types.first?.name ?? ""
        }
    }
}

enum Classes: Int {
    case DRUID = 2
    case HUNTER = 3
    case MAGE = 4
    case PALADIN = 5
    case PRIEST = 6
    case ROGUE = 7
    case SHAMAN = 8
    case WARLOCK = 9
    case WARRIOR = 10
    case NEUTRAL = 12
    case DEMONHUNTER = 14
    
    var name: String {
        get {
            let classes = HearthStoneData.shared.classes.filter { $0.id == self.rawValue }
            return classes.first?.name ?? ""
        }
    }
}
