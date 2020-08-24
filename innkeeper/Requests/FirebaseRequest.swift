//
//  FirebaseRequest.swift
//  innkeeper
//
//  Created by orca on 2020/08/24.
//  Copyright © 2020 example. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class FirebaseRequest {
    static let shared = FirebaseRequest()
    
    var rdb: DatabaseReference!
    
    private init() {
        rdb = Database.database().reference()
    }
    
    func checkSignIn() {
        checkAppleSignIn()
//        checkGoogleSignIn()
    }
    
    private func checkAppleSignIn() {
        guard let appleIdToken = UserDefaults.standard.string(forKey: InnIdentifiers.SIGN_APPLE_ID_TOKEN.rawValue) else { return }
        guard let appleIdNonce = UserDefaults.standard.string(forKey: InnIdentifiers.SIGN_APPLE_ID_NONCE.rawValue) else { return }
        
        print("\n Stored apple id token: \(appleIdToken) / apple id nonce: \(appleIdNonce)")
        
//        let _appleIdToken = appleIdToken as! String
//        let _appleIdNonce = appleIdNonce as! String
//        print("\n Stored apple id token: \(_appleIdToken) / apple id nonce: \(_appleIdNonce)")
    }
    
    private func checkGoogleSignIn() {
        guard let googleIdToken = UserDefaults.standard.string(forKey: InnIdentifiers.SIGN_GOOGLE_ID_TOKEN.rawValue) else { return }
        guard let googleAccessToken = UserDefaults.standard.string(forKey: InnIdentifiers.SIGN_GOOGLE_ACCESS_TOKEN.rawValue) else { return }
        print("\n Stored google id token: \(googleIdToken) / google access token: \(googleAccessToken)")
        
//        let _googleIdToken = googleIdToken as! String
//        let _googleAccessToken = googleAccessToken as! String
//        print("\n Stored google id token: \(_googleIdToken) / google access token: \(_googleAccessToken)")
    }
    
    func appleSignIn(idToken: String, nonce: String) {
        // Initialize a Firebase credential.
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idToken,
                                                  rawNonce: nonce)
        // Sign in with Firebase.
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
                // Error. If error.code == .MissingOrInvalidNonce, make sure
                // you're sending the SHA256-hashed nonce as a hex string with
                // your request to Apple.
                print("\n Firebase(Apple Sign-In) auth error \n - \(error?.localizedDescription ?? "unknown auth error..")")
                return
            }
            
            // User is signed in to Firebase with Apple.
            UserDefaults.standard.set(idToken, forKey: InnIdentifiers.SIGN_APPLE_ID_TOKEN.rawValue)
            UserDefaults.standard.set(nonce, forKey: InnIdentifiers.SIGN_APPLE_ID_NONCE.rawValue)
//            print("\n Firebase(Apple Sign-In) auth success! \n - idToken: \(idToken) / nonce: \(nonce)")
        }
    }
    
    func signInGoogle(idToken: String, accessToken: String) {
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
    //                let authError = error as NSError
                    print("\n Firebase auth(Google Sign-In) failed.. \n - \(error.localizedDescription)")
                    return
                }
                
                // User is signed in to Firebase with Google
                UserDefaults.standard.set(InnIdentifiers.SIGN_GOOGLE_ID_TOKEN.rawValue, forKey: idToken)
                UserDefaults.standard.set(InnIdentifiers.SIGN_GOOGLE_ACCESS_TOKEN.rawValue, forKey: accessToken)
                print("\n Firebase auth(Google Sign-In) success!")
            }
            
            
        }
}
