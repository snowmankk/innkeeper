//
//  DeckDetailViewController.swift
//  innkeeper
//
//  Created by orca on 2020/08/11.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class DeckDetailViewController: UIViewController {

    var deckData: DeckData?
    var decksCards: [CardData] = []             // 덱에서 중복된 카드를 제거한 카드 목록
    var sectionCards: [SectionCrads] = []       // 직업 카드, 중립 카드를 구분해서 저장함
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var graphs: [GaugeView] = []
    @IBOutlet var costs: [UILabel] = []
    @IBOutlet var title0: UILabel!
    @IBOutlet var title1: UILabel!
    @IBOutlet var composition: UILabel!         // 덱의 구성 (하수인, 주문, 무기, 영웅교체 카드의 개수)
    @IBOutlet weak var add: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        title0.text = InnTexts.MANA_COMPOSITION.rawValue
        title1.text = InnTexts.DECK_COMPOSITION.rawValue
        
        deckData = DeckDatas.shared.searchedDeck
        setDecksCard()
        setSectionData()
        setGraphs()
        setCosts()
        setComposition()
        setAddButtonHidden()
    }
    
    // 덱의 모든 카드를 오름 차순으로 정렬(마나 기준) 후 중복되는 카드를 제거한 카드 목록을 구함
    func setDecksCard() {
        guard let cards = deckData?.cards else { return }
        
        let cardSet = Set(cards)
        decksCards = Array(cardSet)
    }
    
    // 직업 카드, 중립 카드를 구분해서 저장함
    func setSectionData() {
        var neutralCard: [CardData] = []
        var classCard: [CardData] = []
        for card in decksCards {
            if card.classIds[0] == .NEUTRAL {
                neutralCard.append(card)
            } else {
                classCard.append(card)
            }
        }

        if classCard.count > 0 {
            classCard.sort(by: { return $0.mana ?? 0 < $1.mana ?? 0 })
            sectionCards.append(SectionCrads(name: InnTexts.CLASS_CARD.rawValue, cards: classCard))
        }
        
        if neutralCard.count > 0 {
            neutralCard.sort(by: { return $0.mana ?? 0 < $1.mana ?? 0 })
            sectionCards.append(SectionCrads(name: InnTexts.NEUTRAL_CARD.rawValue, cards: neutralCard))
        }
    }
    
    func setGraphs() {
        var maxValue: Int = 10
        for i in 0 ..< graphs.count {
            let cardCount = getCardCount(manaCost: i)
            if cardCount > maxValue { maxValue = cardCount }
            graphs[i].setView(gaugeColor: .orange, currentValue: CGFloat(cardCount), maxValue: CGFloat(maxValue))
        }
    }
    
    func setCosts() {
        for i in 0 ..< costs.count {
            costs[i].text = "\(i)"
            
            if (i == costs.count - 1) { costs[i].text?.append("+") }
        }
    }
    
    func setComposition() {
        guard let cards = deckData?.cards else { return }
        
        var minion: Int = 0
        var spell: Int = 0
        var weapon: Int = 0
        var hero: Int = 0
        
        for card in cards {
            if card.type == .MINION { minion += 1 }
            else if card.type == .SPELL { spell += 1 }
            else if card.type == .WEAPON { weapon += 1 }
            else if card.type == .HERO { hero += 1 }
        }
        
        composition.text = "\(CardTypes.MINION.name): \(minion)   \(CardTypes.SPELL.name): \(spell)   \(CardTypes.WEAPON.name): \(weapon)   \(CardTypes.HERO.name): \(hero)"
    }

    // 특정 마나(비용)와 일치하는 카드들의 개수 반환
    func getCardCount(manaCost mana: Int) -> Int {
        let cards = deckData?.cards?.filter { $0.mana == mana }
        return cards?.count ?? 0
    }
    
    // 특정 id와 일치하는 카드들의 개수 반환
    func getCardCount(cardName name: String) -> Int {
        let cards = deckData?.cards?.filter { $0.name == name }
        return cards?.count ?? 0
    }
    
    func setAddButtonHidden() {
        if DeckDatas.shared.myDecks.contains(where: { $0.code == deckData?.code }) {
            add.isEnabled = false
        } else {
            add.isEnabled = true
        }
        
    }
    
    @IBAction func onAdd(_ sender: Any) {
        let alert = UIAlertController(title: "내 덱에 추가", message: "이 덱의 이름을 입력하세요.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let add = UIAlertAction(title: "추가", style: .default) { (action) -> Void in
            guard let deckName = alert.textFields?.first?.text, deckName.isEmpty == false else { return }
            guard var deck = self.deckData else { return }
            print("deck name: \(deckName)")
            
            deck.name = deckName
            DeckDatas.shared.myDecks.append(deck)
            self.setAddButtonHidden()
            
            FirebaseRequest.shared.writeMyDecks(deckDatas: [deck])
        }
        
        alert.addAction(cancel)
        alert.addAction(add)
        alert.addTextField { (textField) -> Void in
            textField.placeholder = "덱 이름"
        }
        
        self.present(alert, animated: false)
    }
}

// MARK:- UITableViewDelegate
extension DeckDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SelectedDatas.shared.card = sectionCards[indexPath.section].cards[indexPath.row]
        self.performSegue(withIdentifier: InnIdentifiers.SEGUE_CARD_DETAIL_OF_DECK.rawValue, sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCards.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionCards[section].name
    }
}

// MARK:- UITableViewDataSource
extension DeckDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionCards[section].cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DeckDetailTableViewCell.identifier, for: indexPath) as! DeckDetailTableViewCell
//        let card = decksCards[indexPath.row]
        let card = sectionCards[indexPath.section].cards[indexPath.row]
        cell.configure(name: card.name ?? "", imgUrl: card.cropImgUrl ?? "" , manaCost: card.mana ?? 0, cardCount: getCardCount(cardName: card.name ?? ""))
        return cell
    }
    
}

struct SectionCrads {
    var name = ""
    var cards: [CardData] = []
}
