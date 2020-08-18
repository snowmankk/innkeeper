//
//  SettingsViewController.swift
//  innkeeper
//
//  Created by orca on 2020/08/18.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    let menu: [String] = [InnTexts.SETTINGS_LOGIN.rawValue, InnTexts.SETTINGS_REVIEW.rawValue, InnTexts.SETTINGS_TEA.rawValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.delegate = self
        table.dataSource = self
        
        
    }
}

// MARK:-
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
        cell.configure(title: menu[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectItem(index: indexPath.row)
    }
    
    func selectItem(index: Int) {
        switch menu[index] {
        case InnTexts.SETTINGS_LOGIN.rawValue:
            self.performSegue(withIdentifier: InnIdentifiers.SEGUE_SIGN_IN.rawValue, sender: self)

        case InnTexts.SETTINGS_REVIEW.rawValue:
            break
        case InnTexts.SETTINGS_TEA.rawValue:
            break
        default: break
        }
    }
}
