//
//  CustomDropDown.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 23/11/2024.
//

import UIKit

class DropdownView: UIView {
    
    // MARK: - Publishers
    private let selectionSubject = PassthroughSubject<String, Never>()
    var selectionPublisher: AnyPublisher<String, Never> {
        selectionSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Properties
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .grey6B7280
        return label
    }()
    
    private let arrowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        button.setImage(UIImage(systemName: "chevron.down", withConfiguration: config), for: .normal)
        button.tintColor = .blueApp
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 8
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.lighrGreyF2F2F2.cgColor
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private lazy var backgroundOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var items: [String] = []
    private var isOpen = false
    private var tableViewHeightConstraint: NSLayoutConstraint?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - State
    @Published private var selectedItem: String?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupBindings()
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.lighrGreyF2F2F2.cgColor
        
        // Add views to window
        if let window = UIApplication.shared.windows.first {
            window.addSubview(backgroundOverlay)
            window.addSubview(tableView)
            
            // Setup background overlay to cover the entire window
            backgroundOverlay.frame = window.bounds
        }
        
        addSubview(label)
        addSubview(arrowButton)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupConstraints()
        setupArrowButton()
    }
    
    private func setupBindings() {
        $selectedItem
            .compactMap { $0 }
            .sink { [weak self] item in
                self?.label.text = item
                self?.selectionSubject.send(item)
            }
            .store(in: &cancellables)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Label constraints
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.trailingAnchor.constraint(equalTo: arrowButton.leadingAnchor, constant: -8),
            
            // Arrow button constraints
            arrowButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            arrowButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowButton.widthAnchor.constraint(equalToConstant: 20),
            arrowButton.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    private func setupArrowButton() {
        arrowButton.addTarget(self, action: #selector(handleArrowTap), for: .touchUpInside)
    }
    
    private func updateTableViewFrame() {
        guard let window = UIApplication.shared.windows.first else { return }
        let globalPoint = convert(bounds, to: window)
        
        tableView.frame = CGRect(
            x: globalPoint.minX,
            y: globalPoint.maxY + 4,
            width: globalPoint.width,
            height: CGFloat(270)
        )
    }
    
    // MARK: - Public Methods
    func configure(with items: [String], placeholder: String = "Select an option") {
        self.items = items
        self.label.text = placeholder
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    @objc private func handleArrowTap() {
        toggleDropdown()
    }
    
    @objc private func handleBackgroundTap() {
        if isOpen {
            toggleDropdown()
        }
    }
    
    func toggleDropdown() {
        isOpen.toggle()
        
        if isOpen {
            updateTableViewFrame()
            backgroundOverlay.isHidden = false
            
            // Ensure the tableView is above the overlay
            if let window = UIApplication.shared.windows.first {
                window.bringSubviewToFront(tableView)
            }
        } else {
            backgroundOverlay.isHidden = true
        }
        
        UIView.animate(withDuration: 0.3) {
            self.tableView.isHidden = !self.isOpen
            self.arrowButton.transform = self.isOpen ? CGAffineTransform(rotationAngle: .pi) : .identity
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !tableView.isHidden {
            let convertedPoint = convert(point, to: tableView)
            if tableView.bounds.contains(convertedPoint) {
                return tableView.hitTest(convertedPoint, with: event)
            }
        }
        return super.hitTest(point, with: event)
    }
}

// MARK: - UITableViewDataSource
extension DropdownView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DropdownView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = items[indexPath.row]
        toggleDropdown()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension DropdownView {
    func cleanup() {
        // Reset UI state
        isOpen = false
        selectedItem = nil
        
        // Clear data
        items = []
        
        // Remove observers
        NotificationCenter.default.removeObserver(self)
        
        // Complete and clear publisher
//        selectionPublisher.send(completion: .finished)
    }
}
class DropDownWithImage: UIView {

    // MARK: - Publishers
    private let selectionSubject = PassthroughSubject<[String: Any], Never>()
    var selectionPublisher: AnyPublisher<[String: Any], Never> {
        selectionSubject.eraseToAnyPublisher()
    }

    // MARK: - Properties
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private let arrowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        button.setImage(UIImage(systemName: "chevron.down", withConfiguration: config), for: .normal)
        button.tintColor = .blue
        return button
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 8
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.lighrGreyF2F2F2.cgColor
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = .white
        return tableView
    }()

    private var items: [[String: Any]] = []
    private var isOpen = false
    private var cancellables = Set<AnyCancellable>()

    // MARK: - State
    @Published private var selectedItem: [String: Any]?

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupBindings()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupBindings()
    }

    // MARK: - Setup
    private func setupView() {
        backgroundColor = .white

        addSubview(imageView)
        addSubview(label)
        addSubview(arrowButton)

        // Add tableView to window when needed
        if let window = UIApplication.shared.windows.first {
            window.addSubview(tableView)
            tableView.isHidden = true
        }

        tableView.dataSource = self
        tableView.delegate = self

        setupConstraints()
        setupArrowButton()
    }

    private func setupBindings() {
        $selectedItem
            .compactMap { $0 }
            .sink { [weak self] item in
                if let name = item["name"] as? String {
                    self?.label.text = name
                }
                self?.selectionSubject.send(item)
            }
            .store(in: &cancellables)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ImageView constraints
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20),

            // Label constraints
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.trailingAnchor.constraint(equalTo: arrowButton.leadingAnchor, constant: -8),

            // Arrow button constraints
            arrowButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            arrowButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowButton.widthAnchor.constraint(equalToConstant: 20),
            arrowButton.heightAnchor.constraint(equalToConstant: 20),
        ])
    }

    private func setupArrowButton() {
        arrowButton.addTarget(self, action: #selector(handleArrowTap), for: .touchUpInside)
    }

    private func updateTableViewFrame() {
        guard let window = UIApplication.shared.windows.first else { return }
        let globalPoint = convert(bounds, to: window)

        tableView.frame = CGRect(
            x: globalPoint.minX,
            y: globalPoint.maxY + 4,
            width: globalPoint.width,
            height: min(CGFloat(items.count * 50), 270) // Adjust for item count
        )
    }

    // MARK: - Public Methods
    func configure(with items: [[String: Any]], placeholder: String = "Select an option", image: UIImage?) {
        self.items = items
        self.label.text = placeholder
        self.imageView.image = image
        self.tableView.reloadData()
    }

    // MARK: - Actions
    @objc private func handleArrowTap() {
        toggleDropdown()
    }

    private func toggleDropdown() {
        isOpen.toggle()

        if isOpen {
            updateTableViewFrame()
            UIApplication.shared.windows.first?.bringSubviewToFront(tableView)
        }

        UIView.animate(withDuration: 0.3) {
            self.tableView.isHidden = !self.isOpen
            self.arrowButton.transform = self.isOpen ? CGAffineTransform(rotationAngle: .pi) : .identity
        }
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !tableView.isHidden {
            let convertedPoint = convert(point, to: tableView)
            if tableView.bounds.contains(convertedPoint) {
                return tableView.hitTest(convertedPoint, with: event)
            }
        }
        return super.hitTest(point, with: event)
    }
}

// MARK: - UITableViewDataSource
extension DropDownWithImage: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item["name"] as? String
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DropDownWithImage: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = items[indexPath.row]
        toggleDropdown()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func dismissDropdownIfNeeded() {
        if isOpen {
            isOpen = false
            UIView.animate(withDuration: 0.3) {
                self.tableView.isHidden = true
                self.arrowButton.transform = .identity
            }
        }
    }

}
