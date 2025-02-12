//
//  UITableView+Extentions.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 19/09/2024.
//

import UIKit

extension UITableView {
    // Generic method to register a UITableViewCell using its class name
    func registerCell<Cell: UITableViewCell>(cellClass: Cell.Type) {
        self.register(UINib(nibName: String(describing: Cell.self), bundle: nil), forCellReuseIdentifier: String(describing: Cell.self))
    }

    // Generic method to dequeue a UITableViewCell using its class type
    func dequeue<Cell: UITableViewCell>(indexPath: IndexPath) -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("Error in dequeuing cell with identifier: \(identifier)")
        }
        return cell
    }
}
public extension UITableView {
    func addFooterSpinnerView(spinnerColor: UIColor) {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 50))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        spinner.color = spinnerColor
        footerView.addSubview(spinner)
        footerView.layoutIfNeeded()
        spinner.startAnimating()
        
        tableFooterView = footerView
    }}
