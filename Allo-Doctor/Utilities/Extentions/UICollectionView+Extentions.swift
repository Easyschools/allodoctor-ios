//
//  UICollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 13/09/2024.
//

import UIKit
extension UICollectionView {
    func registerCell<Cell: UICollectionViewCell>(cellClass: Cell.Type){
        self.register (UINib(nibName: String(describing:Cell.self), bundle:nil),forCellWithReuseIdentifier:String (describing:Cell.self))
    }
    func dequeue<Cell: UICollectionViewCell>(indexpath:IndexPath) -> Cell{
        let identifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: identifier,for:indexpath) as? Cell else {
            fatalError("Error in cell")
        }
        
        return cell
    }
}
