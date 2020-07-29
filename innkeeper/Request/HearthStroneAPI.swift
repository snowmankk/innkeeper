//
//  HearthStroneAPI.swift
//  innkeeper
//
//  Created by orca on 2020/07/17.
//  Copyright © 2020 example. All rights reserved.
//

import Foundation

class HearthStoneAPI {
    static let shared: HearthStoneAPI = HearthStoneAPI()
    
    private var accessToken: String = ""
    private let dispatchGroup = DispatchGroup()
    private let dispatchSemaphore = DispatchSemaphore(value: 0)
    private let dispatchQueue = DispatchQueue.global()
    
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
//            guard let data = data else { print("empty data"); return }
//            let dataString = String(data: data, encoding: .utf8)
            
            guard let data = data else { print("empty data"); return }
            guard let apiDict = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else { return }
            
            self.accessToken = apiDict["access_token"] as! String
            self.dispatchSemaphore.signal()
            
        }.resume()
        _ = dispatchSemaphore.wait(timeout: .now() + 5)
        
        self.requestGroupDatas()
        _ = dispatchSemaphore.wait(timeout: .now() + 5)
        
        self.requestMetaDatas()
    }
    
    func requestMetaDatas() {
        self.requestMetaData(category: .CLASSES)
        self.requestMetaData(category: .TYPES)
        self.requestMetaData(category: .RARITY)
        self.requestMetaData(category: .SETS)
        self.requestMetaData(category: .MINION_TYPES)
        self.requestMetaData(category: .OPTIONS)
    }
    
    func makeCardDataRequestURL() -> String {
        
        let cls: String = SelectedDatas.shared.keywordsToSlugStrings(category: .CLASSES) //keywordsToString(category: .CLASSES)
        //getSlug(category: .CLASSES, keywords: &SelectedDatas.shared.classes)
        let type: String = SelectedDatas.shared.keywordsToSlugStrings(category: .TYPES)
        //getSlug(category: .TYPES, keywords: &SelectedDatas.shared.types)
        let rarity: String = SelectedDatas.shared.keywordsToSlugStrings(category: .RARITY)
        // getSlug(category: .RARITY, keywords: &SelectedDatas.shared.rarities)
        let set: String = SelectedDatas.shared.keywordsToSlugStrings(category: .SETS)
        //getSlug(category: .SETS, keywords: &SelectedDatas.shared.sets)
        let minionType: String = SelectedDatas.shared.keywordsToSlugStrings(category: .MINION_TYPES)
        //getSlug(category: .MINION_TYPES, keywords: &SelectedDatas.shared.minionTypes)
        let option: String = SelectedDatas.shared.keywordsToSlugStrings(category: .OPTIONS)
        //getSlug(category: .OPTIONS, keywords: &SelectedDatas.shared.options)
        let cost: String = SelectedDatas.shared.keywordsToString(category: .COST)
        let attack: String = SelectedDatas.shared.keywordsToString(category: .ATTACK)
        let hp: String = SelectedDatas.shared.keywordsToString(category: .HP)
        
        let url: String = "https://kr.api.blizzard.com/hearthstone/cards?locale=ko_KR&set=\(set)&class=\(cls)&manaCost=\(cost)&attack=\(attack)&health=\(hp)&collectible=1&rarity=\(rarity)&type=\(type)&minionType=\(minionType)&keyword=\(option)&textFilter=&gameMode=constructed&page=1&pageSize=10&sort=name&order=desc&access_token=\(self.accessToken)"
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
//        let url = URL(string: "https://kr.api.blizzard.com/hearthstone/cards?locale=ko_KR&type=minion&minionType=dragon&page=1&pageSize=5&sort=name&order=desc&access_token=\(self.accessToken)")!
        
        let url = URL(string: makeCardDataRequestURL())!
        let request: URLRequest = URLRequest(url: url)
        //        request.httpMethod = "GET"
        //        request.addValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { print("empty data"); return }
            guard let apiDict = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else { return}
            guard let cardArr = apiDict["cards"] as? [NSDictionary], cardArr.count > 0 else { return }
            
            var cards: [CardData] = []
            for card in cardArr {
                let name = card["name"] as! String
                let imgUrl = card["image"] as! String
                
                var id: Int = card["classId"] as! Int
                let cls = HearthStoneData.shared.classes.filter({ $0.id == id }).first?.name ?? ""
                
                id = card["rarityId"] as! Int
                let rarity = HearthStoneData.shared.rarity.filter({ $0.id == id }).first?.name ?? ""
                
                id = card["cardTypeId"] as! Int
                let type = HearthStoneData.shared.types.filter({ $0.id == id }).first?.name ?? ""
                
                id = card["cardSetId"] as! Int
                let set = HearthStoneData.shared.sets.filter({ $0.id == id }).first
                let setName = set?.name ?? ""
                let setSlug = set?.slug ?? ""
                let isStandard = HearthStoneData.shared.standards.contains(setSlug)

                let cardData: CardData = CardData(imgUrl: imgUrl, cls: cls, type: rarity, rarity: type, set: setName, standard: isStandard)
                cards.append(cardData)
                
                print("name: \(name)/ imgUrl : \(cardData.imgUrl) / cls : \(cardData.cls) / rarity : \(cardData.rarity) / type : \(cardData.type) / set : \(cardData.set) / standard : \(isStandard)")
                print("\n")
            }
            
        }.resume()
    }
        
    func requestMetaData(category: MetadataCategory) {
        print("request category : \(category)")
        
        let url: URL = URL(string: "https://kr.api.blizzard.com/hearthstone/metadata/\(category.rawValue)?locale=ko_KR&access_token=\(self.accessToken)")!

//        print("request classes url : \(url.absoluteString)")
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
//                print("\(category.rawValue) [id : \(id) / name : \(name)]")
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
                
            default            : break
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
    
}
