//
//  DecksTableViewCell.swift
//  innkeeper
//
//  Created by orca on 2020/08/09.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class DecksTableViewCell: UITableViewCell {

    static let identifier = "DecksTableViewCell"
    
    @IBOutlet weak var classImg: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    var deck = DeckData()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(deckData: DeckData) {
        deck = deckData
        
        let imageWidth: CGFloat = 40
        let imageFrame = CGRect(x: 0, y: 0, width: imageWidth, height: imageWidth)
        classImg.image = getImage(imageName: "icon-class-\(deck.cls?.rawValue ?? 0)", frame: imageFrame)
        name.text = deck.name
        
        let indicatorImg = UIImage(named: "icon-indicator")?.withTintColor(name.textColor)
        self.accessoryView = UIImageView(image: indicatorImg)
        
        let selectedBg = UIView()
        selectedBg.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        self.selectedBackgroundView = selectedBg
    }
    
    func getImage(imageName: String, frame: CGRect) -> UIImage? {
        guard let image = UIImage(named: imageName) else { return nil }
        
        UIGraphicsBeginImageContext(frame.size)
        image.draw(in: CGRect(x: frame.origin.x,y: frame.origin.x,width: frame.width, height: frame.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!.withRenderingMode(.automatic)
    }

}
