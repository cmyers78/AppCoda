//
//  Loan.swift
//  KivaLoan
//
//  Created by Christopher Myers on 1/12/18.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import Foundation

struct Loan : Codable {
    var name : String = ""
    var country : String = ""
    var use : String = ""
    var amount : Int = 0
    
    enum CodingKeys: String, CodingKey {
        case name
        case country = "location"
        case use
        case amount = "loan_amount"
    }
    
    // to handle nested value within another container
    enum LocationKeys : String, CodingKey {
        case country
    }
    
    // used instead of default implementation for init(from decoder...) 
    
    init(from decoder : Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        
        let location = try values.nestedContainer(keyedBy: LocationKeys.self, forKey: .country)
        country = try location.decode(String.self, forKey: .country)
        
        use = try values.decode(String.self, forKey: .use)
        amount = try values.decode(Int.self, forKey: .amount)
    }
}

struct LoansDataStore : Codable {
    var loans : [Loan]
}
