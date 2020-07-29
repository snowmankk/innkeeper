//
//  KeywordsViewLayout.swift
//  innkeeper
//
//  Created by orca on 2020/07/20.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

protocol KeywordsViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
}

class KeywordsViewLayout: UICollectionViewLayout {
    
    var delegate: KeywordsViewLayoutDelegate! = nil
    
    let cellPadding: CGFloat = 10
    let contentWidth: CGFloat = UIScreen.main.bounds.size.width
    var contentHeight: CGFloat = 0
    
    var layoutAttributes = [UICollectionViewLayoutAttributes]()
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        
        guard let collectionView = self.collectionView else {
            return
        }
        
        var posY: CGFloat = 0
        let itemCount = collectionView.numberOfItems(inSection: 0)
        for itemIndex in 0 ..< itemCount {

            let indexPath = IndexPath(item: itemIndex, section: 0)
            var cellHeight = delegate.collectionView(collectionView, heightForItemAt: indexPath)
            cellHeight = cellPadding * 2 + cellHeight
            
            let frame = CGRect(x: 0, y: posY, width: contentWidth, height: cellHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            layoutAttributes.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            posY += cellHeight
        }
        
    }
    

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var newLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attribute in layoutAttributes {
            if attribute.frame.intersects(rect) { newLayoutAttributes.append(attribute) }
        }
        
        return newLayoutAttributes
    }
}
