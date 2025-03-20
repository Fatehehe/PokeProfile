//
//  CustomCell.swift
//  PokeProfile
//
//  Created by Fatakhillah Khaqo on 20/03/25.
//

import UIKit

class CustomCell: UITableViewCell {
    static let identifier = "CustomCell"
    
    private let myImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "questionmark")
        iv.tintColor = .label
        return iv
    }()
    
    private let mylabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.text = "Error"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with image: UIImage, and label: String){
        self.myImageView.image = image
        self.mylabel.text = label
    }
    
    private func setupUI(){
        self.contentView.addSubview(myImageView)
        self.contentView.addSubview(mylabel)
        
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        mylabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myImageView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            myImageView.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            myImageView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            
//            myImageView.heightAnchor.constraint(equalToConstant: 90),
            myImageView.widthAnchor.constraint(equalToConstant: 90),
            
            mylabel.leadingAnchor.constraint(equalTo: myImageView.trailingAnchor, constant: 16),
            mylabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12 ),
            mylabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            mylabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor ),
            
        ])
    }
}
