//
//  GaugeView.swift
//  innkeeper
//
//  Created by orca on 2020/08/11.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class GaugeView: UIView {

    var gaugeView: UIView
    var gaugeText: UILabel
    var maxValue: CGFloat = 0
    var currentValue: CGFloat = 0 //CGFloat(Int.random(in: 0 ..< 10)) 
    var gaugeAdded: Bool = false
    
    required init?(coder: NSCoder) {
        gaugeView = UIView()
        gaugeText = UILabel()
        super.init(coder: coder)
    }
    
    init(frame: CGRect, gaugeColor: UIColor, maxValue: CGFloat, hideGaugeText: Bool = false) {
        let currentHeight = frame.height / maxValue * currentValue
        let posY = frame.height - currentHeight
        gaugeView = UIView(frame: CGRect(x: 0, y: posY, width: frame.width, height: currentHeight))
        gaugeView.backgroundColor = gaugeColor
        gaugeAdded = true
        
        gaugeText = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: 12))
        gaugeText.textAlignment = .center
        gaugeText.textColor = UIColor(red: 31/255, green: 33/255, blue: 36/255, alpha: 1)
        gaugeText.font = gaugeText.font.withSize(7)
        gaugeText.text = "(\(Int(currentValue))"
        
        self.maxValue = maxValue
        
        super.init(frame: frame)
        
        self.setGauge(gaugeColor: gaugeColor)
        self.addSubview(gaugeText)
    }
    
    func setView(gaugeColor: UIColor, currentValue: CGFloat, maxValue: CGFloat, hideGaugeText: Bool = false) {
        self.currentValue = currentValue
        gaugeText = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: 12))
        gaugeText.textAlignment = .center
        gaugeText.textColor = UIColor(red: 31/255, green: 33/255, blue: 36/255, alpha: 1)
        gaugeText.font = gaugeText.font.withSize(7)
        gaugeText.text = "(\(Int(self.currentValue)))"
        
        self.maxValue = maxValue
        
        setGauge(gaugeColor: gaugeColor)
        self.addSubview(gaugeText)
    }
    
    func setGauge(gaugeColor: UIColor) {
        let maxHeight = self.frame.height
        let currentHeight = maxHeight / maxValue * currentValue
        
        let posY = self.frame.height - currentHeight
        
        if (gaugeAdded) {
//            gaugeView.frame.size = CGSize(width: self.frame.width, height: currentHeight)
            gaugeView.frame = CGRect(x: 0, y: posY, width: self.frame.width, height: currentHeight)
        } else {
            gaugeView = UIView(frame: CGRect(x: 0, y: posY, width: self.frame.width, height: currentHeight))
            gaugeView.backgroundColor = gaugeColor
            self.addSubview(gaugeView)
            gaugeAdded = true
        }
        
        print("gauge value: \(currentValue)")
        print("gauge height: \(currentHeight)\n")
    }
    
}
