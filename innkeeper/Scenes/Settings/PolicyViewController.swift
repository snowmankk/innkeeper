//
//  PolicyViewController.swift
//  innkeeper
//
//  Created by orca on 2020/08/27.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit
import WebKit

class PolicyViewController: UIViewController {
    
    @IBOutlet var web: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let policyUrl = Bundle.main.url(forResource: "Privacy-Policy", withExtension: "html") else { return }
        let request = URLRequest(url: policyUrl)
        web.load(request)
    }
}
