//
//  ViewController.swift
//  Currencies
//
//  Created by Anton Developer on 16/07/2019.
//  Copyright © 2019 Anton Developer. All rights reserved.
//

import UIKit
import RealmSwift
import SDCAlertView

class RateViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var rates:Results<Rate>! = nil
    private var currencyManager:CurrencyManager = CurrencyManager()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyManager.loadCurrencies()
        rates = Database.shared.getRates()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
        tableView.register(UINib(nibName: "CurrencyCell", bundle: nil), forCellReuseIdentifier: "CELL")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        refreshControl.addTarget(self, action: #selector(pullRefresh(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currencyManager.updateRates { (result) in
            
            if result {
                self.tableView.reloadData()
            }
            else {
                AlertController.alert(withTitle: "Currencies", message: "Failed to update rates", actionTitle: "OK")
            }
        }
    }
    
    @objc private func pullRefresh(_ sender: Any) {
        currencyManager.updateRates { (result) in
            if result {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
            else {
                self.refreshControl.endRefreshing()
                AlertController.alert(withTitle: "Currencies", message: "Failed to update rates", actionTitle: "OK")
            }
        }
    }
    
    @IBAction func onAdd(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CurrencyController") as! CurrencyController
        controller.currencies = currencyManager.getCurrencies()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func removeRateByIndex(index:Int) {
        Database.shared.removeRate(rate: self.rates[index])
    }

}

extension RateViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.rates[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath as IndexPath) as! CurrencyCell
        
        if let firstCurrency = currencyManager.getCurrencyByCode(code: item.firstKey),
            let secondCurrency = currencyManager.getCurrencyByCode(code: item.secondKey) {
           
            guard let firstCode = firstCurrency.code else { return cell }
            guard let secondCode = secondCurrency.code else { return cell }
            
            cell.labelFirstCurrency.text = "1 \(firstCode)"
            cell.labelFirstDescription.text = firstCurrency.name ?? ""
            cell.labelRate.text = String.init(format: "%.2f", currencyManager.calcRate(first: firstCode, second: secondCode))
            cell.labelSecondCurrency.text = "\(secondCurrency.name ?? "") • \(secondCode)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rates.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.removeRateByIndex(index: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

