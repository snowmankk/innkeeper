//
//  CardData.swift
//  innkeeper
//
//  Created by orca on 2020/07/19.
//  Copyright © 2020 example. All rights reserved.
//

import Foundation

struct CardData {
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
    
    func getRarityName() -> String {
        let data = HearthStoneData.shared.rarity.filter { $0.id == rarity }
        return data.first?.name ?? ""
    }
    
    func getSetName() -> String {
        let data = HearthStoneData.shared.sets.filter { $0.id == set }
        return data.first?.name ?? ""
    }
}

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
    case WORLOCK = 9
    case WARRIOR = 10
    case NEUTRAL = 12
    case DEMONHUNTER = 14
    
    var name: String {
        get {
            /*
            var nameStr = ""
            switch self {
            case .DRUID: nameStr = "드루이드"
            case .HUNTER: nameStr = "사냥꾼"
            case .MAGE: nameStr = "마법사"
            case .PALADIN: nameStr = "팔라딘"
            case .PRIEST: nameStr = "사제"
            case .ROGUE: nameStr = "도적"
            case .SHAMAN: nameStr = "주술사"
            case .WORLOCK: nameStr = "흑마법사"
            case .WARRIOR: nameStr = "전사"
            case .NEUTRAL: nameStr = "중립"
            case .DEMONHUNTER: nameStr = "악마 사냥꾼"
            }
            */
            
            let classes = HearthStoneData.shared.classes.filter { $0.id == self.rawValue }
            return classes.first?.name ?? ""
        }
    }
}

/*
 
 {
   "slug": "demonhunter",
   "id": 14,
   "name": "Demon Hunter",
   "cardId": 56550
 },
 {
   "slug": "druid",
   "id": 2,
   "name": "Druid",
   "cardId": 274
 },
 {
   "slug": "hunter",
   "id": 3,
   "name": "Hunter",
   "cardId": 31
 },
 {
   "slug": "mage",
   "id": 4,
   "name": "Mage",
   "cardId": 637
 },
 {
   "slug": "paladin",
   "id": 5,
   "name": "Paladin",
   "cardId": 671
 },
 {
   "slug": "priest",
   "id": 6,
   "name": "Priest",
   "cardId": 813
 },
 {
   "slug": "rogue",
   "id": 7,
   "name": "Rogue",
   "cardId": 930
 },
 {
   "slug": "shaman",
   "id": 8,
   "name": "Shaman",
   "cardId": 1066
 },
 {
   "slug": "warlock",
   "id": 9,
   "name": "Warlock",
   "cardId": 893
 },
 {
   "slug": "warrior",
   "id": 10,
   "name": "Warrior",
   "cardId": 7
 },
 {
   "slug": "neutral",
   "id": 12,
   "name": "Neutral"
 }
 */
