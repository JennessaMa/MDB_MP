//
//  ViewController.swift
//  Pokedex
//
//  Created by Michael Lin on 2/18/21.
//

import UIKit

class PokedexVC: UIViewController {
    
    let pokemons = PokemonGenerator.shared.getPokemonArray()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.reuseIdentifier)
        return collectionView
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "POKÉDEX"
        lbl.textAlignment = .center
        lbl.textColor = UIColor(red: 20/255, green: 17/255, blue: 15/255, alpha: 1)
        lbl.font = UIFont.boldSystemFont(ofSize: 35)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let toggleView: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
//        b.layer.cornerRadius = 10
//        b.layer.borderWidth = 2
        b.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        b.layer.borderColor = UIColor(red: 27/255, green: 73/255, blue: 101/255, alpha: 1).cgColor
        b.imageView?.tintColor = UIColor(red: 27/255, green: 73/255, blue: 101/255, alpha: 1)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(red: 202/255, green: 233/255, blue: 255/255, alpha: 1)
        view.addSubview(toggleView)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            toggleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            toggleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            toggleView.widthAnchor.constraint(equalTo: toggleView.heightAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 120, left: 30, bottom: 0, right: 30))
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
}

extension PokedexVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pokemon = pokemons[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.reuseIdentifier, for: indexPath) as! PokemonCell
        cell.pokemon = pokemon
        return cell
    }
}

extension PokedexVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 120)
    }
}

