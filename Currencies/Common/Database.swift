//
//  Database.swift
//  Currencies
//
//  Created by Anton Developer on 17/07/2019.
//  Copyright © 2019 Anton Developer. All rights reserved.
//

import RealmSwift

class Database {
    
    static let shared = Database()
    
    private var database:Realm
    
    private init() {
        database = try! Realm()
    }
    
    func getRates() -> Results<Rate> {
        return database.objects(Rate.self)
    }
    
    func addRate(rate: Rate)   {
        try! database.write {
            database.add(rate)
        }
    }
    
    func removeRate(rate: Rate) {
        try! database.write {
            database.delete(rate)
        }
    }
    
    func checkPairExist(first:String, second:String) -> Bool {
        let object = self.database.objects(Rate.self).filter("firstKey = %@ AND secondKey = %@", first, second).first
        return object != nil
    }
    
}
