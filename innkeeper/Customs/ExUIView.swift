//
//  ExUIView.swift
//  innkeeper
//
//  Created by orca on 2020/08/07.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class ExUIView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension UIView {
    
    // 늘어난 스크린 넓이 만큼의 비율로 targetView의 높이를 변경한다
    static func setResolution(targetView: UIView) {
        
        guard let targetHeight = targetView.constraints.filter({ $0.identifier == InnIdentifiers.CONSTRIANT_TARGET_HEIGHT.rawValue }).first
        else { return }
        
        let newViewWidth = UIScreen.main.bounds.width       // 현재 스크린의 width
        let originViewWidth = targetView.frame.width        // 원래 뷰의 width
        let originViewHeight = targetView.frame.height      // 원래 뷰의 height
        
        
        /* 비율 공식으로 height를 계산한다
         
              414       :        234       =     1000     :   ?
        originViewWidth : originViewHeight = newViewWidth :   ?
        
        ? = originViewHeight * newViewWidth / originViewWidth
        
        */
        let newViewHeight = originViewHeight * newViewWidth / originViewWidth
        targetHeight.constant = newViewHeight
    }
}
