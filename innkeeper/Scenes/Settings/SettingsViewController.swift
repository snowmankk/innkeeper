//
//  SettingsViewController.swift
//  innkeeper
//
//  Created by orca on 2020/08/18.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit
import StoreKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    var myProduct: SKProduct?
    var menu: [String] = [InnTexts.SETTINGS_LOGIN.rawValue, InnTexts.SETTINGS_PRIVACY_POLICY.rawValue, InnTexts.SETTINGS_THANKS_TO.rawValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.delegate = self
        table.dataSource = self
        FirebaseRequest.shared.delegates.append(self)
        setSignInTitle()
        
        let productRequest = SKProductsRequest(productIdentifiers: ["citron_tea_001"])
        productRequest.delegate = self
        productRequest.start()
    }
    
    func setSignInTitle() {
        if let email = Auth.auth().currentUser?.email {
            menu[0] = "\(InnTexts.SETTINGS_LOGIN.rawValue)(\(email))"
        }
    }
}

// MARK:- UITableViewDelegate, UITableViewDataSource
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
        
        if menu[index].contains(InnTexts.SETTINGS_LOGIN.rawValue) {
            self.performSegue(withIdentifier: InnIdentifiers.SEGUE_SIGN_IN.rawValue, sender: self)
        }
        else if menu[index].contains(InnTexts.SETTINGS_PRIVACY_POLICY.rawValue) {
            self.performSegue(withIdentifier: InnIdentifiers.SEGUE_POLICY.rawValue, sender: self)
        }
        
        else if menu[index].contains(InnTexts.SETTINGS_THANKS_TO.rawValue) {
            self.performSegue(withIdentifier: InnIdentifiers.SEGUE_THANKS.rawValue, sender: self)
        }
        
        /*
        switch menu[index] {
        case InnTexts.SETTINGS_LOGIN.rawValue:
            self.performSegue(withIdentifier: InnIdentifiers.SEGUE_SIGN_IN.rawValue, sender: self)

        case InnTexts.SETTINGS_PRIVACY_POLICY.rawValue:
            self.performSegue(withIdentifier: InnIdentifiers.SEGUE_POLICY.rawValue, sender: self)
            break
            
        case InnTexts.SETTINGS_THANKS_TO.rawValue:
            self.performSegue(withIdentifier: InnIdentifiers.SEGUE_THANKS.rawValue, sender: self)
            break
        case InnTexts.SETTINGS_TEA.rawValue:
            
            guard let myProduct = self.myProduct else { return }
            
            if SKPaymentQueue.canMakePayments() {
                let payment = SKPayment(product: myProduct)
                SKPaymentQueue.default().add(self)
                SKPaymentQueue.default().add(payment)
            }
            
            break
        default: break
        }
 */
    }
}

// MARK:- SKProductsRequestDelegate, SKPaymentTransactionObserver
extension SettingsViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard let product = response.products.first else { return }
        
        myProduct = product
        print("product identifier: \(product.productIdentifier)")
        print("product price: \(product.price)")
        print("product priceLocale: \(product.priceLocale)")
        print("product localizedTitle: \(product.localizedTitle)")
        print("product localizedDescription: \(product.localizedDescription)")
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing: break
                
            case .purchased, .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                
            case .failed, .deferred:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                
            default:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
            }
        }
    }
}

extension SettingsViewController: FirebaseRequestDelegate {
    
    func signInComplete(email: String) {
        setSignInTitle()
        table.reloadData()
    }
}
