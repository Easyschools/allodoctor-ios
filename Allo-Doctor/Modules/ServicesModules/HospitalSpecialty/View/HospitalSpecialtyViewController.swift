//
//  HospitalSpecialtyViewController.swift
//  Allo-Doctor
//
//  Created for Hospital-First Flow Implementation
//

import UIKit
import Combine

class HospitalSpecialtyViewController: BaseViewController<HospitalSpecialtyViewModel> {

    // MARK: - IBOutlets
    @IBOutlet weak var specialtyNameLabel: UILabel!
    @IBOutlet weak var specialtyDescriptionLabel: UILabel!
    @IBOutlet weak var doctorsCountLabel: UILabel!
    @IBOutlet weak var doctorsTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noResultsStackView: UIStackView!
    @IBOutlet weak var navBackButton: CustomNavigationBackButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()
        setupNavigationBar()
        setupLabels()
        setupTableView()
    }

    override func bindViewModel() {
        super.bindViewModel()
        bindSpecialtyDetail()
        bindDoctors()
        bindLoadingState()
        bindErrorState()

        // Initial fetch
        viewModel.fetchSpecialtyDetail()
    }

    // MARK: - Setup Methods
    private func setupNavigationBar() {
        navBackButton?.setTitle(NSLocalizedString("Specialty Details", comment: ""))
    }

    private func setupLabels() {
        specialtyNameLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        specialtyNameLabel?.textColor = .black

        specialtyDescriptionLabel?.font = UIFont.systemFont(ofSize: 14)
        specialtyDescriptionLabel?.textColor = .darkGray
        specialtyDescriptionLabel?.numberOfLines = 0

        doctorsCountLabel?.font = UIFont.systemFont(ofSize: 14)
        doctorsCountLabel?.textColor = .systemBlue
    }

    private func setupTableView() {
        doctorsTableView?.delegate = self
        doctorsTableView?.dataSource = self
        doctorsTableView?.registerCell(cellClass: SpecialtyDoctorTableViewCell.self)
        doctorsTableView?.separatorStyle = .none
        doctorsTableView?.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 12, right: 0)
    }

    // MARK: - Binding Methods
    private func bindSpecialtyDetail() {
        viewModel.$specialtyDetail
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] detail in
                self?.updateSpecialtyUI(with: detail)
            }
            .store(in: &cancellables)
    }

    private func bindDoctors() {
        viewModel.$doctors
            .receive(on: DispatchQueue.main)
            .sink { [weak self] doctors in
                self?.updateDoctorsUI(isEmpty: doctors.isEmpty)
                self?.doctorsTableView?.reloadData()
            }
            .store(in: &cancellables)
    }

    private func bindLoadingState() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator?.startAnimating()
                    self?.doctorsTableView?.isHidden = true
                } else {
                    self?.loadingIndicator?.stopAnimating()
                    self?.doctorsTableView?.isHidden = false
                }
            }
            .store(in: &cancellables)
    }

    private func bindErrorState() {
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] errorMessage in
                self?.showErrorAlert(message: errorMessage)
            }
            .store(in: &cancellables)
    }

    // MARK: - Update UI
    private func updateSpecialtyUI(with detail: HospitalSpecialtyDetail) {
        specialtyNameLabel?.text = viewModel.getSpecialtyName()
        specialtyDescriptionLabel?.text = viewModel.getSpecialtyDescription()

        let count = detail.doctors.count
        doctorsCountLabel?.text = "\(count) " +
            (count == 1 ? NSLocalizedString("Doctor", comment: "") : NSLocalizedString("Doctors", comment: ""))
    }

    private func updateDoctorsUI(isEmpty: Bool) {
        noResultsStackView?.isHidden = !isEmpty
        doctorsTableView?.isHidden = isEmpty
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: NSLocalizedString("Error", comment: ""),
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
        present(alert, animated: true)
    }

    // MARK: - IBActions
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.coordinator?.navigateBack()
    }
}

// MARK: - UITableViewDelegate & DataSource
extension HospitalSpecialtyViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.doctors.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "SpecialtyDoctorTableViewCell",
            for: indexPath
        ) as? SpecialtyDoctorTableViewCell else {
            return UITableViewCell()
        }

        guard let doctor = viewModel.doctors[safe: indexPath.row] else {
            return cell
        }

        cell.configure(with: doctor, viewModel: viewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let doctor = viewModel.doctors[safe: indexPath.row] else {
            return
        }

        viewModel.navigateToDoctorProfile(doctorId: doctor.id)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - Specialty Doctor Cell
class SpecialtyDoctorTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var doctorImageView: UIImageView!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var doctorTitleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var waitingTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        selectionStyle = .none

        containerView?.layer.cornerRadius = 12
        containerView?.layer.shadowColor = UIColor.black.cgColor
        containerView?.layer.shadowOpacity = 0.1
        containerView?.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView?.layer.shadowRadius = 4
        containerView?.backgroundColor = .white

        doctorImageView?.layer.cornerRadius = 30
        doctorImageView?.clipsToBounds = true
        doctorImageView?.contentMode = .scaleAspectFill

        doctorNameLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        doctorTitleLabel?.font = UIFont.systemFont(ofSize: 14)
        doctorTitleLabel?.textColor = .gray
        ratingLabel?.font = UIFont.systemFont(ofSize: 13)
        priceLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        priceLabel?.textColor = .systemGreen
        experienceLabel?.font = UIFont.systemFont(ofSize: 12)
        experienceLabel?.textColor = .gray
        waitingTimeLabel?.font = UIFont.systemFont(ofSize: 12)
        waitingTimeLabel?.textColor = .systemOrange
    }

    func configure(with doctor: SpecialtyDoctor, viewModel: HospitalSpecialtyViewModel) {
        doctorNameLabel?.text = viewModel.getDoctorDisplayName(for: doctor)
        doctorTitleLabel?.text = viewModel.getDoctorTitle(for: doctor)

        if let imageURL = doctor.mainImage {
            doctorImageView?.loadImage(from: imageURL)
        } else {
            doctorImageView?.image = UIImage(systemName: "person.circle.fill")
        }

        if let rating = doctor.rate {
            ratingLabel?.text = "⭐ " + viewModel.formatRating(rating)
            if let count = doctor.reviewsCount {
                reviewsCountLabel?.text = "(\(count))"
            }
        }

        priceLabel?.text = viewModel.formatPrice(doctor.price, discounted: doctor.priceAfterDiscount)

        if let experience = doctor.experience {
            experienceLabel?.text = experience + " " + NSLocalizedString("Experience", comment: "")
        }

        if let waitingTime = doctor.waitingTime {
            waitingTimeLabel?.text = NSLocalizedString("Wait:", comment: "") + " \(waitingTime) " + NSLocalizedString("min", comment: "")
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        doctorImageView?.image = nil
        doctorNameLabel?.text = nil
        doctorTitleLabel?.text = nil
        ratingLabel?.text = nil
        reviewsCountLabel?.text = nil
        priceLabel?.text = nil
        experienceLabel?.text = nil
        waitingTimeLabel?.text = nil
    }
}
