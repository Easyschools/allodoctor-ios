//
//  CustomDropDownList.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 18/09/2024.
//
import UIKit

class CustomDropDownList: UIView {
    
    private let label = UILabel()
    private var arrowImageView = UIImageView(image: UIImage(systemName: "chevron.down"))
    
    var didSelectItem: ((String) -> Void)?
    var items: [String] = []
    
    private var dropdownTableView: UITableView?
    private var dropdownBackgroundView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        
        label.text = "Select city and area"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        addSubview(label)
        
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.tintColor = .black
        addSubview(arrowImageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleDropdown))
        addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13),
            label.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -10),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -13),
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 24),
            arrowImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    @objc private func toggleDropdown() {
        if dropdownTableView == nil {
            showDropdown()
            animateArrow(up: true)  // Rotate the arrow up
        } else {
            hideDropdown()
        }
    }
    
    private func showDropdown() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        
        let backgroundView = UIView(frame: window.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideDropdown))
        backgroundView.addGestureRecognizer(tapGesture)
        window.addSubview(backgroundView)
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add border, corner radius, and shadow to the table view
        tableView.layer.cornerRadius = 10
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOpacity = 0.3
        tableView.layer.shadowOffset = CGSize(width: 0, height: 3)
        tableView.layer.shadowRadius = 4
        tableView.clipsToBounds = false
        
        tableView.backgroundColor = .white
        tableView.isUserInteractionEnabled = true
        
        backgroundView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: bottomAnchor, constant: 5),
            tableView.heightAnchor.constraint(lessThanOrEqualToConstant: 200)
        ])
        
        self.dropdownTableView = tableView
        self.dropdownBackgroundView = backgroundView
        tableView.reloadData()
    }
    
    @objc private func hideDropdown() {
        // Reset arrow direction to point down when dropdown is dismissed
        animateArrow(up: false)
        
        dropdownTableView?.removeFromSuperview()
        dropdownTableView = nil
        dropdownBackgroundView?.removeFromSuperview()
        dropdownBackgroundView = nil
    }
    
    @objc private func cellTapped(_ gesture: UITapGestureRecognizer) {
        guard let cell = gesture.view as? UITableViewCell,
              let tableView = cell.superview as? UITableView,
              let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let selectedItem = items[indexPath.row]
        label.text = selectedItem
        didSelectItem?(selectedItem)
        label.textColor = .black
        hideDropdown()
    }
    
    // Animation function for the arrow
    private func animateArrow(up: Bool) {
        let rotationAngle: CGFloat = up ? .pi : 0
        
        UIView.animate(withDuration: 0.3) {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        }
    }
}

extension CustomDropDownList: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "dropdownCell")
        cell.textLabel?.text = items[indexPath.row]
        
        // Add tap gesture recognizer to the cell
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
        cell.addGestureRecognizer(tapGesture)
        cell.isUserInteractionEnabled = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        label.text = selectedItem
        didSelectItem?(selectedItem)

        hideDropdown()
    }
}
