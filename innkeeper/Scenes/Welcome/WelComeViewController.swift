//
//  ViewController.swift
//  innkeeper
//
//  Created by orca on 2020/06/29.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class WelComeViewController: UIViewController {
    
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var appstoreView: UIImageView!
    @IBOutlet weak var summaryView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Welcome!"
        
        setLayerCorner(layer: aboutView.layer)
        setLayerCorner(layer: appstoreView.layer)
        
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(self.tappedView(_:)))
        aboutView.addGestureRecognizer(gesture1)
        
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(self.tappedView2(_:)))
        appstoreView.addGestureRecognizer(gesture2)
        
        
        
        
        
        
        
//        let maskView = UIView(frame: CGRect(x: 100, y: 200, width: 128, height: 128))
//        maskView.backgroundColor = .blue
//        maskView.layer.cornerRadius = 20
//        redView.mask = maskView
    }
    
    func setLayerCorner(layer: CALayer, radius: CGFloat = 15.0, mask: Bool = true)
    {
        layer.cornerRadius = 15.0
        layer.masksToBounds = true
    }
    
    @objc func tappedView(_ sender: UIGestureRecognizer) {
        print("tapped 'aboutView'")
    }
    
    @objc func tappedView2(_ sender: UIGestureRecognizer) {
        print("tapped 'appstoreView'")
        
        let redView = UIView(frame: CGRect(x: 0, y: 0, width: summaryView.bounds.width, height: summaryView.bounds.height))
        redView.backgroundColor = .black
        redView.alpha = 0.5
        summaryView.addSubview(redView)
        mask(viewToMask: redView, maskRect: CGRect(x: 30, y: 30, width: 50, height: 50), invert: true)
    }
    
    func mask(viewToMask: UIView, maskRect: CGRect, invert: Bool = false) {
        let maskLayer = CAShapeLayer()
        let path = CGMutablePath()
        if (invert) {
            path.addRect(viewToMask.bounds)
        }
        path.addRect(maskRect)

        maskLayer.path = path
        if (invert) {
            maskLayer.fillRule = .evenOdd
        }

        viewToMask.layer.mask = maskLayer;
    }
}

