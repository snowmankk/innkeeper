//
//  CardsCollectionViewCell.swift
//  innkeeper
//
//  Created by orca on 2020/07/30.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class CardsCollectionViewCell: UICollectionViewCell {
     
    static let identifier: String = "CardsCollectionViewCell"
    
    @IBOutlet weak var card: UIImageView!
    @IBOutlet weak var hpImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var mana: UILabel!
    @IBOutlet weak var attack: UILabel!
    @IBOutlet weak var hp: UILabel!
    
    var cardImg: UIImage! = nil
    
    func configure(data: CardData) {
        
        name.text = data.name
        mana.text = String(data.mana)
        
        switch data.type {
        case .HERO:
            attack.text = "-"
            
            if data.mana > 0 { mana.text = String(data.mana) }
            
            if data.armor > 0 {
                hp.text = String(data.armor)
                hpImg.image = UIImage(named: "icon-shield")
            } else {
                hp.text = String(data.hp)
            }
            
        case .MINION:
            attack.text = String(data.attack)
            hp.text = String(data.hp)
        
        case .SPELL:
            attack.text = "-"
            hp.text = "-"
            
        case .WEAPON:
            attack.text = String(data.attack)
            hp.text = String(data.durability)
            hpImg.image = UIImage(named: "icon-shield")
        }
        
        
        DispatchQueue.main.async {
            self.setCardImage(imgUrl: data.imgUrl)
        }
    }
    
    func setCardImage(imgUrl: String) {
        
        guard nil == cardImg else { return }
        
        let url: URL! = URL(string: imgUrl)
        let data = try! Data(contentsOf: url)
        cardImg = UIImage(data: data)
        card.image = cardImg
    }
    
    func configureTest() {
//        var cellWidth: CGFloat = 0
//        var spaceCount: CGFloat = 0
//        var columnCount: CGFloat = 0
//        let screenWidth = UIScreen.main.bounds.width
//        let cellSpace:CGFloat = 10
//
//        // screenWidth가 640보다 작으면 column이 screenWidh의 2등분, 640 이상이면 3등분 되도록 cell width를 설정한다
//        if screenWidth < 640 {
//            columnCount = 2
//            spaceCount = columnCount + 1
//        } else {
//            columnCount = 3
//            spaceCount = columnCount + 1
//        }
//
//        cellWidth = screenWidth / columnCount - (cellSpace * spaceCount / columnCount)
//
//        card.frame = CGRect(x: 0, y: 0, width: cellWidth, height: cellWidth * 1.9)
//        card.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width * 1.3)

    }
}
