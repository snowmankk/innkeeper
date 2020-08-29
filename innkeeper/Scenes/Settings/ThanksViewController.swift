//
//  ThanksViewController.swift
//  innkeeper
//
//  Created by orca on 2020/08/27.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit
import SafariServices

class ThanksViewController: UIViewController {

    @IBOutlet var blizzardView: UIView!
    @IBOutlet var firebaseView: UIView!
    @IBOutlet var icon8View: UIView!
    @IBOutlet var pngWing: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        blizzardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapBlizzardView)))
        firebaseView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapFirebaseView)))
        icon8View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapIcon8View)))
        pngWing.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapIcon8View)))
    }
    
    @objc func onTapBlizzardView() {
        visit(identifier: InnIdentifiers.URL_BLIZZARD_DEV)
    }

    @objc func onTapFirebaseView() {
        visit(identifier: InnIdentifiers.URL_FIREBASE)
    }
    
    @objc func onTapIcon8View() {
        visit(identifier: InnIdentifiers.URL_ICON8)
    }
    
    @objc func onPngWing() {
        visit(identifier: InnIdentifiers.URL_PNGWING)
    }
    
    func visit(identifier: InnIdentifiers) {
        let url: URL = URL(string: identifier.rawValue)!
        let sfVC: SFSafariViewController = SFSafariViewController(url: url)
        self.present(sfVC, animated: true, completion: nil)
    }
}
