//
//  HearthStoneData.swift
//  innkeeper
//
//  Created by orca on 2020/07/17.
//  Copyright © 2020 example. All rights reserved.
//

import Foundation

class HearthStoneData {
    
    static let shared: HearthStoneData = HearthStoneData()
    
    let rangeMin: Int = 0
    let rangeMax: Int = 10
    
    var classes     : [MetaDataBase] = []
    var types       : [MetaDataBase] = []
    var rarity      : [MetaDataBase] = []
    var sets        : [MetaDataBase] = []
    var wildSets    : [MetaDataBase] = []
    var minionTypes : [MetaDataBase] = []
    var options     : [MetaDataBase] = []
    var standards   : [String] = []
    var wilds       : [String] = []
    
    var cards : [CardData] = []
    
    private init() {}
    
    func getDatas(category: MetadataCategory) -> [MetaDataBase] {
        var datas: [MetaDataBase] = []
        switch category {
        case .CLASSES       : datas = self.classes
        case .TYPES         : datas = self.types
        case .RARITY        : datas = self.rarity
        case .SETS          : datas = self.sets
        case .MINION_TYPES  : datas = self.minionTypes
        case .OPTIONS       : datas = self.options
        case .WILD_SETS     : datas = self.wildSets
        case .COST, .ATTACK, .HP :
            
            for i in 0 ... 10 {
                var content: String = "\(i)"
                if 10 == i { content.append("+") }
                datas.append(MetaDataBase(id: i, slug: content, name: content))
            }
            
        default: break
        }
        
        return datas
    }
    
    func getSlug(category: MetadataCategory, keyword: String) -> String {
        var slug = ""
        var datas: [MetaDataBase] = []
        switch category {
        case .CLASSES       : datas = self.classes
        case .TYPES         : datas = self.types
        case .RARITY        : datas = self.rarity
        case .SETS          : datas = self.sets
        case .MINION_TYPES  : datas = self.minionTypes
        case .OPTIONS       : datas = self.options
        case .WILD_SETS     : datas = self.wildSets
        default             : break
        }
        
        slug = datas.filter({ $0.name == keyword }).first?.slug ?? ""
        return slug
    }
    
    func getSlug(category: MetadataCategory, id: Int) -> String {
        var slug = ""
        var datas: [MetaDataBase] = []
        switch category {
        case .CLASSES       : datas = self.classes
        case .TYPES         : datas = self.types
        case .RARITY        : datas = self.rarity
        case .SETS          : datas = self.sets
        case .MINION_TYPES  : datas = self.minionTypes
        case .OPTIONS       : datas = self.options
        case .WILD_SETS     : datas = self.wildSets
        default             : break
        }
        
        slug = datas.filter({ $0.id == id }).first?.slug ?? ""
        return slug
    }
}

struct HearthStoneAuth: Decodable {
    var accessToken: String
    var tokenType: String
    var expires: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expires = "expires_in"
    }
}

struct MetaDataBase: Decodable {
    var id: Int
    var slug: String
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case slug = "slug"
        case name = "name"
    }
}

enum MetadataCategory: String {
    case CLASSES = "classes"
    case TYPES = "types"
    case RARITY = "rarities"
    case SETS = "sets"
    case MINION_TYPES = "minionTypes"
    case OPTIONS = "keywords"
    case COST = "cost"
    case ATTACK = "attack"
    case HP = "hp"
    case WILD_SETS = "wilds"
    case GROUPS = "setGroups"
    case NONE = "none"
    
    var localName: String {
        get {
            var name: String = ""
            switch self {
            case .CLASSES       : name = "직업"
            case .TYPES         : name = "타입"
            case .RARITY        : name = "등급"
            case .SETS          : name = "확장팩(정규)"
            case .MINION_TYPES  : name = "종족"
            case .OPTIONS       : name = "옵션"
            case .COST          : name = "마나"
            case .ATTACK        : name = "공격"
            case .HP            : name = "생명"
            case .WILD_SETS     : name = "확장팩(야생)"
            default             : name = ".."
            }
            
            return name
        }
    }
    
    static func numberToCategory(num: Int) -> MetadataCategory {
        switch num {
        case 0: return .COST
        case 1: return .ATTACK
        case 2: return .HP
        case 3: return .CLASSES
        case 4: return .TYPES
        case 5: return .RARITY
        case 6: return .SETS
        case 7: return .WILD_SETS
        case 8: return .MINION_TYPES
        case 9: return .OPTIONS
        case 10: return .GROUPS
        
        default: return .NONE
        }
    }
}

struct SetGroupData: Decodable {
    var name = ""
    var slug = ""
    var cardSets: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case slug = "slug"
        case cardSets = "cardSets"
    }
}

