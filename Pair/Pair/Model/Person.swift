//
//  Person.swift
//  Pair
//
//  Created by Mitch Merrell on 9/6/19.
//  Copyright © 2019 Mitch Merrell. All rights reserved.
//

import Foundation

class Person : Codable {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

extension Person : Equatable {
    static func == (rhs: Person, lhs: Person) -> Bool {
        return rhs.name == lhs.name
    }
}
