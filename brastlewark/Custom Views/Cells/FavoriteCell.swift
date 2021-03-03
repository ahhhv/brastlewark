//
//  FavoriteCell.swift
//  brastlewark
//
//  Created by Alex Hernández on 28/02/2021.
//

import UIKit

class FavoriteCell: UITableViewCell {

    static let reuseID = "FavoriteCell"
    let avatarImageView = BWAvatarImageView(frame: .zero)
    let nameLabel = BWTitleLabel(textAlignment: .left, fontSize: 26)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(favorite: Brastlewark) {
        avatarImageView.downloadImage(id: "\(favorite.id ?? 0)", fromURL: favorite.thumbnail ?? "")
        nameLabel.text = favorite.name
    }
    
    private func configure() {
        addSubviews(avatarImageView, nameLabel)

        selectionStyle = .none
        accessoryType = .disclosureIndicator

        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
