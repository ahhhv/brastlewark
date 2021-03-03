//
//  PeopleCell.swift
//  brastlewark
//
//  Created by Alex Hernández on 27/02/2021.
//

import UIKit

class PeopleCell: UICollectionViewCell {
    
    static let reuseID = "PeopleCell"
    let avatarImageView = BWAvatarImageView(frame: .zero)
    let usernameLabel = BWTitleLabel(textAlignment: .center, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(people: Brastlewark) {
        avatarImageView.downloadImage(id: "\(people.id ?? 0)", fromURL: people.thumbnail ?? "")
        usernameLabel.text = people.name
    }
    
    private func configure() {
        addSubviews(avatarImageView, usernameLabel)
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
