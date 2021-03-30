//
//  WeatherInfo.swift
//  WeatherDB
//
//  Created by Jennessa Ma on 3/24/21.
//

import UIKit

final class WeatherInfo: UIView {

    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .darkGray
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = .systemFont(ofSize: 13, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let infoLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = .systemFont(ofSize: 30, weight: .semibold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    init(frame: CGRect = .zero, title: String, info: String) {
        super.init(frame: frame)
        titleLabel.text = title.uppercased()
        infoLabel.text = info.uppercased()
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        addSubview(titleLabel)
        addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setInfo(info: String) {
        infoLabel.text = info
    }

}
