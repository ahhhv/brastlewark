//
//  PeopleDetailVC.swift
//  brastlewark
//
//  Created by Alex Hernández on 27/02/2021.
//
import UIKit


class PeopleDetailVC: UIViewController {
    
    let avatarImageView = BWAvatarImageView(frame: .zero)
    let nameLabel = BWTitleLabel(textAlignment: .center, fontSize: 28)
    let ageLabel = BWSecondaryTitleLabel(fontSize: 18)
    let weightLabel = BWSecondaryTitleLabel(fontSize: 18)
    let heightLabel = BWSecondaryTitleLabel(fontSize: 18)
    let hairColorLabel = BWSecondaryTitleLabel(fontSize: 18)
    let professionsLabel = BWSecondaryTitleLabel(fontSize: 18)
    let friendsLabel = BWSecondaryTitleLabel(fontSize: 18)
    let addFavoriteButton = BWButton(frame: .zero)
    var isFavorite = false
    
    var brastlewark: Brastlewark!
    
    init(brastlewark: Brastlewark) {
        super.init(nibName: nil, bundle: Bundle.main)
        self.brastlewark = brastlewark
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(avatarImageView, nameLabel, ageLabel, weightLabel, heightLabel, hairColorLabel, professionsLabel, friendsLabel, addFavoriteButton)
        layoutUI()
        checkUpIfIsFavorite()
        configureUIElements()
        setupTopRightButton()
    }
    
    fileprivate func checkUpIfIsFavorite() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let favorites):
                if favorites.filter({$0 == self.brastlewark}).count > .zero {
                    self.isFavorite = true
                }
                
            case .failure(_):
                self.addFavoriteButton.isHidden = true
            }
        }
    }
    
    fileprivate func setupTopRightButton() {
        if isModal {
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
            navigationItem.rightBarButtonItem = doneButton
        }
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    fileprivate func setupProfessionsLabel() {
        var strings = [String]()
        guard let professions = brastlewark.professions, !professions.isEmpty else {
            professionsLabel.text = "Professions: has not found a fitting job yet :-("
            return
        }
        
        if let professions = brastlewark.professions {
            for profession in professions {
                strings.append(profession.rawValue)
            }
        }
        
        strings = strings.map { return $0.trimmingCharacters(in: .whitespaces) }
        var attributes = [NSAttributedString.Key: Any]()
        attributes[.font] = UIFont.systemFont(ofSize: 18, weight: .medium)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        attributes[.paragraphStyle] = paragraphStyle
        
        let string = strings.joined(separator: ", ")
        professionsLabel.attributedText = NSAttributedString(string: "Professions: " + string, attributes: attributes)
        professionsLabel.numberOfLines = 0
    }
    
    func configureUIElements() {
        avatarImageView.downloadImage(id: "\(brastlewark.id ?? 0)", fromURL: brastlewark.thumbnail ?? "")
        let name = brastlewark.name ?? "gnoname me with no name"
        nameLabel.text = name
        ageLabel.text = "Age: \(brastlewark.age ?? 0) years"
        weightLabel.text = "Weight: \(String(format: "%.2f", brastlewark.weight ?? "N/A")) pounds"
        heightLabel.text = "Height: \(String(format: "%.2f", brastlewark.weight ?? "N/A")) meters"
        hairColorLabel.text = "Hair color: \(brastlewark.hairColor ?? .black)"
        setupProfessionsLabel()
        friendsLabel.text = brastlewark.friends?.isEmpty ?? false ? "Friends: no small friends yet :(" : "Friends: \(brastlewark.friends?.joined(separator: ", ") ?? "")"
        friendsLabel.numberOfLines = .zero
        
        if !self.isModal {
            addFavoriteButton.isHidden = true
        }
        
        addFavoriteButton.set(backgroundColor: isFavorite ? .systemRed : .systemGreen, title: isFavorite ? "Remove favorite" : "Add favorite")
        addFavoriteButton.setTitleColor(isFavorite ? .white : .black, for: .normal)
        addFavoriteButton.addTarget(self, action: #selector(addUserToFavorites), for: .touchUpInside)
    }
    
    
    @objc
    func addUserToFavorites() {
        PersistenceManager.updateWith(favorite: brastlewark, actionType: isFavorite ? .remove : .add) { [weak self] error in
            guard let self = self else { return }
            
            guard let error = error else {
                let message = self.isFavorite ? "You have successfully removed this small person as favorite 💔" : "You have successfully favorited this small person 🎉"
                self.presentBWAlertOnMainThread(title: "Success!", message: message, buttonTitle: "Hooray!")
                self.dismissVC()
                
                return
            }
            
            self.presentBWAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
    func layoutUI() {
        view.backgroundColor = .systemBackground
        let padding: CGFloat = 20
        let textImagePadding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: textImagePadding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -textImagePadding),
            nameLabel.heightAnchor.constraint(equalToConstant: 38),
            
            ageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding),
            ageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            weightLabel.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: padding),
            weightLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            heightLabel.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: padding),
            heightLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            hairColorLabel.topAnchor.constraint(equalTo: heightLabel.bottomAnchor, constant: padding),
            hairColorLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            professionsLabel.topAnchor.constraint(equalTo: hairColorLabel.bottomAnchor, constant: padding),
            professionsLabel.leadingAnchor.constraint(equalTo: hairColorLabel.leadingAnchor),
            professionsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            friendsLabel.topAnchor.constraint(equalTo: professionsLabel.bottomAnchor, constant: padding),
            friendsLabel.leadingAnchor.constraint(equalTo: professionsLabel.leadingAnchor),
            friendsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            addFavoriteButton.topAnchor.constraint(equalTo: friendsLabel.bottomAnchor, constant: 30),
            addFavoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addFavoriteButton.widthAnchor.constraint(equalToConstant: 200),
            addFavoriteButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
