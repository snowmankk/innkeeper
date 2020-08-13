//
//  SearchDecks.swift
//  innkeeper
//
//  Created by orca on 2020/08/09.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit
import SafariServices

class SearchDecks: UIView {

    @IBOutlet weak var parent: DecksViewController!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchInfo: UILabel!
    
    var communities: [CommuCellData] = []
    
    override func didMoveToWindow() {
        collection.delegate = self
        collection.dataSource = self
        searchField.delegate = self
        HearthStoneAPI.shared.delegate = self
        setCommunityCells()
        
        // placeHolder 텍스트 설정, 색상 변경 
        let attributes: [NSAttributedString.Key : UIColor] = [NSAttributedString.Key.foregroundColor: UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1)]
        searchField.attributedPlaceholder = NSAttributedString(string: InnTexts.DECK_SEARCH_PLACE_HOLDER.rawValue, attributes: attributes)
        
        searchInfo.text = InnTexts.DECK_SEARCH_INFO.rawValue
    }
    
    func setCommunityCells() {
        var data = CommuCellData(imgName: "img_commu_icon_0", title: "하스스터디", url: "https://www.hearthstudy.com/", hidden: false)
        communities.append(data)
        
        data = CommuCellData(imgName: "img_commu_icon_1", title: "하스스톤 인벤", url: "http://hs.inven.co.kr/", hidden: false)
        communities.append(data)
        
        data = CommuCellData(imgName: "img_commu_icon_2", title: "따악", url: "http://dda.ac/deck", hidden: false)
        communities.append(data)
        
        data = CommuCellData(imgName: "img_commu_icon_3", title: "HSReplay", url: "https://hsreplay.net/", hidden: false)
        communities.append(data)
        
        data = CommuCellData(imgName: "img_commu_icon_4", title: "HearthPwn", url: "https://www.hearthpwn.com/", hidden: false)
        communities.append(data)
        
        data = CommuCellData(imgName: "img_commu_icon_5", title: "HS TopDecks", url: "https://www.hearthstonetopdecks.com/", hidden: false)
        communities.append(data)
        
        data = CommuCellData(imgName: "img_commu_icon_6", title: "Icy Veins", url: "https://www.icy-veins.com/", hidden: false)
        communities.append(data)
        
        data = CommuCellData(imgName: "img_commu_icon_7", title: "TEMPO/STORM", url: "https://tempostorm.com/", hidden: false)
        communities.append(data)
    }
    
    @IBAction func onSearch(_ sender: UIButton) {
        guard let fieldText = searchField.text else { return}
        if fieldText.isEmpty { return }
    
//        HearthStoneAPI.shared.requestDeck(deckCode: "AAECAf0EBu0F+KwDxbgDjbsDkssD0M4DDKsEtATmBJYFn5sD/50D+6wD+MwDhc0Dx84Dzc4D99EDAA==")
        HearthStoneAPI.shared.requestDeck(deckCode: fieldText)
    }
}

// MARK:- UICollectionViewDelegate
extension SearchDecks: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url: URL = URL(string: communities[indexPath.row].url)!
        let sfVC: SFSafariViewController = SFSafariViewController(url: url)
        parent.present(sfVC, animated: true, completion: nil)
    }
}

// MARK:- UICollectionViewDataSource
extension SearchDecks: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return communities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DecksCommuCollectionViewCell.identifier, for: indexPath) as! DecksCommuCollectionViewCell
        
        cell.configure(data: communities[indexPath.row])
        return cell
    }
}

// MARK:- UICollectionViewDelegateFlowLayout
extension SearchDecks: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 85)
    }
}


extension SearchDecks: HearthStoneAPIDelegate {
    func responseDeckData() {
        parent.performSegue(withIdentifier: InnIdentifiers.SEGUE_DECK_DETAIL.rawValue, sender: self)
    }
}

// MARK:- UITextFieldDelegate
extension SearchDecks: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let fieldText = searchField.text else { return false }
        if fieldText.isEmpty { return false }
        
        HearthStoneAPI.shared.requestDeck(deckCode: fieldText)
        return true
    }
}
