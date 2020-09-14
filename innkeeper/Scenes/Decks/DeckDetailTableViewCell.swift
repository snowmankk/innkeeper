//
//  DeckDetailTableViewCell.swift
//  innkeeper
//
//  Created by orca on 2020/08/12.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class DeckDetailTableViewCell: UITableViewCell {

    static let identifier = "DeckDetailTableViewCell"
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var manaCost: UILabel!
    @IBOutlet weak var cardCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(name: String, imgUrl: String, manaCost: Int, cardCount: Int) {
        self.name.text = name
        self.manaCost.text = "\(manaCost)"
        self.cardCount.text = "x\(cardCount)"
        
        DispatchQueue.global().async {
            let url: URL! = URL(string: imgUrl)
            guard let data = try? Data(contentsOf: url) else { return }

            DispatchQueue.main.async {
                var img = UIImage(data: data)//?.cropped(boundingBox: CGRect(x: 30, y: 5, width: 80, height: 40))
                guard let imgHeight = img?.size.height else { return }
                img = img?.cropped(boundingBox: CGRect(x: 55, y: 5, width: 130, height: imgHeight - 10))
                self.img.image = img
            }
        }
        
        let indicatorImg = UIImage(named: "icon-indicator")?.withTintColor(self.name.textColor)
        self.accessoryView = UIImageView(image: indicatorImg)
        
        let selectedBg = UIView()
        selectedBg.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        self.selectedBackgroundView = selectedBg
    }
    
}
