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
        setGradient(color1: UIColor.yellow, color2: UIColor.systemGreen)
    }
    
    func setGradient(color1: UIColor, color2: UIColor)
    {
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        let startColor = UIColor(red: 240/255, green: 152/255, blue: 25/255, alpha: 1)
        let endColor = UIColor(red: 237/255, green: 222/255, blue: 93/255, alpha: 1)
//        let startColor = UIColor(cgColor: CGColor(srgbRed: 235, green: 229, blue: 116, alpha: 255))
//        let endColor = UIColor(cgColor: CGColor(srgbRed: 225, green: 245, blue: 196, alpha: 255))
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
 
}
