//
//  DoctorProfileViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 03/10/2024.
//
import UIKit
import Combine

class DoctorProfileViewController: BaseViewController<DoctorProfileViewModel> {
    // MARK: - Outlets
    @IBOutlet weak var subSpecialityExtenableView: UIView!
    @IBOutlet weak var clinicPhotosPageControl: UIPageControl!
    @IBOutlet weak var clinicPhotosCollectionView: UICollectionView!
    @IBOutlet weak var appointmentsCollectionView: UICollectionView!
    @IBOutlet weak var doctorDetailsView: UIView!
    @IBOutlet weak var doctorSpecialityExtenabaleConstraint: NSLayoutConstraint!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var doctorDetailsStackView: UIStackView!
    @IBOutlet weak var doctorNameLabel: CairoBold!
    @IBOutlet weak var placesToggleSwitch: CustomToggleSwitch!
    @IBOutlet weak var doctorDetailsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var waitingTimeLabel: UILabel!
    @IBOutlet weak var doctorFeesLabel: UILabel!
    @IBOutlet weak var doctorSpecialityLabel: UILabel!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var subSpecialityTextView: UITextView!
    
    // MARK: - Properties
    var coordinator: HomeCoordinatorContact?
    private var isExpanded = false
    private let collapsedHeight: CGFloat = 100
    private var doctorsData: DoctorProfile?
    var doctorFeature: [String] = ["Hygiene", "Good listener"]
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupExpandableView()
        bindAppoinments()
        doctorSpecialityExtenabaleConstraint.constant = self.subSpecialityTextView.contentSize.height + 40
        subSpecialityTextView.isScrollEnabled = false
        subSpecialityExtenableView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureUpperView()
        view.backgroundColor = .greishWhiteF2F2F2
    }
    
    override func bindViewModel() {
        viewModel.fetchDoctorData()
        bindDoctorData()
    }
    
    // MARK: - Setup Methods
    internal override func setupUI() {
        super.setupUI()
        placesToggleSwitch.setToggleOptions(["New Cairo", "Nasr City"])
        ratingView.configure(withRating: 4.5)
        doctorDetailsView.isUserInteractionEnabled = true
        expandButton.addTarget(self, action: #selector(toggleExpandableView), for: .touchUpInside)
    }
    
    private func configureUpperView() {
        upperView.roundCorners(corners: [.bottomLeft, .bottomRight],
                             radius: Dimensions.upperViewBorderRaduis.rawValue)
    }
    
    private func setupExpandableView() {
        doctorDetailsStackView.clipsToBounds = true
    }
    
    private func setupCollectionView() {
        appointmentsCollectionView.registerCell(cellClass: AppointmentsCollectionViewCell.self)
        appointmentsCollectionView.dataSource = self
        appointmentsCollectionView.delegate = self
        
        clinicPhotosCollectionView.registerCell(cellClass: DoctorClinicPhotosCollectionViewCell.self)
        clinicPhotosCollectionView.backgroundColor = .white
        clinicPhotosCollectionView.dataSource = self
        clinicPhotosCollectionView.delegate = self
    }
    
    // MARK: - Data Binding
    private func bindDoctorData() {
        viewModel.$doctorData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] doctor in
                self?.clinicPhotosCollectionView.reloadData()
                self?.doctorsData = doctor
                self?.populateDoctorData()
            }.store(in: &cancellables)
    }
    
    func bindAppoinments() {
        Publishers.CombineLatest(viewModel.$displayedData, viewModel.$generatedDates)
            .receive(on: RunLoop.main)
            .sink { [weak self] _, _ in
                self?.appointmentsCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func populateDoctorData() {
        let doctorData = viewModel.doctorData
        doctorNameLabel.text = doctorData?.name
        doctorFeesLabel.text = doctorData?.price?.prepend("Fees", separator: ": ")
        addressLabel.text = doctorData?.address
        doctorSpecialityLabel.text = doctorData?.descriptionEn
        doctorDetailsLabel.text = doctorData?.titleEn
        
        view.layoutIfNeeded()
        setupExpandableView()
    }
    
    // MARK: - Actions
    @IBAction func loadNextAppoinmentPage(_ sender: Any) {
        viewModel.loadNextData()
        appointmentsCollectionView.reloadData()
    }
    
    @IBAction func backToPreviousAppoinmantPage(_ sender: Any) {
        viewModel.loadPreviousData()
        appointmentsCollectionView.reloadData()
    }
    
    @IBAction func specialityExtendAction(_ sender: Any) {
        subSpecialityExtenableView.isHidden = false
    }
    
    @IBAction func navBack(_ sender: Any) {
        viewModel.coordinator?.navigateBack()
    }
    
    @objc private func toggleExpandableView() {
        isExpanded.toggle()
        UIView.animate(withDuration: 0.3) {
            self.expandButton.isSelected = self.isExpanded
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UICollectionView Extensions
extension DoctorProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == appointmentsCollectionView {
            return viewModel.allGeneratedDates.count
        } else {
            return doctorsData?.images?.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == appointmentsCollectionView {
            let cell = collectionView.dequeue(indexpath: indexPath) as AppointmentsCollectionViewCell
            if indexPath.row < viewModel.allGeneratedDates.count {
                let date = viewModel.allGeneratedDates[indexPath.row]
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                cell.appointDate.text = dateFormatter.string(from: date)
                
                // Configure appointment details if available
                if indexPath.row < viewModel.displayedData.count {
                    let appointment = viewModel.displayedData[indexPath.row]
                 
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeue(indexpath: indexPath) as DoctorClinicPhotosCollectionViewCell
            let doctorClinicsImages = doctorsData?.images?[indexPath.row].image ?? ""
            cell.configureImage(with: doctorClinicsImages)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == appointmentsCollectionView {
            return CGSize(width: collectionView.frame.width * 0.31, height: collectionView.frame.height)
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == appointmentsCollectionView {
            guard let doctor = viewModel.doctorData else {
                // Handle the case where doctorData is nil
                print("Error: Doctor data is unavailable.")
                return
            }

            viewModel.navToAppointmentsScreen(doctor: doctor)
        }
    }
}
