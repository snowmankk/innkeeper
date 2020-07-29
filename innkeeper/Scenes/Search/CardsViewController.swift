//
//  SearchViewController.swift
//  innkeeper
//
//  Created by orca on 2020/07/15.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchController.view.backgroundColor = UIColor(red: 235, green: 235, blue: 235, alpha: 255)
        self.navigationItem.searchController = self.searchController
    }
}
