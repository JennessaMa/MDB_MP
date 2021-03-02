//
//  CollectionVC.swift
//  SFSymbolCollection
//
//  Created by Michael Lin on 2/22/21.
//

import UIKit

class CollectionVC: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 30
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(SymbolCollectionCell.self, forCellWithReuseIdentifier: SymbolCollectionCell.reuseIdentifier)
        return collectionView
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 30
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SymbolCollectionCell.self, forCellWithReuseIdentifier: SymbolCollectionCell.resuseIdentifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 88, left: 30, bottom: 0, right: 30))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
    }
}

<<<<<<< HEAD
=======
        view.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.1058823529, blue: 0.1098039216, alpha: 1)
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 88, left: 30, bottom: 0, right: 30))

        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

>>>>>>> 3b0b5b6a0078fb39ff030eff8b83bdb0b04116c7
extension CollectionVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SymbolProvider.symbols.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let symbol = SymbolProvider.symbols[indexPath.item]
<<<<<<< HEAD
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SymbolCollectionCell.resuseIdentifier, for: indexPath) as! SymbolCollectionCell
        
=======
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SymbolCollectionCell.reuseIdentifier, for: indexPath) as! SymbolCollectionCell
>>>>>>> 3b0b5b6a0078fb39ff030eff8b83bdb0b04116c7
        cell.symbol = symbol
        return cell
    }
}

extension CollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100)
    }
<<<<<<< HEAD
=======
    
>>>>>>> 3b0b5b6a0078fb39ff030eff8b83bdb0b04116c7
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let symbol = SymbolProvider.symbols[indexPath.item]
        
        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: {
            return SymbolPreviewVC(symbol: symbol)
        }, actionProvider: { _ in
<<<<<<< HEAD
            let okItem = UIAction(title: "OK", image: UIImage(systemName: "arrow.down.right.and.arrow.up.left"), identifier: nil, discoverabilityTitle: nil,  handler: { _ in})
            return UIMenu(title: "", image: nil , identifier: nil , children: [okItem])
=======
            let okItem = UIAction(title: "OK", image: UIImage(systemName: "arrow.down.right.and.arrow.up.left"), identifier: nil, discoverabilityTitle: nil, handler: { _ in})
            return UIMenu(title: "", image: nil, identifier: nil, children: [okItem])
>>>>>>> 3b0b5b6a0078fb39ff030eff8b83bdb0b04116c7
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected")
    }
}

