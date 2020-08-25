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
    
    private init() { }
    
    func ready() {
        checkSignIn()
        setRealtimeDatabase()
        readMyDecks()
    }
    
    // MARK:- Realtime Database
    func setRealtimeDatabase() {
        rdb = Database.database().reference()
        print("\n - Firebaser realtime database url: \(rdb.url)")
//        self.rdb.child("test").child("test_deck_001").setValue("test_deck_code_001")
//        self.rdb.child("test").childByAutoId().setValue("test_deck_code_002")
    }
    
    func readMyDecks() {
        guard var userEmail = Auth.auth().currentUser?.email else {
            print("\n User info not exist..")
            return
        }
        
        print("\n")
        userEmail = userEmail.replacingOccurrences(of: ".", with: "_dot_")
        rdb.child(userEmail).queryOrderedByKey().observe(.value) { (snapshot) in
            guard let values = snapshot.value else { return }
            let valueArray = NSArray(object: values)
            
            for value in valueArray {
                guard let datas = value as? NSMutableDictionary else { continue }
                
                for data in datas {
                    guard let deckInfo = data.value as? NSMutableDictionary else { continue }
                    let deckCode = deckInfo["deckCode"] as! String
                    let deckName = deckInfo["deckName"] as! String
                    
                    print("\n Firebase query(deckCode: \(deckCode) / deckName: \(deckName)")
                }
            }
        }
    }
    
    func writeMyDecks(deckDatas: [DeckData]) {
        guard var userEmail = Auth.auth().currentUser?.email else {
            print("\n User info not exist..")
            return
        }
        
        print("\n")
        userEmail = userEmail.replacingOccurrences(of: ".", with: "_dot_")
        for deck in deckDatas {
            guard let deckCode = deck.code else { continue }
            guard let deckName = deck.name else { continue }
            let ref = rdb.child(userEmail).childByAutoId()
            ref.child("deckCode").setValue(deckCode)
            ref.child("deckName").setValue(deckName)
        }

    }
    
    
    // MARK:- Sign-In
    func checkSignIn() {
        let user = Auth.auth().currentUser
        print("\n User: \(user?.email ?? "no user")")
        
        //        checkAppleSignIn()
        //        checkGoogleSignIn()
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
            guard let email = authResult?.user.email else { return }
        }
    }
    
    func googleSignIn(idToken: String, accessToken: String) {
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                //                let authError = error as NSError
                print("\n Firebase auth(Google Sign-In) failed.. \n - \(error.localizedDescription)")
                return
            }
            
            // User is signed in to Firebase with Google
            guard let email = authResult?.user.email else { return }
        }
        
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
}


