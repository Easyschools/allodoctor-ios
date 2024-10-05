//
//  DoctorProfileViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 03/10/2024.
//
import UIKit

class DoctorProfileViewController: BaseViewController<DoctorProfileViewModel> {
    @IBOutlet weak var clinicPhotosCollectionView: UICollectionView!
    @IBOutlet weak var appointmentsCollectionView: UICollectionView!
    @IBOutlet weak var doctorDetailsView: UIView!
    @IBOutlet weak var doctorDetailsExtendableHeight: NSLayoutConstraint!
    @IBOutlet weak var ratingView: RatingView!

    @IBOutlet weak var doctorNameLabel: CairoSemiBold!
    @IBOutlet weak var extendedView: UIView!
    @IBOutlet weak var placesToggleSwitch: CustomToggleSwitch!
    @IBOutlet weak var backButton: CustomNavigationBackButton!
    @IBOutlet weak var doctorDetailsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var waitingTimeLabel: UILabel!
    @IBOutlet weak var doctorFeesLabel: UILabel!
    @IBOutlet weak var doctorSpecialityLabel: UILabel!
    @IBOutlet weak var upperView: UIView!
   
    var coordinator: HomeCoordinatorContact?
    private var isExtendedViewVisible = false
    private var extendedViewHeight: CGFloat = 0
    private var doctorsData: DoctorData?
    var doctorFeature:[String] = ["Hygiene","Good listener"]
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
    }
    
    override func bindViewModel() {
        viewModel.fetchDoctorData()
        bindDoctorData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureUpperView()
        updateExtendedViewHeight()
        view.backgroundColor = .greishWhiteF2F2F2
    }

    // MARK: - Setup Methods
    internal override func setupUI() {
        super.setupUI()
        placesToggleSwitch.setToggleOptions(["New Cairo", "Nasr City"])
        backButton.setTitle("Doctor Profile")
        ratingView.configure(withRating: 4 )
       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleExtendedView))
        doctorDetailsView.addGestureRecognizer(tapGesture)
        doctorDetailsView.isUserInteractionEnabled = true
    }

    private func configureUpperView() {
        upperView.roundCorners(corners: [.bottomLeft, .bottomRight],
                               radius: Dimensions.upperViewBorderRaduis.rawValue)
        if extendedViewHeight == 0 {
            extendedView.isHidden = true
            updateExpandableHeight(animated: false)
        }
    }

    private func populateDoctorData() {
        let doctorData = viewModel.doctorData
        doctorNameLabel.text = doctorData?.name
        doctorFeesLabel.text = doctorData?.price.prepend("Fees", separator: ": ")
        waitingTimeLabel.text = doctorData?.waitngTime?.prepend("Waiting Time", separator: ": ") ?? "Waiting Time: 30 min"
        addressLabel.text = doctorData?.address
//        doctorSpecialityLabel.text = doctorData?.titleEn
        doctorDetailsLabel.text = doctorData?.descriptionEn
    }

    private func updateExtendedViewHeight() {
        let sizeThatFits = doctorDetailsLabel.sizeThatFits(CGSize(width: extendedView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        extendedViewHeight = sizeThatFits.height + 20 // Add some padding
    }

    // MARK: - Action Methods
    @IBAction func navBack(_ sender: Any) {
        viewModel.coordinator?.navigateBack()
    }

    @IBAction func extendedButtonAction(_ sender: Any) {
        toggleExtendedView()
    }

    @objc private func toggleExtendedView() {
        isExtendedViewVisible.toggle()
        updateExtendedViewHeight()
        updateExpandableHeight(animated: true)
    }

    private func updateExpandableHeight(animated: Bool) {
        let baseHeight = doctorDetailsView.bounds.height - (isExtendedViewVisible ? extendedViewHeight : 0)
        let newHeight = baseHeight + (isExtendedViewVisible ? extendedViewHeight : 0)

        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.doctorDetailsExtendableHeight.constant = newHeight
                self.extendedView.isHidden = !self.isExtendedViewVisible
                self.view.layoutIfNeeded()
            })
        } else {
            doctorDetailsExtendableHeight.constant = newHeight
            extendedView.isHidden = !isExtendedViewVisible
            view.layoutIfNeeded()
        }
    }
}

// MARK: - UICollectionView Delegate & Data Source
extension DoctorProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == appointmentsCollectionView {
            return doctorsData?.appointments?.count ?? 0
        } else {
            return doctorsData?.images.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == appointmentsCollectionView {
            let cell = collectionView.dequeue(indexpath: indexPath) as AppointmentsCollectionViewCell
            guard let appointment = doctorsData?.appointments?[indexPath.row] else {
                cell.fromHour.text = "N/A"
                cell.appointDate.text = "N/A"
                cell.ToHour.text = "N/A"
                return cell
            }
            cell.fromHour.text = appointment.hour.from.prepend("From ")
            cell.appointDate.text = appointment.day.name
            cell.ToHour.text = appointment.hour.to.prepend("To ")
            return cell
        } else {
            let cell = collectionView.dequeue(indexpath: indexPath) as DoctorClinicPhotosCollectionViewCell
            let doctorClinicsImages = doctorsData?.images[indexPath.row].image ?? ""
            cell.configureImage(with: doctorClinicsImages)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == appointmentsCollectionView {
            return CGSize(width: collectionView.frame.width * 0.315, height: collectionView.frame.height)
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }

    func setupCollectionView() {
        appointmentsCollectionView.registerCell(cellClass: AppointmentsCollectionViewCell.self)
        appointmentsCollectionView.dataSource = self
        appointmentsCollectionView.delegate = self
        clinicPhotosCollectionView.registerCell(cellClass: DoctorClinicPhotosCollectionViewCell.self)
        clinicPhotosCollectionView.backgroundColor = .white
        clinicPhotosCollectionView.dataSource = self
        clinicPhotosCollectionView.delegate = self
    }

    func bindDoctorData() {
        viewModel.$doctorData.receive(on: DispatchQueue.main)
            .sink { [weak self] doctor in
                self?.appointmentsCollectionView.reloadData()
                self?.clinicPhotosCollectionView.reloadData()
                self?.doctorsData = doctor
                self?.populateDoctorData()
            }.store(in: &cancellables)
    }
}
