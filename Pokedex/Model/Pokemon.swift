//
//  Pokemon.swift
//  Pokedex
//
//  Created by Lukáš Růžička on 21.03.18.
//  Copyright © 2018 Lukáš Růžička. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _id: Int!
    private var _desc: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvoName: String!
    private var _nextEvoLvl: String!
    private var _nextEvoId: Int!
    private var _pokemonURL: String!
    
    var name: String {
        return _name
    }
    
    var id: Int {
        return _id
    }
    
    var desc: String {
        if _desc == nil {
            return ""
        }
        return _desc
    }
    
    var type: String {
        if _type == nil {
            return ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            return ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            return ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            return ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            return ""
        }
        return _attack
    }
    
    var nextEvoTxt: String {
        if _nextEvoName == nil {
            return "No Evolutions"
        }
        if _nextEvoLvl == nil {
            return "Next Evolution: \(_nextEvoName.capitalized)"
        }
        return "Next Evolution:  \(_nextEvoName.capitalized) - LVL\(_nextEvoLvl!)"
    }
    
    var nextEvoId: Int {
        if _nextEvoId == nil {
            return 0
        }
        return _nextEvoId
    }
    
    init(name: String, id: Int) {
        self._name = name
        self._id = id
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.id)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        Alamofire.request(_pokemonURL).responseJSON { response in
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? Int {
                    self._weight = "\(weight)"
                }
                
                if let height = dict["height"] as? Int {
                    self._height = "\(height)"
                }
                
                if let stats = dict["stats"] as? [Dictionary<String, AnyObject>] {
                    for stat in stats {
                        if let stat_value = stat["base_stat"] as? Int {
                            if let stat_detail = stat["stat"] as? Dictionary<String, AnyObject> {
                                if let stat_name = stat_detail["name"] as? String {
                                    if stat_name == "attack" {
                                        self._attack = "\(stat_value)"
                                    } else if stat_name == "defense" {
                                        self._defense = "\(stat_value)"
                                    }
                                }
                            }
                        }
                    }
                }
                
                if let types = dict["types"] as? [Dictionary<String, AnyObject>], types.count > 0 {
                    for type in types {
                        if let type_detail = type["type"] as? Dictionary<String, AnyObject> {
                            if let type_name = type_detail["name"] as? String {
                                if self._type == nil || self._type == "" {
                                    self._type = type_name.capitalized
                                } else {
                                    self._type! += "/\(type_name.capitalized)"
                                }
                            }
                        }
                    }
                }
                
                if let species = dict["species"] as? Dictionary<String, AnyObject> {
                    if let url2 = species["url"] as? String {
                        Alamofire.request(url2).responseJSON { response in
                            if let dict2 = response.result.value as? Dictionary<String, AnyObject> {
                                
                                if let texts = dict2["flavor_text_entries"] as? [Dictionary<String, AnyObject>] {
                                    for text in texts {
                                        if let desc = text["flavor_text"] as? String {
                                            if let lang = text["language"] as? Dictionary<String, AnyObject> {
                                                if let lang_name = lang["name"] as? String {
                                                    if lang_name == "en" {
                                                        self._desc = desc.replacingOccurrences(of: "\n", with: " ")
                                                        break
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                if let evo_chain = dict2["evolution_chain"] as? Dictionary<String, AnyObject> {
                                    if let url3 = evo_chain["url"] as? String {
                                        Alamofire.request(url3).responseJSON { response in
                                            if let dict3 = response.result.value as? Dictionary<String, AnyObject> {
                                                if var chain = dict3["chain"] as? Dictionary<String, AnyObject> {
                                                    
                                                    var notCurrentEvolve = true
                                                    
                                                    while notCurrentEvolve {
                                                        
                                                        if let species = chain["species"] as? Dictionary<String, AnyObject> {
                                                            if let name = species["name"] as? String {
                                                                if self._name.lowercased() == name.lowercased() {
                                                                    notCurrentEvolve = false
                                                                    
                                                                    if let evolutions = chain["evolves_to"] as? [Dictionary<String, AnyObject>], evolutions.count > 0 {
                                                                        
                                                                        if let details = evolutions[0]["evolution_details"] as? [Dictionary<String, AnyObject>], details.count > 0 {
                                                                            if let level = details[0]["min_level"] as? Int {
                                                                                self._nextEvoLvl = "\(level)"
                                                                            }
                                                                        }
                                                                        
                                                                        if let species = evolutions[0]["species"] as? Dictionary<String, AnyObject> {
                                                                            if let evo_name = species["name"] as? String {
                                                                                self._nextEvoName = evo_name
                                                                            }
                                                                            if let url4 = species["url"] as? String {
                                                                                Alamofire.request(url4).responseJSON { response in
                                                                                    if let dict4 = response.result.value as? Dictionary<String, AnyObject> {
                                                                                        if let evo_id = dict4["id"] as? Int {
                                                                                            self._nextEvoId = evo_id
                                                                                        }
                                                                                    }
                                                                                    completed()
                                                                                }
                                                                            }
                                                                        }
                                                                        
                                                                    } else {
                                                                        break
                                                                    }
                                                                } else {
                                                                    if let evolutions = chain["evolves_to"] as? [Dictionary<String, AnyObject>], evolutions.count > 0 {
                                                                        chain = evolutions[0]
                                                                    }
                                                                    else {
                                                                        break;
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        
                                                        
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                }
                                            }
                                            completed()
                                        }
                                    }
                                }
                                
                            }
                            completed()
                        }
                    }
                }
            }
            completed()
        }
    }
    
}
