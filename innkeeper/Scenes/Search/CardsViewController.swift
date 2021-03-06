//
//  SearchViewController.swift
//  innkeeper
//
//  Created by orca on 2020/07/15.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var gradientView: GradientView!
    @IBOutlet var wordCollection: UICollectionView!
    @IBOutlet var cardCollection: UICollectionView!
    
    var words = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchBar.searchTextField.textColor = .white
        searchBar.placeholder = InnTexts.CARD_SEARCH_PLACE_HOLDER.rawValue
        wordCollection.dataSource = self
        cardCollection.dataSource = self
        cardCollection.delegate = self
        SelectedDatas.shared.delegate = self
        HearthStoneAPI.shared.delegates.append(self)
        HearthStoneAPI.shared.requestMetaDatas()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNaviItem()
    }
    
    func setNaviItem() {
        guard let item = self.navigationController?.navigationBar.topItem else { return }
        
        item.title = "vvvv"
        item.titleView = self.searchBar
        //item.titleView?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
    }
    
    func setSelectedKeywords() {
//        let requestString = SelectedDatas.shared.allKeywordsToString()
//        searchBar.text = requestString
        
        words.removeAll()
        words = SelectedDatas.shared.allKeywordsToArray()
        wordCollection.reloadData()
    }
    
    @IBAction func onSearch(_ sender: Any) {
        guard let searchWord = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        SelectedDatas.shared.searchWord = searchWord
        HearthStoneAPI.shared.requestCardDatas()
    }
}

// MARK:- UISearchBarDelegate
extension CardsViewController: UISearchBarDelegate {
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print("textDidChange")
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        onSearch(self)
    }
}

// MARK:- UICollectionViewDelegate
extension CardsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView === cardCollection else { return }
        guard indexPath.row < HearthStoneData.shared.cards.count else { return }

        SelectedDatas.shared.card = HearthStoneData.shared.cards[indexPath.row]
        self.performSegue(withIdentifier: InnIdentifiers.SEGUE_CARD_DETAIL.rawValue, sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= HearthStoneData.shared.cards.count - 1 {
            DispatchQueue.main.async(execute: {
                HearthStoneAPI.shared.requestNextPageCardDatas()
            })
            
        }
    }
    
}

// MARK:- UICollectionViewDataSource
extension CardsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if collectionView === wordCollection {
            count = words.count
        }
        else if collectionView === cardCollection {
            count = HearthStoneData.shared.cards.count
//            count = 3
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === cardCollection {
            let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: CardsCollectionViewCell.identifier, for: indexPath) as! CardsCollectionViewCell
            
            cardCell.configure(index: indexPath.row)
            
            return cardCell
        } else {
            let wordCell = collectionView.dequeueReusableCell(withReuseIdentifier: WordCollectionViewCell.identifier, for: indexPath) as! WordCollectionViewCell
            
            wordCell.configure(title: words[indexPath.row])
            return wordCell
        }
    }
}

// MARK:- UICollectionViewDelegateFlowLayout
extension CardsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellWidth: CGFloat = 0
        if collectionView === cardCollection {
            var spaceCount: CGFloat = 0
            var columnCount: CGFloat = 0
            let screenWidth = UIScreen.main.bounds.width
            let cellSpace:CGFloat = 10
            
            // screenWidth가 640보다 작으면 column이 screenWidh의 2등분, 640 이상이면 3등분 되도록 cell width를 설정한다
            if screenWidth < 640 {
                columnCount = 2
                spaceCount = columnCount + 1
            } else {
                columnCount = 3
                spaceCount = columnCount + 1
            }
            
            cellWidth = screenWidth / columnCount - (cellSpace * spaceCount / columnCount)
        }
        
        return CGSize(width: cellWidth, height: cellWidth * 1.6)
    }
}

// MARK:- SelectedDataDelegate
extension CardsViewController: SelectedDataDelegate {
    func SelecctedDataRemoved() {
        setSelectedKeywords()
    }
}

// MARK:-HearthStroneAPIDelegate
extension CardsViewController: HearthStoneAPIDelegate {
    func responseCardDatas() {
        cardCollection.reloadData()
    }
}
