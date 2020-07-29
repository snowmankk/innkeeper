//
//  GradientView.swift
//  meme-moa
//
//  Created by orca on 2020/06/22.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setGradient(palette: InnPalette.gradientColor001)
    }
    
    func setGradient(palette: InnPalette)
    {
        let startPoint = CGPoint(x: 0.0, y: 0.0)
        let endPoint = CGPoint(x: 0.0, y: 1.0)
        
        switch palette {
        case .gradientColor001:
            let startColor = UIColor(red: 133/255, green: 147/255, blue: 152/255, alpha: 1)
            let endColor = UIColor(red: 40/255, green: 48/255, blue: 72/255, alpha: 1)
            
            self.setGradient(colors: [startColor.cgColor, endColor.cgColor], startPoint: startPoint, endPoint: endPoint)
            
        case .gradientColor002:
            let startColor = UIColor(red: 15/255, green: 32/255, blue: 39/255, alpha: 1)
            let color1 = UIColor(red: 32/255, green: 58/255, blue: 67/255, alpha: 1)
            let endColor = UIColor(red: 44/255, green: 83/255, blue: 100/255, alpha: 1)
            
            self.setGradient(colors: [startColor.cgColor, color1.cgColor, endColor.cgColor], startPoint: startPoint, endPoint: endPoint)
            
        case .gradientColor003:
            let startColor = UIColor(red: 96/255, green: 108/255, blue: 136/255, alpha: 1)
            let endColor = UIColor(red: 63/255, green: 76/255, blue: 107/255, alpha: 1)
            
            self.setGradient(colors: [startColor.cgColor, endColor.cgColor], startPoint: startPoint, endPoint: endPoint)
            
        case .solidColor001:
            self.backgroundColor = UIColor(red: 15/255, green: 32/255, blue: 39/255, alpha: 1)
        case .solidColor002:
            self.backgroundColor = UIColor(red: 32/255, green: 58/255, blue: 67/255, alpha: 1)
        case .solidColor003:
            self.backgroundColor = UIColor(red: 44/255, green: 83/255, blue: 100/255, alpha: 1)
        }
    }
    
    func setGradient(colors: [CGColor], startPoint: CGPoint, endPoint: CGPoint)
    {
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        gradientLayer.colors = colors
        
        
    }
}
