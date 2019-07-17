//
//  CurrencyManager.swift
//  Currencies
//
//  Created by Anton Developer on 18/07/2019.
//  Copyright © 2019 Anton Developer. All rights reserved.
//

import Alamofire
import ObjectMapper

class CurrencyManager {
    
    private var baseCurrency:String = ""
    private var currencies:[Currency]
    private var rates:[String:Double] = [:]
    
    init() {
        currencies = []
    }
    
    func getCurrencies() -> [Currency] {
        return currencies
    }
    
    func getCurrencyByCode(code:String) -> Currency? {
        if let index = currencies.firstIndex(where: { $0.code ?? "" == code  }) {
            return currencies[index]
        }
        return nil
    }
    
    func calcRate(first:String, second:String) -> Double {
        if first == baseCurrency && rates.keys.contains(second) {
            return rates[second] ?? 1
        }
        else if second == baseCurrency && rates.keys.contains(first) {
            return 1.0 / (rates[first] ?? 1)
        }
        else if rates.keys.contains(first) &&
           rates.keys.contains(second) {
            
            let firstRate = rates[first] ?? 1
            let secondRate = rates[second] ?? 1
            return (1.0 / firstRate) * secondRate
        }
        
        return 0
    }
    
    func loadCurrencies() {
        guard let filePath = Bundle.main.url(forResource: "Data/currencies", withExtension: "json") else {
            print("Failed loading countries.json file")
            return
        }
        
        do {
            let data = try Data(contentsOf: filePath)
            let jsonObject = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]]
            currencies = Mapper<Currency>().mapArray(JSONArray: jsonObject!)
        } catch {
            print("Error: \(error)")
        }
    }
    
    func updateRates(completion: @escaping (Bool)->()) {
        Alamofire.request("https://api.exchangeratesapi.io/latest").responseJSON { response in
            if let json = response.result.value {
                if let rateResult = Mapper<RateResult>().map(JSONObject:json), let rateList = rateResult.rates {
                    self.rates = rateList
                    self.baseCurrency = rateResult.base ?? ""
                    completion(true)
                }
                else {
                    completion(false)
                }
            }
            else {
                completion(false)
            }
        }
    }
    
}
