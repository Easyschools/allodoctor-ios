//
//  HospitalFilterViewController.swift
//  Allo-Doctor
//
//  Created for Hospital-First Flow Implementation
//

import UIKit
import Combine

class HospitalFilterViewController: UIViewController {

    // MARK: - Properties
    var currentFilters: HospitalFilterOptions
    var districts: [DistrictFilterOption]
    var specialties: [SpecialtyFilterOption]
    var onFiltersApplied: ((HospitalFilterOptions) -> Void)?

    private var selectedDistricts: Set<Int> = []
    private var selectedSpecialties: Set<Int> = []
    private var selectedMinRating: Double?

    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var districtsCollectionView: UICollectionView!
    @IBOutlet weak var specialtiesCollectionView: UICollectionView!
    @IBOutlet weak var ratingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!

    // MARK: - Initialization
    init(
        currentFilters: HospitalFilterOptions,
        districts: [DistrictFilterOption],
        specialties: [SpecialtyFilterOption]
    ) {
        self.currentFilters = currentFilters
        self.districts = districts
        self.specialties = specialties
        super.init(nibName: "HospitalFilterViewController", bundle: nil)

        // Pre-select current filters
        selectedDistricts = Set(currentFilters.districtIds ?? [])
        selectedSpecialties = Set(currentFilters.specialtyIds ?? [])
        selectedMinRating = currentFilters.minRating
    }

    required init?(coder: NSCoder) {
        self.currentFilters = HospitalFilterOptions()
        self.districts = []
        self.specialties = []
        super.init(coder: coder)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionViews()
    }

    // MARK: - Setup
    private func setupUI() {
        titleLabel?.text = NSLocalizedString("Filter Hospitals", comment: "")
        applyButton?.setTitle(NSLocalizedString("Apply Filters", comment: ""), for: .normal)
        clearButton?.setTitle(NSLocalizedString("Clear All", comment: ""), for: .normal)

        applyButton?.layer.cornerRadius = 8
        clearButton?.layer.cornerRadius = 8

        // Setup rating segmented control
        ratingSegmentedControl?.removeAllSegments()
        ratingSegmentedControl?.insertSegment(withTitle: NSLocalizedString("All", comment: ""), at: 0, animated: false)
        ratingSegmentedControl?.insertSegment(withTitle: "3.0+", at: 1, animated: false)
        ratingSegmentedControl?.insertSegment(withTitle: "4.0+", at: 2, animated: false)
        ratingSegmentedControl?.insertSegment(withTitle: "4.5+", at: 3, animated: false)

        // Set selected segment based on current filter
        if let rating = selectedMinRating {
            switch rating {
            case 3.0:
                ratingSegmentedControl?.selectedSegmentIndex = 1
            case 4.0:
                ratingSegmentedControl?.selectedSegmentIndex = 2
            case 4.5:
                ratingSegmentedControl?.selectedSegmentIndex = 3
            default:
                ratingSegmentedControl?.selectedSegmentIndex = 0
            }
        } else {
            ratingSegmentedControl?.selectedSegmentIndex = 0
        }
    }

    private func setupCollectionViews() {
        districtsCollectionView?.delegate = self
        districtsCollectionView?.dataSource = self
        districtsCollectionView?.registerCell(cellClass: FilterOptionCollectionViewCell.self)
        districtsCollectionView?.tag = 0

        specialtiesCollectionView?.delegate = self
        specialtiesCollectionView?.dataSource = self
        specialtiesCollectionView?.registerCell(cellClass: FilterOptionCollectionViewCell.self)
        specialtiesCollectionView?.tag = 1

        if let layout = districtsCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }

        if let layout = specialtiesCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }

    // MARK: - Actions
    @IBAction func applyFiltersAction(_ sender: Any) {
        var newFilters = currentFilters

        newFilters.districtIds = Array(selectedDistricts)
        newFilters.specialtyIds = Array(selectedSpecialties)
        newFilters.minRating = selectedMinRating

        onFiltersApplied?(newFilters)
        dismiss(animated: true)
    }

    @IBAction func clearFiltersAction(_ sender: Any) {
        selectedDistricts.removeAll()
        selectedSpecialties.removeAll()
        selectedMinRating = nil
        ratingSegmentedControl?.selectedSegmentIndex = 0

        districtsCollectionView?.reloadData()
        specialtiesCollectionView?.reloadData()
    }

    @IBAction func ratingChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedMinRating = nil
        case 1:
            selectedMinRating = 3.0
        case 2:
            selectedMinRating = 4.0
        case 3:
            selectedMinRating = 4.5
        default:
            selectedMinRating = nil
        }
    }
}

// MARK: - UICollectionViewDelegate & DataSource
extension HospitalFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return districts.count
        } else {
            return specialties.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "FilterOptionCollectionViewCell",
            for: indexPath
        ) as? FilterOptionCollectionViewCell else {
            return UICollectionViewCell()
        }

        if collectionView.tag == 0 {
            // Districts
            let district = districts[indexPath.row]
            let isSelected = selectedDistricts.contains(district.id)
            cell.configure(with: district.displayName, isSelected: isSelected)
        } else {
            // Specialties
            let specialty = specialties[indexPath.row]
            let isSelected = selectedSpecialties.contains(specialty.id)
            cell.configure(with: specialty.displayName, isSelected: isSelected)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            // Districts
            let districtId = districts[indexPath.row].id
            if selectedDistricts.contains(districtId) {
                selectedDistricts.remove(districtId)
            } else {
                selectedDistricts.insert(districtId)
            }
        } else {
            // Specialties
            let specialtyId = specialties[indexPath.row].id
            if selectedSpecialties.contains(specialtyId) {
                selectedSpecialties.remove(specialtyId)
            } else {
                selectedSpecialties.insert(specialtyId)
            }
        }

        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - Filter Option Cell
class FilterOptionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        containerView?.layer.cornerRadius = 16
        containerView?.layer.borderWidth = 1
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }

    func configure(with title: String, isSelected: Bool) {
        titleLabel?.text = title

        if isSelected {
            containerView?.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
            containerView?.layer.borderColor = UIColor.systemBlue.cgColor
            titleLabel?.textColor = .systemBlue
        } else {
            containerView?.backgroundColor = .white
            containerView?.layer.borderColor = UIColor.lightGray.cgColor
            titleLabel?.textColor = .darkGray
        }
    }
}
