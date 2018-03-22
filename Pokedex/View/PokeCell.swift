//
//  PokeCell.swift
//  Pokedex
//
//  Created by Lukáš Růžička on 22.03.18.
//  Copyright © 2018 Lukáš Růžička. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var pokeImage: UIImageView!
    @IBOutlet weak var pokeName: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 10.0
    }
    
    func configureCell(pokemon: Pokemon) {
        self.pokemon = pokemon
        
        pokeName.text = self.pokemon.name.capitalized
        pokeImage.image = UIImage(named: "\(self.pokemon.id)")
    }
    
}
