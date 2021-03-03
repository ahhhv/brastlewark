//
//  UITableView+Ext.swift
//  brastlewark
//
//  Created by Alex Hernández on 28/02/2021.
//

import UIKit

extension UITableView {
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
