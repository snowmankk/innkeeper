//
//  ViewController.swift
//  innkeeper
//
//  Created by orca on 2020/06/29.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class WelComeViewController: UIViewController {
    
    enum ViewID: Int {
        case about = 100
        case play
        case noob
        case community
        case appstore
    }
    
    @IBOutlet var tapViews: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNvigationItems()
        
        // 각 메뉴들의 모서리 코너 설정
        for v in tapViews {
            self.setLayerCorner(layer: v.layer)
        }
        
        // 각 메뉴들의 터치 설정
        self.setGestures()

//        self.summaryView.setSummaryHandleButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // depth가 존재할때 (현재 탭에서 다른 씬으로 이동한 후 돌아올때 - 현재 탭에서 상호작용을 하여 씬을 이동하면 새로운 navigationBar item이 생성됨)
        if let item = self.navigationController?.navigationBar.backItem {
            item.title = InnIdentifiers.SCENE_WELCOME.rawValue
        }
        // depth가 없을때 (다른 탭으로 이동한 후 돌아올때)
        else {
            self.navigationController?.navigationBar.topItem?.title = InnIdentifiers.SCENE_WELCOME.rawValue
            self.navigationController?.navigationBar.topItem?.titleView = nil
            
            // navigation background color
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 133/255, green: 147/255, blue: 152/255, alpha: 1.0)
        }
        
//        self.navigationController?.navigationBar.topItem?.titleView = nil
//        self.navigationController?.navigationBar.backItem?.title = InnIdentifiers.SCENE_WELCOME.rawValue
    }
    
    func setLayerCorner(layer: CALayer, radius: CGFloat = 10.0, mask: Bool = true)
    {
        layer.cornerRadius = radius
        layer.masksToBounds = mask
    }
    
    func setNvigationItems() {
        self.navigationController?.navigationBar.topItem?.title = InnIdentifiers.SCENE_WELCOME.rawValue
        
        // back button color
        self.navigationController?.navigationBar.tintColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
    }
}


// MARK:- Gestures
extension WelComeViewController {
    
    func setGestures() {
        for v in self.tapViews {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tappedView(_:)))
            v.addGestureRecognizer(gesture)
        }
    }
    
    @objc func tappedView(_ sender: UIGestureRecognizer) {
        guard let selectedView = sender.view else { return }
        
        // 씬 이동
//        let segueID = "segue-\(selectedView.tag)"
        let segueID = "\(InnIdentifiers.SEGUE_BASE.rawValue)\(selectedView.tag)"
        self.performSegue(withIdentifier: segueID, sender: self)
    }
}


