//
//  CardData.swift
//  innkeeper
//
//  Created by orca on 2020/07/19.
//  Copyright © 2020 example. All rights reserved.
//

import Foundation

struct CardData {
    var name: String
    var type: CardTypes
    var mana: Int
    var attack: Int
    var hp: Int
    var durability: Int
    var armor: Int
    var imgUrl: String
    var cls: String
    var flavorText: String
}

enum CardTypes: Int {
    case HERO = 3
    case MINION = 4
    case SPELL = 5
    case WEAPON = 7
}
