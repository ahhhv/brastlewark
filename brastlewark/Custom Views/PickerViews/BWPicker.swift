//
//  BWPicker.swift
//  brastlewark
//
//  Created by Alex Hernández on 01/03/2021.
//

import UIKit

protocol BWPickerViewDelegate: AnyObject {
    func didTapDone(selectedRow: Int)
    func didTapCancel()
}

class BWPickerView: UIPickerView {

    public private(set) var toolbar: UIToolbar?
    public weak var toolbarDelegate: BWPickerViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100.0, height: 44.0))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTapped))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        self.toolbar = toolBar
    }

    @objc func doneTapped() {
        self.toolbarDelegate?.didTapDone(selectedRow: selectedRow(inComponent: 0))
    }

    @objc func cancelTapped() {
        self.toolbarDelegate?.didTapCancel()
    }
}

