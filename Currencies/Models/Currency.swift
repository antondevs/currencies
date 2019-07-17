//
//  Currency.swift
//  Currencies
//
//  Created by Anton Developer on 16/07/2019.
//  Copyright © 2019 Anton Developer. All rights reserved.
//

import Foundation
import ObjectMapper

struct Currency : Mappable {
    
    var code : String?
    var name : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        code <- map["code"]
        name <- map["name"]
    }
    
}
