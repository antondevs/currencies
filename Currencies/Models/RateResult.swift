//
//  RateResult.swift
//  Currencies
//
//  Created by Anton Developer on 18/07/2019.
//  Copyright © 2019 Anton Developer. All rights reserved.
//

import Foundation
import ObjectMapper

struct RateResult : Mappable {
    var base : String?
    var date : String?
    var rates : [String:Double]?
        
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        rates <- map["rates"]
        base <- map["base"]
        date <- map["date"]
    }
    
}
