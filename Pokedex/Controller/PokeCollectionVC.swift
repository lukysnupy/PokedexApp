//
//  ViewController.swift
//  Pokedex
//
//  Created by Lukáš Růžička on 21.03.18.
//  Copyright © 2018 Lukáš Růžička. All rights reserved.
//

import UIKit

class PokeCollectionVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var pokeCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokeCollection.dataSource = self
        pokeCollection.delegate = self
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            let pokemon = Pokemon(name: "Pokemon", id: indexPath.row + 1)
            cell.configureCell(pokemon: pokemon)
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 115)
    }
}

