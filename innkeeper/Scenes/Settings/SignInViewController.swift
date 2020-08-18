//
//  SignInViewController.swift
//  innkeeper
//
//  Created by orca on 2020/08/18.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignInViewController: UIViewController {

    @IBOutlet var googleSignIn: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
//        googleSignIn.alignmentRect(forFrame: CGRect(x: 40, y: 0, width: 0, height: 0))
        googleSignIn.
    }

}
