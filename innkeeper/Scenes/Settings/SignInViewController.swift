//
//  SignInViewController.swift
//  innkeeper
//
//  Created by orca on 2020/08/18.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit
import CryptoKit
import GoogleSignIn
import AuthenticationServices
import FirebaseAuth

class SignInViewController: UIViewController {
    
    private var indicator: UIActivityIndicatorView!
    private var currentNonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        FirebaseRequest.shared.delegates.append(self)
        setUI()
        indicator.hidesWhenStopped = true
    }
    
    func setUI() {
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
        
        indicator = UIActivityIndicatorView(style: .large)
        indicator.center = view.center
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .white
        indicator.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.topAnchor.constraint(equalTo: view.superview?.topAnchor ?? view.topAnchor, constant: 55),
            indicator.leadingAnchor.constraint(equalTo: view.superview?.leadingAnchor ?? view.leadingAnchor, constant: 0),
            indicator.trailingAnchor.constraint(equalTo: view.superview?.trailingAnchor ?? view.trailingAnchor, constant: 0),
            indicator.bottomAnchor.constraint(equalTo: view.superview?.bottomAnchor ?? view.bottomAnchor, constant: 0)
//            indicator.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    @objc func onTapAppleSignIn() {
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    // 애플 로그인 요청에 대해 'nonce' 문자열(무작위) 생성 https://firebase.google.com/docs/auth/ios/apple?authuser=0
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }

    private func makeSignInAlert(email: String) {
        let alert = UIAlertController(title: "로그인 성공!", message: "\(email)님\n환영합니다 : )", preferredStyle: .alert)
        let add = UIAlertAction(title: "확인", style: .default) { (action) -> Void in
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(add)
        self.present(alert, animated: false)
    }
}

// MARK:- ASAuthorizationControllerDelegate
extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        /*
        switch authorization.credential {
        case let credential as ASAuthorizationAppleIDCredential :
            print("\nApple Sign-In success!\n\n - user id(Apple): \(credential.user)\n\n")
            break
        default: break
        }
        */
        
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("\n Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("\n Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("\n Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            indicator.startAnimating()
            FirebaseRequest.shared.appleSignIn(idToken: idTokenString, nonce: nonce)
            
//            var userEmail = appleIDCredential.email ?? ""
//            if userEmail.isEmpty { userEmail = Auth.auth().currentUser?.email ?? "" }
//            makeSignInAlert(email: userEmail)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("\n Apple Sign-In failed..\n\n - \(error)\n\n")
    }
    
    
}

// MARK:- ASAuthorizationControllerPresentationContextProviding
extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    
}

// MARK:- GIDSignInDelegate
extension SignInViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    
        if error == nil { return }
        
        guard let userId = user?.userID else { print("\n Google Sign-In failed(no google id)"); return }
        print("\n Google Sign-In success! \n - user id(Google): \(userId)")
        
        guard let authentication = user.authentication else { return }
        
        indicator.startAnimating()
        FirebaseRequest.shared.googleSignIn(idToken: authentication.idToken, accessToken: authentication.accessToken)
        
//        guard let userEmail = user?.profile.email else { return }
//        makeSignInAlert(email: userEmail)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("\n Google Sign-In failed.. \n - \(error.localizedDescription)")
    }
}

extension SignInViewController: FirebaseRequestDelegate {
    func signInComplete(email: String) {
        indicator.stopAnimating()
        makeSignInAlert(email: email)
    }
}
