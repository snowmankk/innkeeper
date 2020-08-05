//
//  CardDetailViewController.swift
//  innkeeper
//
//  Created by orca on 2020/08/05.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class CardDetailViewController: UIViewController {

    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var classImg: UIImageView!
    @IBOutlet weak var multiClassImg0: UIImageView!
    @IBOutlet weak var multiClassImg1: UIImageView!
    @IBOutlet weak var cardImg: UIImageView!
    @IBOutlet weak var flavorText: UILabel!
    @IBOutlet weak var classText: UILabel!
    @IBOutlet weak var typeText: UILabel!
    @IBOutlet weak var rarityText: UILabel!
    @IBOutlet weak var manaText: UILabel!
    @IBOutlet weak var setText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = SelectedDatas.shared.card
        
        let pallete = InnPalette(rawValue: data.classIds[0].rawValue)
        guard let color = pallete?.color else { return }
        
        let startColor = color.withAlphaComponent(0.7)
        let color1 = color.withAlphaComponent(0.4)
        let endColor = color.withAlphaComponent(0.1)
        gradientView.setGradient(colors: [startColor.cgColor, color1.cgColor, endColor.cgColor])
        
        if data.classIds.count > 1 {
            multiClassImg0.isHidden = false
            multiClassImg0.isHidden = false
            classImg.isHidden = true
            
            multiClassImg0.image = UIImage(named: "icon-class-\(data.classIds[0].rawValue)")
            multiClassImg1.image = UIImage(named: "icon-class-\(data.classIds[1].rawValue)")
            
            let multiClassText = "\(MetadataCategory.CLASSES.localName): \(data.classIds[0].name), \(data.classIds[1].name)"
            classText.text = multiClassText
        } else {
            multiClassImg0.isHidden = true
            multiClassImg1.isHidden = true
            classImg.isHidden = false
            
            classImg.image = UIImage(named: "icon-class-\(data.classIds[0].rawValue)")
            classText.text = "\(MetadataCategory.CLASSES.localName): \(data.classIds[0].name)"
        }
        
        flavorText.text = data.flavorText
        typeText.text = "\(MetadataCategory.TYPES.localName): \(data.type.name)"
        rarityText.text = "\(MetadataCategory.RARITY.localName): \(data.getRarityName())"
        setText.text = "\(MetadataCategory.SETS.localName): \(data.getSetName())"
        manaText.text = "\(MetadataCategory.COST.localName): \(data.mana)"
        
        DispatchQueue.main.async {
            self.setCardImage(imgUrl: data.imgUrl)
        }
    }
    
    func setCardImage(imgUrl: String) {
        let url: URL! = URL(string: imgUrl)
        guard let data = try? Data(contentsOf: url) else { return }
        
        let img = UIImage(data: data)
        cardImg.image = img
    }

}
