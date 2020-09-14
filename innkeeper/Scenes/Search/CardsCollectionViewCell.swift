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
    @IBOutlet weak var cls: UIImageView!
    @IBOutlet weak var multiClass0: UIImageView!
    @IBOutlet weak var multiClass1: UIImageView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var flavorText: UILabel!
    
    var name: String = ""
    
    func configure(index: Int) {
        let data = HearthStoneData.shared.cards[index]
        name = data.name ?? ""
        
        let pallete = InnPalette(rawValue: data.classIds[0].rawValue)
        guard let color = pallete?.color else { return }
        
        let startColor = color.withAlphaComponent(0.7)
        let color1 = color.withAlphaComponent(0.4)
        let endColor = color.withAlphaComponent(0.1)
        gradientView.setGradient(colors: [startColor.cgColor, color1.cgColor, endColor.cgColor])
        flavorText.text = data.flavorText
        
        if data.classIds.count > 1 {
            multiClass0.isHidden = false
            multiClass1.isHidden = false
            cls.isHidden = true
            
            multiClass0.image = UIImage(named: "icon-class-\(data.classIds[0].rawValue)")
            multiClass1.image = UIImage(named: "icon-class-\(data.classIds[1].rawValue)")
        } else {
            multiClass0.isHidden = true
            multiClass1.isHidden = true
            cls.isHidden = false
            
            cls.image = UIImage(named: "icon-class-\(data.classIds[0].rawValue)")
        }

        self.setCardImage(index: index, imgUrl: data.imgUrl ?? "")
    }
    
    func setCardImage(index: Int, imgUrl: String) {
        
        if let imageCache = HearthStoneData.shared.cards[index].imageCache {
            card.image = UIImage(data: imageCache)
            return
        }
        
        DispatchQueue.global().async {
            let url: URL! = URL(string: imgUrl)
            guard let data = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async(execute: {
                let cardImg = UIImage(data: data)
                self.card.image = cardImg
                HearthStoneData.shared.cards[index].imageCache = cardImg?.pngData()
            })
        }
    }
}
