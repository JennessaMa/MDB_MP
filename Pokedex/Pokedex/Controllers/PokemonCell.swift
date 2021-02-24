//
//  PokemonCell.swift
//  Pokedex
//
//  Created by Jennessa Ma on 2/23/21.
//

import UIKit

class PokemonCell: UICollectionViewCell {
    static let reuseIdentifier: String = String(describing: PokemonCell.self)
    
    var pokemon: Pokemon? {
        didSet {
            //https://cocoacasts.com/fm-3-download-an-image-from-a-url-in-swift
            print(pokemon?.imageUrl ?? "NO URL PROVIDED")
            if let url: URL = URL(string: (pokemon?.imageUrl)!) {
                if let data = try? Data(contentsOf: url) {
                        imageView.image = UIImage(data: data)
                    }
            }
            
            let name: String = pokemon?.name ?? ""
            let id: Int = pokemon?.id ?? 0
            infoView.text = "\(name) (\(id))"
            //infoView.text = "\(pokemon?.name ?? "") \(pokemon?.id ?? "")"
        }
    }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let infoView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        //label.textColor = UIColor(red: 126/255, green: 127/255, blue: 131/255, alpha: 1)
        label.textColor = UIColor(red: 60/255, green: 60/255, blue: 62/255, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 202/255, green: 233/255, blue: 255/255, alpha: 1)
        contentView.backgroundColor = UIColor(red: 202/255, green: 233/255, blue: 255/255, alpha: 1)
        
        contentView.addSubview(imageView)
        contentView.addSubview(infoView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: infoView.topAnchor, constant: -5),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            infoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
