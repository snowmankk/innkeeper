//
//  KeywordsViewController.swift
//  innkeeper
//
//  Created by orca on 2020/07/20.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class KeywordsViewController: UIViewController {
    
    @IBOutlet var collectionView: ModifiedScrollingCollectionView!
    
    var cells: [UICollectionViewCell] = []
    var selectedKeywords: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        if let layout = self.collectionView.collectionViewLayout as? KeywordsViewLayout {
            layout.delegate = self
        }
    }
    
    @IBAction func onDone(_ sender: Any) {
        guard let tvc = self.presentingViewController as? UITabBarController else { return }
        guard let nvc = tvc.selectedViewController as? UINavigationController else { return }
        guard let cvc = nvc.topViewController as? CardsViewController else { return }
        
        self.presentingViewController?.dismiss(animated: true) {
            cvc.setSelectedKeywords()
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK:- KeywordsColeectionViewCellDelegate
//extension KeywordsViewController: KeywordsCollectionViewCellDelegate {
//
//    func collectionViewCell(selected keyword: String, add: Bool) {
//
//        if add {
//            selectedKeywords.append(keyword)
//        } else {
////            guard let index = selectedKeywords.firstIndex(of: keyword) else { return }
////            selectedKeywords.remove(at: index)
//
//            selectedKeywords.removeAll(where: { $0 == keyword })
//        }
//
//        print("\n")
//        for key in selectedKeywords {
//            print("selected keywords \(key)")
//        }
//    }
//}

// MARK:- KeywordsViewLayoutDelegate
extension KeywordsViewController: KeywordsViewLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        
        let category = MetadataCategory.numberToCategory(num: indexPath.row)
        var height: CGFloat = 0
        
        switch category {
        case .CLASSES, .TYPES, .RARITY, .SETS, .MINION_TYPES, .OPTIONS, .WILD_SETS :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordsCollectionViewCell.identifier, for: indexPath) as! KeywordsCollectionViewCell
            
            cell.configure(category: category)
            //cell.delegate = self
            height = cell.cellHeight
            
            cells.append(cell)
            break
            
        case .COST, .ATTACK, .HP :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RangeCollectionViewCell.identifier, for: indexPath) as! RangeCollectionViewCell
            
            cell.configure(category: category)
            height = cell.cellHeight
            cells.append(cell)
            break
            
        default: break
        }
        
        return height
    }
}

// MARK:- UICollectionViewDelegate
extension KeywordsViewController: UICollectionViewDelegate
{
    
}

// MARK:- UICollectionViewDataSource
extension KeywordsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = cells[indexPath.row]
        return cell
    }
}

