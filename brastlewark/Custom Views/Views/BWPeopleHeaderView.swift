//
//  BWPeopleHeaderView.swift
//  brastlewark
//
//  Created by Alex Hernández on 01/03/2021.
//

import UIKit

enum FilterType {
    case profession
    case hairColor
}

class BWPeopleHeaderView: UICollectionReusableView {
    
    static var reuseIdentifier: String {
        return String(describing: BWPeopleHeaderView.self)
    }
       
    let stackView = UIStackView(frame: .zero)
    let professionsTextField = BWTextField(frame: .zero)
    let hairColorTextField = BWTextField(frame: .zero)
    let pickerView = BWPickerView()
    
    public let placeholderProfessionsTextField = "Filter by profession"
    public let placeholderHairColorTextField = "Filter by hair color"

    var selectedFilterType: FilterType = .profession
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        addSubviews(stackView, professionsTextField, hairColorTextField)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 5
        
        stackView.addArrangedSubview(professionsTextField)
        stackView.addArrangedSubview(hairColorTextField)

        pickerView.delegate = self
        pickerView.dataSource = self
        
        professionsTextField.placeholder = placeholderProfessionsTextField
        professionsTextField.inputView = pickerView
        professionsTextField.inputAccessoryView = pickerView.toolbar
        professionsTextField.delegate = self
        
        hairColorTextField.placeholder = placeholderHairColorTextField
        hairColorTextField.inputView = pickerView
        hairColorTextField.inputAccessoryView = pickerView.toolbar
        hairColorTextField.delegate = self
                
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            
            professionsTextField.heightAnchor.constraint(equalToConstant: 50),
            hairColorTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension BWPeopleHeaderView: UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let placeholder = textField.placeholder
        selectedFilterType = placeholder == placeholderProfessionsTextField ? .profession : .hairColor
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectedFilterType == .profession ? Profession.allCases.count : HairColor.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectedFilterType == .profession ? Profession.allCases[row].rawValue : HairColor.allCases[row].rawValue.trimmingCharacters(in: .whitespaces)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
