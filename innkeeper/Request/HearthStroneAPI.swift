//
//  HearthStroneAPI.swift
//  innkeeper
//
//  Created by orca on 2020/07/17.
//  Copyright © 2020 example. All rights reserved.
//

import Foundation

@objc
protocol HearthStoneAPIDelegate {
    @objc optional func responseCardDatas()
    @objc optional func responseDeckData()
}

class HearthStoneAPI {
    static let shared: HearthStoneAPI = HearthStoneAPI()
    let pageSize: Int = 10
    
    private var accessToken: String = ""
    private let dispatchSemaphore = DispatchSemaphore(value: 0)
    private let dispatchQueue = DispatchQueue.global()
    
    var page: Int = 1
    var delegate: HearthStoneAPIDelegate?
    
    private init() {}
    
    func requestAccessToken()
    {
        let url = URL(string: "https://kr.battle.net/oauth/token")!
        let params = [
            "grant_type" : "client_credentials",
            "client_id" : "46cb94c1b4a94a4fb71e8fe03035314a",
            "client_secret" : "ANYjYtg0jgw1nxsaIwUaB6NL46AxmEr7"
        ]
        let paramString = params.map {"\($0)=\($1)"}.joined(separator: "&") // for clarity and debugging
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = paramString.data(using: .utf8)
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { print("empty data"); return }
            guard let apiDict = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else { return }
            
            self.accessToken = apiDict["access_token"] as! String
//            self.dispatchSemaphore.signal()
            
        }.resume()
//        _ = dispatchSemaphore.wait(timeout: .now() + 5)
        
    }
    
    func requestMetaDatas() {
        self.requestGroupDatas()
        _ = dispatchSemaphore.wait(timeout: .now() + 5)
        
        self.requestMetaData(category: .CLASSES)
        self.requestMetaData(category: .TYPES)
        self.requestMetaData(category: .RARITY)
        self.requestMetaData(category: .SETS)
        self.requestMetaData(category: .MINION_TYPES)
        self.requestMetaData(category: .OPTIONS)
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
        print("request url: \(url)")
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
        
//        let url = URL(string: makeCardDataRequestURL())!
//        let request: URLRequest = URLRequest(url: url)
        
//        request.httpMethod = "GET"
//        request.addValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        page = 1
        HearthStoneData.shared.cards.removeAll()
        requestCards(url: makeCardDataRequestURL())
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
        let uri = URL(string: url)!
        let request: URLRequest = URLRequest(url: uri)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { print("empty data"); return }
            guard let apiDict = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else { return }
            guard let cardDataArr = apiDict["cards"] as? [NSDictionary] else { return }
            guard cardDataArr.count > 0 else {
                if self.page > 1 {
                    print("더 이상 받아올 카드 없음..")
                    self.page = 0
                }
                return
            }
            
            for cardData in cardDataArr {
                HearthStoneData.shared.cards.append(self.makeCardData(apiData: cardData))
            }
            
            self.dispatchSemaphore.signal()
        }.resume()
        
        _ = dispatchSemaphore.wait(timeout: .now() + 0.5)
        self.delegate?.responseCardDatas?()
    }
    
    func makeCardData(apiData: NSDictionary) -> CardData {
        let name = apiData["name"] as! String
        let imgUrl = apiData["image"] as! String
        
        var classIds: [Classes] = []
        if let multiClassIds = apiData["multiClassIds"] as? [Int], multiClassIds.count > 0 {
            for classId in multiClassIds {
                let cls = Classes(rawValue: classId) ?? Classes.NEUTRAL
                classIds.append(cls)
            }
        } else {
            let classId: Int = apiData["classId"] as! Int
            let cls = Classes(rawValue: classId) ?? Classes.NEUTRAL
            classIds.append(cls)
        }
        
        var mana: Int = -1
        if let obj = apiData.object(forKey: "manaCost") { mana = obj as! Int }
        
        var attack: Int = -1
        if let obj = apiData.object(forKey: "attack") { attack = obj as! Int }
        
        let type = CardTypes(rawValue: apiData["cardTypeId"] as! Int) ?? CardTypes.MINION
        
        var durability = -1
        if let obj = apiData.object(forKey: "durability") { durability = obj as! Int }
        
        var hp: Int = -1
        if let obj = apiData.object(forKey: "health") { hp = obj as! Int }
        
        var armor: Int = -1
        if let obj = apiData.object(forKey: "armor") { armor = obj as! Int }
        
        var flavorText: String = ""
        if let obj = apiData.object(forKey: "flavorText") { flavorText = obj as! String }
        
        let rarity = apiData.object(forKey: "rarityId") as! Int
        
        let set = apiData.object(forKey: "cardSetId") as! Int
        
        let cropImgUrl = apiData.object(forKey: "cropImage") as! String
        
        let cardData: CardData = CardData(name: name, type: type, mana: mana, attack: attack, hp: hp, durability: durability, armor: armor, imgUrl: imgUrl, classIds: classIds, flavorText: flavorText, rarity: rarity, set: set, cropImgUrl: cropImgUrl)
        
        return cardData
    }
        
    func requestMetaData(category: MetadataCategory) {
        print("request category : \(category)")
        
        let url: URL = URL(string: "https://kr.api.blizzard.com/hearthstone/metadata/\(category.rawValue)?locale=ko_KR&access_token=\(self.accessToken)")!

        let request: URLRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { print("empty data"); return }
            guard let apiArr = try? JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary] else { return}
            guard apiArr.count > 0 else { return }
            
            var metaDatas: [MetaDataBase] = []
            for info in apiArr {
                let id = info["id"] as! Int
                let slug = info["slug"] as! String
                let name = info["name"] as! String
                
                let metaData = MetaDataBase(id: id, slug: slug, name: name)
                metaDatas.append(metaData)
            }

            switch(category) {
            case .CLASSES      : HearthStoneData.shared.classes = metaDatas
            case .RARITY       : HearthStoneData.shared.rarity = metaDatas
            case .TYPES        : HearthStoneData.shared.types = metaDatas
            case .MINION_TYPES : HearthStoneData.shared.minionTypes = metaDatas
            case .OPTIONS      : HearthStoneData.shared.options = metaDatas
            case .SETS         :
                // 정규, 야생 세트 구분
                for set in metaDatas {
                    if HearthStoneData.shared.standards.contains(set.slug) {
                        HearthStoneData.shared.sets.append(set)
                    } else {
                        HearthStoneData.shared.wildSets.append(set)
                    }
                }
                
            default : break
            }
            
        }.resume()
    }
    
    func requestGroupDatas() {
        let url: URL = URL(string: "https://kr.api.blizzard.com/hearthstone/metadata/setGroups?locale=ko_KR&access_token=\(self.accessToken)")!

        print("request set group data")
        let request: URLRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { print("empty data"); return }
            guard let apiArr = try? JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary] else { return}
            guard apiArr.count > 0 else { return }
            
            for info in apiArr {
                let slug = info["slug"] as! String
                if "standard" == slug {
                    let groups = info["cardSets"] as! [String]
                    HearthStoneData.shared.standards = groups
                } else if "wild" == slug {
                    let groups = info["cardSets"] as! [String]
                    HearthStoneData.shared.wilds = groups
                }
            }
            
            // 야생에 포함되어있는 정규 세트 목록 제거
            for standard in HearthStoneData.shared.standards {
                HearthStoneData.shared.wilds.removeAll(where: { $0 == standard })
            }
            
            var str: String = "stardard list : "
            for standard in HearthStoneData.shared.standards {
                str.append("\(standard) ")
            }
            print(str)
            
            
            str = "wild list : "
            for wild in HearthStoneData.shared.wilds {
                str.append("\(wild) ")
            }
            print(str)
            
            self.dispatchSemaphore.signal()
        }.resume()
            
    }
    
    func requestDeck(deckCode: String) {
//        let deckCode: String = "AAECAf0EBu0F+KwDxbgDjbsDkssD0M4DDKsEtATmBJYFn5sD/50D+6wD+MwDhc0Dx84Dzc4D99EDAA=="
        let urlString =  "https://kr.api.blizzard.com/hearthstone/deck/\(deckCode)?locale=ko_KR&access_token=\(self.accessToken)"
        let url: URL = URL(string: urlString)!
        let request: URLRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { print("empty data"); return }
            guard let apiDict = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else { return }
            guard let cardDataArr = apiDict["cards"] as? [NSDictionary] else { return }
            guard let classData = apiDict["class"] as? NSDictionary else { return }
            
            let cls: Int = classData["id"] as! Int
            var cardDatas: [CardData] = []
            for cardData in cardDataArr {
                cardDatas.append(self.makeCardData(apiData: cardData))
            }
            
            let deckData = DeckData(name: "꺄울~", cls: Classes(rawValue: cls) ?? Classes.NEUTRAL, cards: cardDatas)
            DeckDatas.shared.searchedDeck = deckData
            
            self.dispatchSemaphore.signal()
        }.resume()
        
        _ = self.dispatchSemaphore.wait()
        self.delegate?.responseDeckData?()
    }
    
}
