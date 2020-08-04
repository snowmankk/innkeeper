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
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var flavorText: UILabel!
    
    var cardImg: UIImage! = nil
    
    func configure(data: CardData) {
        let pallete = InnPalette(rawValue: data.cls.rawValue)
        guard let color = pallete?.color else { return }
        
        let startColor = color.withAlphaComponent(0.7)
        let color1 = color.withAlphaComponent(0.4)
        let endColor = color.withAlphaComponent(0.1)
        gradientView.setGradient(colors: [startColor.cgColor, color1.cgColor, endColor.cgColor])
        flavorText.text = data.flavorText
        
        cls.image = UIImage(named: "icon-class-\(data.cls.rawValue)")
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

    func testConfigure() {
//        gradientView.setGradient(palette: InnPalette.gradientColor004)
    }
}
