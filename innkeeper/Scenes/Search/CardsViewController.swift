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
    
    var words = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchBar.searchTextField.textColor = .white
        wordCollection.dataSource = self
        SelectedDatas.shared.delegate = self
        
        HearthStoneAPI.shared.requestAccessToken()
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
        
        words = SelectedDatas.shared.allKeywordsToArray()
        wordCollection.reloadData()
    }
    
    @IBAction func onSearch(_ sender: Any) {
        HearthStoneAPI.shared.requestCardDatas()
    }
}

// MARK:- UISearchBarDelegate
extension CardsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
    }
}

// MARK:- UICollectionViewDataSource
extension CardsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordCollectionViewCell.identifier, for: indexPath) as! WordCollectionViewCell
        
        cell.configure(title: words[indexPath.row])
        return cell
    }
}

// MARK:- SelectedDataDelegate
extension CardsViewController: SelectedDataDelegate {
    func SelecctedDataRemoved() {
        setSelectedKeywords()
    }
}
