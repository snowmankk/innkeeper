//
//  Pallete.swift
//  innkeeper
//
//  Created by orca on 2020/07/02.
//  Copyright © 2020 example. All rights reserved.
//

import Foundation
import UIKit

enum InnPalette: Int  {
    case SYMBOL_DRUID = 2
    case SYMBOL_HUNTER = 3
    case SYMBOL_MAGE = 4
    case SYMBOL_PALADIN = 5
    case SYMBOL_PRIEST = 6
    case SYMBOL_ROGUE = 7
    case SYMBOL_SHAMAN = 8
    case SYMBOL_WORLOCK = 9
    case SYMBOL_WARRIOR = 10
    case SYMBOL_NEUTRAL = 12
    case SYMBOL_DEMONHUNTER = 14
    
    
    var color: UIColor {
        get {
            var c = UIColor.white
            switch self {
            case .SYMBOL_DRUID:         c = UIColor(red: 78/255, green: 52/255, blue: 29/255, alpha: 1)
            case .SYMBOL_HUNTER:        c = UIColor(red: 26/255, green: 75/255, blue: 20/255, alpha: 1)
            case .SYMBOL_MAGE:          c = UIColor(red: 43/255, green: 88/255, blue: 143/255, alpha: 1)
            case .SYMBOL_PALADIN:       c = UIColor(red: 145/255, green: 96/255, blue: 36/255, alpha: 1)
            case .SYMBOL_PRIEST:        c = UIColor(red: 130/255, green: 117/255, blue: 109/255, alpha: 1)
            case .SYMBOL_ROGUE:         c = UIColor(red: 26/255, green: 27/255, blue: 20/255, alpha: 1)
            case .SYMBOL_SHAMAN:        c = UIColor(red: 45/255, green: 48/255, blue: 121/255, alpha: 1)
            case .SYMBOL_WORLOCK:       c = UIColor(red: 64/255, green: 32/255, blue: 97/255, alpha: 1)
            case .SYMBOL_WARRIOR:       c = UIColor(red: 96/255, green: 15/255, blue: 22/255, alpha: 1)
            case .SYMBOL_DEMONHUNTER:   c = UIColor(red: 19/255, green: 51/255, blue: 45/255, alpha: 1)
            case .SYMBOL_NEUTRAL:       c = UIColor(red: 154/255, green: 100/255, blue: 100/255, alpha: 1)
            }
            
            return c
        }
    }
}
