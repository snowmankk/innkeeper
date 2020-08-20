//
//  SignInViewController.swift
//  innkeeper
//
//  Created by orca on 2020/08/18.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit
import GoogleSignIn
import AuthenticationServices

class SignInViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self

        setSignInButtons()
    }
    
    func setSignInButtons() {
        let appleSignIn = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)
        appleSignIn.addTarget(self, action: #selector(onTapAppleSignIn), for: .touchUpInside)
        appleSignIn.translatesAutoresizingMaskIntoConstraints = false
        appleSignIn.cornerRadius = 2
        view.addSubview(appleSignIn)
        
        NSLayoutConstraint.activate([
            appleSignIn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -35),
            appleSignIn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            appleSignIn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            appleSignIn.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        let googleSignIn2 = GIDSignInButton()
        googleSignIn2.translatesAutoresizingMaskIntoConstraints = false
        googleSignIn2.style = .wide
        view.addSubview(googleSignIn2)
        
        NSLayoutConstraint.activate([
            googleSignIn2.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 35),
            googleSignIn2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 46),
            googleSignIn2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -46),
            googleSignIn2.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func onTapAppleSignIn() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

}

// MARK:- ASAuthorizationControllerDelegate
extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credential as ASAuthorizationAppleIDCredential :
            print("\nApple Sign-In success!\n\n - user id(Apple): \(credential.user)\n\n")
            break
        default: break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("\nApple Sign-In failed..\n\n - \(error)\n\n")
    }
}

// MARK:- ASAuthorizationControllerPresentationContextProviding
extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    
}

extension SignInViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        guard let userId = user?.userID else { print("no google id.."); return }
        print("user id(Google): \(userId)")
    }
}
