//
//  Pokemon.swift
//  Pokedex
//
//  Created by Lukáš Růžička on 21.03.18.
//  Copyright © 2018 Lukáš Růžička. All rights reserved.
//

import Foundation

class Pokemon {
    
    private var _name: String!
    private var _id: Int!
    
    
    var name: String {
        return _name
    }
    
    var id: Int {
        return _id
    }
    
    init(name: String, id: Int) {
        self._name = name
        self._id = id
    }
    
}
