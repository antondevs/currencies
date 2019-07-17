//
//  FirstCurrencyController.swift
//  Currencies
//
//  Created by Anton Developer on 16/07/2019.
//  Copyright © 2019 Anton Developer. All rights reserved.
//

import UIKit
import ObjectMapper
import SDCAlertView
import RealmSwift

class CurrencyController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var previousCurrency:Currency! = nil
    var currencies:[Currency] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "PairCell", bundle: nil), forCellReuseIdentifier: "CELL")
        self.title = previousCurrency == nil ? "First currency" : "Second currency"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    func saveCurrencyPair(first:Currency, second:Currency) {
        guard let firstCode = first.code else { return }
        guard let secondCode = second.code else { return }
        
        if firstCode == secondCode {
            AlertController.alert(withTitle: "Currencies", message: "Please select different currency", actionTitle: "OK")
            return
        }
        
        if Database.shared.checkPairExist(first: firstCode, second: secondCode) {
            AlertController.alert(withTitle: "Currencies", message: "This pair already exist. Please select another.", actionTitle: "OK")
            return
        }
        
        let rate = Rate()
        rate.firstKey = firstCode
        rate.secondKey = secondCode
        Database.shared.addRate(rate: rate)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func openNextCurrency(currency:Currency) {
        if previousCurrency != nil {
            saveCurrencyPair(first: previousCurrency, second: currency)
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CurrencyController") as! CurrencyController
        controller.previousCurrency = currency
        controller.currencies = currencies
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension CurrencyController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currency = currencies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath as IndexPath) as! PairCell
        
        cell.labelName.text = currency.code ?? ""
        cell.labelDescription.text = currency.name ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.openNextCurrency(currency: currencies[indexPath.row])
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
}

