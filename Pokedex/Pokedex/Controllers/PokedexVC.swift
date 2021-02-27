//
//  ViewController.swift
//  Pokedex
//
//  Created by Michael Lin on 2/18/21.
//

import UIKit

class PokedexVC: UIViewController {
    
    //some pokemon links arent working (i.e. pikipek, pulu something) so images may not match pokemon
    
    //boolean to see if view should be in nx2 view or regular row layout
    //starts out in row layout
    var inGridView: Bool = false
    
    //let pokemons = PokemonGenerator.shared.getPokemonArray()
    var pokemons = PokemonGenerator.shared.getPokemonArray()
    
    let types: [String] = ["All", "Bug", "Grass","Dark","Ground", "Dragon", "Electric", "Normal", "Fairy", "Poison", "Fighting", "Psychic", "Fire", "Rock", "Flying", "Steel","Ghost","Water","Unknown"]

    var currTypes: [String]?
    
    var currSelectedType: String = "All"
    
    var currPokemons: [Pokemon]?
    
    var copyCurrPokemons: [Pokemon]?
    
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
//        b.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        b.setPreferredSymbolConfiguration(symbolConfig, forImageIn: .normal)
        //b.layer.borderColor = UIColor(red: 27/255, green: 73/255, blue: 101/255, alpha: 1).cgColor
        b.imageView?.tintColor = UIColor(red: 27/255, green: 73/255, blue: 101/255, alpha: 1)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(red: 202/255, green: 233/255, blue: 255/255, alpha: 1)
        view.addSubview(toggleView)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        
        toggleView.addTarget(self, action: #selector(didTapToggle(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            toggleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            toggleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            toggleView.widthAnchor.constraint(equalTo: toggleView.heightAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 230, left: 30, bottom: 0, right: 30))
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        
        //search bar stuff
        searchBar = UISearchBar.init(frame: .zero)
        searchBar.setShowsCancelButton(true, animated: false)
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        let safeArea = view.safeAreaInsets
        //let searchBarSTF = searchBar.sizeThatFits(CGSize.init(width: view.bounds.width - 50, height: 30))
        searchBar.frame = CGRect.init(x: view.bounds.width/8, y: safeArea.top + 120, width: view.bounds.width / 4 * 3, height: 30)
        //searchBar.tintColor = .blue
        searchBar.barTintColor = UIColor(red: 202/255, green: 233/255, blue: 255/255, alpha: 1)
        searchBar.placeholder = "Search for a pokemon..."
        searchBar.showsCancelButton = true
        searchBar.showsScopeBar = true
        currPokemons = pokemons
        copyCurrPokemons = currPokemons
        currTypes = types
        searchBar.scopeButtonTitles = currTypes
        //cancel button is transparent idk whyyyyyyy
    }
    
    @objc func didTapToggle(_ sender: UIButton) {
        if inGridView {
            inGridView = false
            toggleView.backgroundColor = .clear
            toggleView.imageView?.tintColor = UIColor(red: 27/255, green: 73/255, blue: 101/255, alpha: 1)
            
        } else {
            inGridView = true
            toggleView.backgroundColor = UIColor(red: 27/255, green: 73/255, blue: 101/255, alpha: 1)
            toggleView.imageView?.tintColor = .white
            toggleView.layer.cornerRadius = 10
        }
        collectionView.performBatchUpdates(nil, completion: nil)
        //print("inGridView is now \(inGridView)")
    }
}


extension PokedexVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currPokemons!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pokemon = currPokemons?[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.reuseIdentifier, for: indexPath) as! PokemonCell
        cell.pokemon = pokemon
        return cell
    }
}

extension PokedexVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if inGridView {
            return CGSize(width: view.frame.width / 3, height: view.frame.width / 3)
        }
        return CGSize(width: 100, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemon = currPokemons?[indexPath.item]
        let details = DetailsVC()
        details.pokemon = pokemon
        present(details, animated: true, completion: nil)
    }
}

extension PokedexVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //filter pokemons based on string
        currPokemons = pokemons.filter({ p in
            p.name.contains(searchText)
        })
        if currPokemons?.count == 0 {
            currPokemons = PokemonGenerator.shared.getPokemonArray()
        }

        //if user selected a type, filter another layer for that type
        if (currSelectedType != "All") {
            currPokemons = currPokemons?.filter({ p in
                for t in p.types {
                    if t.rawValue == currSelectedType {
                        return true
                    }
                }
                return false
            })
        }

        //update scope filters
        var newScopeArr: [String] = ["All"]
        for p in currPokemons! {
            for t in p.types {
                newScopeArr.append(t.rawValue)
            }
        }
        let newScopeSet = Set(newScopeArr) //get rid of duplicates
        currTypes = Array(newScopeSet)
        searchBar.scopeButtonTitles = currTypes
        copyCurrPokemons = currPokemons
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //reset all filters by hitting cancel button
//        collectionView.performBatchUpdates({currPokemons = pokemons
//                                            currTypes = types
//                                            searchBar.scopeButtonTitles = currTypes
//                                            currSelectedType = "All"}, completion: nil)
        currPokemons = pokemons
        currTypes = types
        searchBar.scopeButtonTitles = currTypes
        currSelectedType = "All"
        collectionView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //filter even more based on original string
        currSelectedType = currTypes![selectedScope]
//        collectionView.performBatchUpdates({
//            if (currSelectedType == "All") {
//                currPokemons = copyCurrPokemons
//            } else {
//                var newPokemons: [Pokemon] = []
//                for i in 0..<(copyCurrPokemons!.count) {
//                    let p: Pokemon = copyCurrPokemons![i]
//                    for t in p.types {
//                        if (t.rawValue == currSelectedType) {
//                            newPokemons.append(p)
//                        }
//                    }
//                }
//                currPokemons = newPokemons
//            }
//        }, completion: nil)
        if (currSelectedType == "All") {
            currPokemons = copyCurrPokemons
        } else {
            var newPokemons: [Pokemon] = []
            for i in 0..<(copyCurrPokemons!.count) {
                let p: Pokemon = copyCurrPokemons![i]
                for t in p.types {
                    if (t.rawValue == currSelectedType) {
                        newPokemons.append(p)
                    }
                }
            }
            currPokemons = newPokemons
        }
        collectionView.reloadData()
    }
}
