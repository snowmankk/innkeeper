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
    var cls: Classes
    var flavorText: String
}

enum CardTypes: Int {
    case HERO = 3
    case MINION = 4
    case SPELL = 5
    case WEAPON = 7
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
