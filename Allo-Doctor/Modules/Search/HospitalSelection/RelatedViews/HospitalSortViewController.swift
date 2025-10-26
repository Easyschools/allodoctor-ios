//
//  HospitalSortViewController.swift
//  Allo-Doctor
//
//  Created for Hospital-First Flow Implementation
//

import UIKit

class HospitalSortViewController: UIViewController {

    // MARK: - Properties
    var currentSort: HospitalSortOption
    var onSortSelected: ((HospitalSortOption) -> Void)?

    private let sortOptions = HospitalSortOption.allCases

    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sortTableView: UITableView!

    // MARK: - Initialization
    init(currentSort: HospitalSortOption) {
        self.currentSort = currentSort
        super.init(nibName: "HospitalSortViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.currentSort = .name
        super.init(coder: coder)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }

    // MARK: - Setup
    private func setupUI() {
        titleLabel?.text = NSLocalizedString("Sort By", comment: "")
    }

    private func setupTableView() {
        sortTableView?.delegate = self
        sortTableView?.dataSource = self
        sortTableView?.registerCell(cellClass: SortOptionTableViewCell.self)
        sortTableView?.separatorStyle = .none
        sortTableView?.isScrollEnabled = false
    }
}

// MARK: - UITableViewDelegate & DataSource
extension HospitalSortViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "SortOptionTableViewCell",
            for: indexPath
        ) as? SortOptionTableViewCell else {
            return UITableViewCell()
        }

        let sortOption = sortOptions[indexPath.row]
        let isSelected = sortOption == currentSort

        cell.configure(with: sortOption.displayName, isSelected: isSelected)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedOption = sortOptions[indexPath.row]
        onSortSelected?(selectedOption)

        dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - Sort Option Cell
class SortOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkmarkImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        selectionStyle = .none
        titleLabel?.font = UIFont.systemFont(ofSize: 16)
        checkmarkImageView?.image = UIImage(systemName: "checkmark")
        checkmarkImageView?.tintColor = .systemBlue
    }

    func configure(with title: String, isSelected: Bool) {
        titleLabel?.text = title
        checkmarkImageView?.isHidden = !isSelected
        titleLabel?.textColor = isSelected ? .systemBlue : .darkGray
        titleLabel?.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 16)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        checkmarkImageView?.isHidden = true
        titleLabel?.textColor = .darkGray
        titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
}
