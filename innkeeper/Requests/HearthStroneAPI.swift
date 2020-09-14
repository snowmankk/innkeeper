//
//  HearthStroneAPI.swift
//  innkeeper
//
//  Created by orca on 2020/07/17.
//  Copyright © 2020 example. All rights reserved.
//

import Foundation
import Alamofire

@objc
protocol HearthStoneAPIDelegate {
    @objc optional func responseCardDatas()
    @objc optional func responseDeckData(deck: Any?)
}

class HearthStoneAPI {
    static let shared: HearthStoneAPI = HearthStoneAPI()
    let pageSize: Int = 10
    
    private var accessToken: String = ""
    private let dispatchSemaphore = DispatchSemaphore(value: 0)
    private let dispatchQueue = DispatchQueue.global()
    
    var page: Int = 1
    var delegates: [HearthStoneAPIDelegate] = []
    
    private init() {}
    
    func  requestAccessToken() {
        let url = URL(string: "https://kr.battle.net/oauth/token")!
        
        let params: Parameters = [
            "grant_type" : "client_credentials",
            "client_id" : "46cb94c1b4a94a4fb71e8fe03035314a",
            "client_secret" : "ANYjYtg0jgw1nxsaIwUaB6NL46AxmEr7"
        ]
        
        
        AF.request(url, method: .post, parameters: params, encoding: URLEncoding.queryString, headers: nil, interceptor: nil, requestModifier: nil).response { (responseData) in
            guard let data = responseData.data else { return }
            
            do {
                let authData = try JSONDecoder().decode(HearthStoneAuth.self, from: data)
                self.accessToken = authData.accessToken
                print("\n Access token: \(self.accessToken)")
            } catch {
                print("\n Access token error: \(error)")
            }
        }
    }
    
    func requestMetaDatas() {
        self.requestGroupDatas {
            self.requestMetaData(category: .CLASSES)
            self.requestMetaData(category: .TYPES)
            self.requestMetaData(category: .RARITY)
            self.requestMetaData(category: .SETS)
            self.requestMetaData(category: .MINION_TYPES)
            self.requestMetaData(category: .OPTIONS)
        }
    }
    
    func makeCardDataRequestURL() -> String {
        
        let cls: String = SelectedDatas.shared.keywordsToSlugStrings(category: .CLASSES)
        let type: String = SelectedDatas.shared.keywordsToSlugStrings(category: .TYPES)
        let rarity: String = SelectedDatas.shared.keywordsToSlugStrings(category: .RARITY)
        let set: String = SelectedDatas.shared.keywordsToSlugStrings(category: .SETS)
        let minionType: String = SelectedDatas.shared.keywordsToSlugStrings(category: .MINION_TYPES)
        let option: String = SelectedDatas.shared.keywordsToSlugStrings(category: .OPTIONS)
        let cost: String = SelectedDatas.shared.keywordsToString(category: .COST)
        let attack: String = SelectedDatas.shared.keywordsToString(category: .ATTACK)
        let hp: String = SelectedDatas.shared.keywordsToString(category: .HP)
        let searchWord: String = SelectedDatas.shared.searchWord
        
        let url: String = "https://kr.api.blizzard.com/hearthstone/cards?locale=ko_KR&set=\(set)&class=\(cls)&manaCost=\(cost)&attack=\(attack)&health=\(hp)&collectible=1&rarity=\(rarity)&type=\(type)&minionType=\(minionType)&keyword=\(option)&textFilter=\(searchWord)&gameMode=constructed&page=\(page)&pageSize=\(pageSize)&sort=name&order=desc&access_token=\(self.accessToken)"
//        print("request url: \(url)")
        return url
    }
    
    func getSlug(category: MetadataCategory, keywords: inout [String]) -> String{
        guard keywords.count == 1 else { return "" }
        guard let keyword = keywords.first else { return "" }
        
        let slug = HearthStoneData.shared.getSlug(category: category, keyword: keyword)
        return slug
    }
    
    func requestCardDatas() {
        print("Access token : \(self.accessToken)")

        page = 1
        HearthStoneData.shared.cards.removeAll()
        
        let url = makeCardDataRequestURL()
        requestCards(url: url)
    }
    
    func requestNextPageCardDatas() {
        if page == 0 {
            print("요청할 카드 없음..")
            return
        }
        page += 1
        requestCards(url: makeCardDataRequestURL())
    }
    
    func requestCards(url: String) {
        AF.request(url).response { (responseData) in
            guard let data = responseData.data else { return }
            
            do {
                //let cards = try JSONDecoder().decode(Dictionary<String, [CardData2]>.self, from: data)
                let cardResponse = try JSONDecoder().decode(CardResponse.self, from: data)
                guard let cards = cardResponse.cards else { return }
                
                guard cards.count > 0 else {
                    if self.page > 1 {
                        print("더 이상 받아올 카드 없음..")
                        self.page = 0
                    }
                    return
                }
                
                for card in cards {
                    HearthStoneData.shared.cards.append(card)
                }
                
                
                for delegate in self.delegates {
                    delegate.responseCardDatas?()
                }
                
                
            } catch {
                print("\n Alamofire error: \(error)")
            }
        }
    }
    
    func requestMetaData(category: MetadataCategory) {
        
        let url: URL = URL(string: "https://kr.api.blizzard.com/hearthstone/metadata/\(category.rawValue)?locale=ko_KR&access_token=\(self.accessToken)")!

        AF.request(url).response { (responseData) in
            guard let data = responseData.data else { return }
            
            do {
                let metaDatas = try JSONDecoder().decode([MetaDataBase].self, from: data)
                switch(category) {
                case .CLASSES      : HearthStoneData.shared.classes = metaDatas
                case .RARITY       : HearthStoneData.shared.rarity = metaDatas
                case .TYPES        : HearthStoneData.shared.types = metaDatas
                case .MINION_TYPES : HearthStoneData.shared.minionTypes = metaDatas
                case .OPTIONS      : HearthStoneData.shared.options = metaDatas
                case .SETS         :
                    
                    HearthStoneData.shared.sets.removeAll()
                    HearthStoneData.shared.wildSets.removeAll()
                    
                    // 정규, 야생 세트 구분
                    for set in metaDatas {
                        if HearthStoneData.shared.standards.contains(set.slug) {
                            HearthStoneData.shared.sets.append(set)
                        } else {
                            HearthStoneData.shared.wildSets.append(set)
                        }
                    }
                    
                    var setStr = "\n정규: "
                    for standard in HearthStoneData.shared.sets {
                        setStr += "\(standard.name) / "
                    }
                    print(setStr)
                    
                    setStr = "\n야생: "
                    for wild in HearthStoneData.shared.wildSets {
                        setStr += "\(wild.name) / "
                    }
                    print(setStr)
                    
                default : break
                }
                
//                print("\n MetaData(\(category.localName)): \(metaDatas)")
                
            } catch {
                print("\n MeataData error: \(error)")
            }
        }
    }
    
    func requestGroupDatas(completion: (() -> Void)? = nil) {
        let url: URL = URL(string: "https://kr.api.blizzard.com/hearthstone/metadata/setGroups?locale=ko_KR&access_token=\(self.accessToken)")!
        
        AF.request(url).response { (responseData) in
            guard let data = responseData.data else { return }
            
            do {
                let setDatas = try JSONDecoder().decode([SetGroupData].self, from: data)
                
                for set in setDatas {
                    let slug = set.slug
                    
                    if "standard" == slug {                             // 정규 카드
                        let groups = set.cardSets
                        HearthStoneData.shared.standards = groups
                    } else if "wild" == slug {                          // 야생 카드
                        let groups = set.cardSets
                        HearthStoneData.shared.wilds = groups
                    }
                }
                
                // 야생에 포함되어있는 정규 세트 목록 제거
                for standard in HearthStoneData.shared.standards {
                    HearthStoneData.shared.wilds.removeAll(where: { $0 == standard })
                }
             
                completion?()

            } catch {
                print("\n Group datas error: \(error)")
            }
        }
    }
    
    func requestDeck(deckCode: String, deckName: String = "", addToMyDecks: Bool = false) {
        let url =  "https://kr.api.blizzard.com/hearthstone/deck/\(deckCode)?locale=ko_KR&access_token=\(self.accessToken)"
        AF.request(url).response { (responseData) in
            guard let data = responseData.data else { return }
            
            var deckData = DeckData()
            do {
                deckData = try JSONDecoder().decode(DeckData.self, from: data)
//                print("\n Deck data: \(deckData)")
                
                deckData.name = deckName
                DeckDatas.shared.searchedDeck = deckData
                
            } catch {
                print("\n Deck data reponse error: \(error)")
            }
            
            if addToMyDecks {
                let _duplicateDeck = DeckDatas.shared.myDecks.filter { $0.code == deckData.code }
                if _duplicateDeck.count > 0 { return }
                
                print("\n My deck (name: \(deckData.name ?? "") / code: \(deckData.code ?? "")")
                DeckDatas.shared.myDecks.append(deckData)
            }
            
            for delegate in self.delegates {
                delegate.responseDeckData?(deck: deckData)
            }
            
        }
    }
 
}
