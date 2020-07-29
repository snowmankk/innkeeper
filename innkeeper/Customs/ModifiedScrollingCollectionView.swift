//
//  ModifiedScrollingCollectionView.swift
//  innkeeper
//
//  Created by orca on 2020/07/21.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class ModifiedScrollingCollectionView: UICollectionView {

    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton { return true }
        
        return super.touchesShouldCancel(in: view)
    }
}
