//
//  CircleMaskView.swift
//  innkeeper
//
//  Created by orca on 2020/07/14.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class CircleMaskView: UIView {

    override func draw(_ rect: CGRect) {
        let halfWidth = self.bounds.size.width / 2
        let halfHeight = self.bounds.size.height / 2
        let circlePath = UIBezierPath.init(arcCenter: CGPoint(x: halfWidth, y: halfHeight), radius: halfWidth, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 4, clockwise: true)
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        self.layer.mask = circleShape
    }
}
