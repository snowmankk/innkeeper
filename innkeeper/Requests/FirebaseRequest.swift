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

@objc
protocol FirebaseRequestDelegate {
    @objc optional func signInComplete(email: String)
}

class FirebaseRequest {
    static let shared = FirebaseRequest()
    
    var rdb: DatabaseReference!
    var delegates: [FirebaseRequestDelegate] = []
    
    private init() { }
    
    func ready() {
        checkSignIn()
        setRealtimeDatabase()
//        readMyDecks()
    }
    
    // MARK:- Realtime Database
    func setRealtimeDatabase() {
        rdb = Database.database().reference()
        print("\n - Firebaser realtime database url: \(rdb.url)")
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
            
            var deckInfos: [String] = []
            for value in valueArray {
                guard let datas = value as? NSMutableDictionary, datas.count > 0 else { continue }
                
                for data in datas {
                    guard let deck = data.value as? NSMutableDictionary else { continue }
                    
//                    var deckString = ""
                    
                    guard let deckString = deck.object(forKey: "deckInfo") as? String else { continue }
                    if deckString.isEmpty { continue }
                    deckInfos.append(deckString)
                    print("\n Firebase query(deckInfo: \(deckString)")
                }
            }
            
            DeckDatas.shared.myDecks.removeAll()
            
            for deckInfo in deckInfos {
                let arr = deckInfo.components(separatedBy: InnIdentifiers.SEPERATOR_DECK_STRING.rawValue)
                guard arr.count > 0 else { continue }
                HearthStoneAPI.shared.requestDeck(deckCode: arr[0], deckName: arr[1], addToMyDecks: true)
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
//            let ref = rdb.child(userEmail).childByAutoId()
//            ref.child("deckCode").setValue(deckCode)
//            ref.child("deckName").setValue(deckName)
            
            let deckString = "\(deckCode)\(InnIdentifiers.SEPERATOR_DECK_STRING.rawValue)\(deckName)"
            rdb.child(userEmail).childByAutoId().child("deckInfo").setValue(deckString)
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
            } else {
                // User is signed in to Firebase with Apple.
                
                self.readMyDecks()
            }
            
            guard let email = authResult?.user.email else { return }
            for delegate in self.delegates {
                delegate.signInComplete?(email: email)
            }
        }
    }
    
    func googleSignIn(idToken: String, accessToken: String) {
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                // let authError = error as NSError
                print("\n Firebase auth(Google Sign-In) failed.. \n - \(error.localizedDescription)")
                return
            } else {
                self.readMyDecks()
            }
            
            // User is signed in to Firebase with Google
            guard let email = authResult?.user.email else { return }
            for delegate in self.delegates {
                delegate.signInComplete?(email: email)
            }
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


