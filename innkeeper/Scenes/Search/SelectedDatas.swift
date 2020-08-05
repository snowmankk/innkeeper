//
//  SelectedDatas.swift
//  innkeeper
//
//  Created by orca on 2020/07/24.
//  Copyright © 2020 example. All rights reserved.
//

import Foundation

protocol SelectedDataDelegate {
    func SelecctedDataRemoved()
}

class SelectedDatas {
    static let shared = SelectedDatas()
    
    var delegate: SelectedDataDelegate! = nil
    
    var classes = [String]()
    var types = [String]()
    var rarities = [String]()
    var sets = [String]()
    var minionTypes = [String]()
    var options = [String]()
    var costs = [String]()
    var attacks = [String]()
    var hps = [String]()
    var card: CardData = CardData()
    
    private init() {}
    
    func setKeywordDatas(category: MetadataCategory, keyword: String, add: Bool) {
        
        switch category {
        case .CLASSES:      setKeywordEachDatas(categoryData: &classes,     keyword: keyword, add: add)
        case .TYPES:        setKeywordEachDatas(categoryData: &types,       keyword: keyword, add: add)
        case .RARITY:       setKeywordEachDatas(categoryData: &rarities,    keyword: keyword, add: add)
        case .SETS:         setKeywordEachDatas(categoryData: &sets,        keyword: keyword, add: add)
        case .MINION_TYPES: setKeywordEachDatas(categoryData: &minionTypes, keyword: keyword, add: add)
        case .OPTIONS:
            // 옵션은 한개만 선택 가능
            options.removeAll()
            setKeywordEachDatas(categoryData: &options,     keyword: keyword, add: add)
        default: break
        }
        
        print("\(category.localName): \(keywordsToString(category: category))")
    }
    
    func setKeywordDatas(keyword: String, add: Bool) {
        setKeywordEachDatas(categoryData: &classes,     keyword: keyword, add: add)
        setKeywordEachDatas(categoryData: &types,       keyword: keyword, add: add)
        setKeywordEachDatas(categoryData: &rarities,    keyword: keyword, add: add)
        setKeywordEachDatas(categoryData: &sets,        keyword: keyword, add: add)
        setKeywordEachDatas(categoryData: &minionTypes, keyword: keyword, add: add)
        setKeywordEachDatas(categoryData: &options,     keyword: keyword, add: add)
        
        if add == false { delegate.SelecctedDataRemoved() }
    }
    
    private func setKeywordEachDatas(categoryData: inout [String], keyword: String, add: Bool) {
        if add {
            if categoryData.contains(keyword) { return }
            categoryData.append(keyword)
        } else {
            categoryData.removeAll(where: { $0 == keyword })
        }
    }
    
    func setRangeDatas(category: MetadataCategory, lowerValue: Int, upperValue: Int) {
        var arr = [String]()        
        if lowerValue >= upperValue {
            arr.append(String(lowerValue))
        } else {
            for value in lowerValue ... upperValue {
                arr.append(String(value))
            }
        }
        
        // lowerValue, upperValue가 모두 최소값(0)이거나
        // lowerValue가 최소값(0), upperValue가 최대값(10)이면 아무런 데이터를 추가하지 않는다
        // (api 요청시 범위 데이터를 이곳(SelectedDatas)에서 참조할때 자동으로 비어있는 문자열이 반환되도록)
        let min = HearthStoneData.shared.rangeMin
        let max = HearthStoneData.shared.rangeMax
        let add: Bool = (lowerValue == min && upperValue == min) || (lowerValue == min && upperValue == max)
        
        switch category {
        case .COST :
            costs.removeAll()
            if false == add { costs = arr }
        case .ATTACK :
            attacks.removeAll()
            if false == add { attacks = arr }
        case .HP :
            hps.removeAll()
            if false == add { hps = arr }
        default : break
        }
        
        print("\(category.localName): \(keywordsToString(category: category))")
    }
    
    // 특정 category의 키워드(MetaDataBase.name)들을 ','을 삽입하여 합친 문자열로 반환
    func keywordsToString(category: MetadataCategory) -> String {
        let keywords = getData(category: category)
        if keywords.isEmpty { return "" }
        
        var requestString = ""
        for keyword in keywords {
            var keywordOf = ""
            if keyword == keywords.last { keywordOf = keyword }
            else                        { keywordOf = "\(keyword)," }
            
            requestString.append(keywordOf)
        }
        
        return requestString
    }
    
    // 특정 category의 키워드(MetaDataBase.name)를 일치하는 슬러그(MetaDataBase.slug)로 변환하고 ','을 삽입하여 합친 문자열로 반환
    func keywordsToSlugStrings(category: MetadataCategory) -> String {
        let keywords = getData(category: category)
        if keywords.isEmpty { return "" }
        
        var slugs = ""
        for keyword in keywords {
            var slugOf = ""
            let slug = HearthStoneData.shared.getSlug(category: category, keyword: keyword)
            if keyword == keywords.last { slugOf = slug }
            else                        { slugOf = "\(slug)," }
            
            slugs.append(slugOf)
        }
        
        return slugs
    }
    
    func allKeywordsToString() -> String {
        let keywords: [String] = allKeywordsToArray()
        
        var str = ""
        for keyword in keywords {
            var keywordOf = ""
            if keyword == keywords.last { keywordOf = keyword }
            else                        { keywordOf = "\(keyword) " }
            str.append(keywordOf)
        }
        
        return str
    }
    
    func allKeywordsToArray() -> [String] {
        var keywords = [String]()
        if (false == classes.isEmpty)       { keywords.append(contentsOf: classes) }
        if (false == types.isEmpty)         { keywords.append(contentsOf: types) }
        if (false == rarities.isEmpty)      { keywords.append(contentsOf: rarities) }
        if (false == sets.isEmpty)          { keywords.append(contentsOf: sets) }
        if (false == minionTypes.isEmpty)   { keywords.append(contentsOf: minionTypes) }
        if (false == options.isEmpty)       { keywords.append(contentsOf: options) }
        
        return keywords
    }
    
    func getData(category: MetadataCategory) -> [String] {
        
        var data = [String]()
        switch category {
        case .CLASSES       : data = classes
        case .TYPES         : data = types
        case .RARITY        : data = rarities
        case .SETS          : data = sets
        case .MINION_TYPES  : data = minionTypes
        case .OPTIONS       : data = options
        case .COST          : data = costs
        case .ATTACK        : data = attacks
        case .HP            : data = hps
        default             : break
        }
        
        return data
    }
}
