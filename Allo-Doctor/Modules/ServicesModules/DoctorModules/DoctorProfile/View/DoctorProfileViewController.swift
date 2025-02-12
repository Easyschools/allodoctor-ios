//
//  DoctorProfileViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 03/10/2024.
//
import UIKit
import Kingfisher
class DoctorProfileViewController: BaseViewController<DoctorProfileViewModel> {
    // MARK: - Outlets
    @IBOutlet weak var ratingCount: CairoRegular!
    @IBOutlet weak var clinicPhotosStackView: UIStackView!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var ChooseYourAppointmentLabel: CairoMeduim!
    @IBOutlet weak var subSpecialityExtenableView: UIView!
    @IBOutlet weak var doctorPhoto: CircularImageView!
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
    private var appointments:[DoctorAppointment]?
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        placesToggleSwitch.onToggle = { [weak self] index in
            guard let self = self else { return }
            
            // Reset the view model or any relevant state
            viewModel.reset()
            
            // Generate the new data for the collection view
            appointments = viewModel.generateNextThreeDates(
                from: viewModel.doctorData?.doctorServiceSpecialtyIds?[index].appointments ?? []
            )
         
            // Reload the collection view with the new data
            DispatchQueue.main.async {
                self.appointmentsCollectionView.reloadData()
            }
        }
        doctorSpecialityExtenabaleConstraint.constant = self.subSpecialityTextView.contentSize.height + 40
        subSpecialityTextView.isScrollEnabled = false
        subSpecialityExtenableView.isHidden = true
    }
    
    @IBAction func descriptionExtendAction(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.doctorDetailsView.alpha = self.doctorDetailsView.isHidden ? 1 : 0
        } completion: { _ in
            self.doctorDetailsView.isHidden.toggle()
        }
    }


    @IBAction func addToFavAction(_ sender: Any) {
        if heartButton.tag == 0 {
                  // Switch to filled heart
            heartButton.setImage(UIImage.heartFilled, for: .normal)
                  heartButton.tag = 1
              } else {
                  // Switch back to unfilled heart
                  heartButton.setImage(UIImage.heart, for: .normal)
                  heartButton.tag = 0
              }
        viewModel.addToFav()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureUpperView()
        view.backgroundColor = .greishWhiteF2F2F2
    }
    
    override func bindViewModel() {
        viewModel.fetchDoctorData()
        bindDoctorData()
        bindAppoinments()
        viewModel.fetchDoctorFavourite()
    }
    
    // MARK: - Setup Methods
    internal override func setupUI() {
        super.setupUI()
        
        ratingView.configure(withRating: doctorsData?.avgRating ?? 0)
        doctorDetailsView.isUserInteractionEnabled = true

    }
    
    private func configureUpperView() {
        upperView.roundCorners(corners: [.bottomLeft, .bottomRight],
                             radius: Dimensions.upperViewBorderRaduis.rawValue)
    }
    
    
    private func setupCollectionView() {
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            appointmentsCollectionView.semanticContentAttribute = .forceRightToLeft}
        else{appointmentsCollectionView.semanticContentAttribute = .forceLeftToRight}
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
                
                if let doctorServiceSpecialtyIds = self?.viewModel.doctorData?.doctorServiceSpecialtyIds {
                    
                    let infoServices = doctorServiceSpecialtyIds.compactMap {
                        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{ $0.infoService?.nameAr }
                        else{
                            $0.infoService?.nameEn }}
                
                    self?.placesToggleSwitch.setToggleOptions(infoServices.isEmpty ? ["Not Available"] : infoServices)
                } else {
                    self?.placesToggleSwitch.setToggleOptions(["Not Available"])
                }



            }.store(in: &cancellables)
    }
    

    func bindAppoinments() {
        viewModel.$displayedData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self = self else { return }
                
                appointmentsCollectionView.reloadData()
            }
            .store(in: &cancellables)
        viewModel.$favData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self = self else { return }
                
                // Safely check if `data` is non-nil and contains at least one element
                if let firstItem = data?.first, firstItem.id != nil {
                    self.heartButton.setImage(.heartFilled, for: .normal)
                } else {
                    // Optional: Set the button to an unselected state if no valid data is found
                    self.heartButton.setImage(.heart, for: .normal)
                }
            }
            .store(in: &cancellables)

    }
    
    private func populateDoctorData() {
        let doctorData = viewModel.doctorData
        if let imageUrl = URL(string: doctorData?.mainImage ?? "") {
            doctorPhoto.kf.setImage(with: imageUrl)
        }
        if doctorData?.images?.count == 0 {
            clinicPhotosStackView.isHidden = true
        }
        ratingView.configure(withRating: doctorData?.avgRating ?? 0)
        ratingCount.text = (doctorData?.reviewsCount?.toString().prepend("(") ?? "0")+")"
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            doctorNameLabel.text = doctorData?.nameAr
            doctorFeesLabel.text = doctorData?.price?.prepend(AppLocalizedKeys.fees.localized, separator: ": ").appendingWithSpace(AppLocalizedKeys.EGP.localized)
            addressLabel.text = doctorData?.address
            doctorSpecialityLabel.text = doctorData?.descriptionAr
            doctorDetailsLabel.text = doctorData?.titleAr
            waitingTimeLabel.text = doctorData?.waitingTime?.toString().appendingWithSpace(AppLocalizedKeys.waitingTime.localized) 
            appointments = viewModel.generateNextThreeDates(from: viewModel.doctorData?.doctorServiceSpecialtyIds?[0].appointments ?? [])}
        else{
            doctorNameLabel.text = doctorData?.nameEn
            doctorFeesLabel.text = doctorData?.price?.prepend(AppLocalizedKeys.fees.localized, separator: ": ").appendingWithSpace(AppLocalizedKeys.EGP.localized)
            addressLabel.text = doctorData?.address
            doctorSpecialityLabel.text = doctorData?.descriptionEn
            doctorDetailsLabel.text = doctorData?.titleEn
            waitingTimeLabel.text = doctorData?.waitingTime?.toString().appendingWithSpace(AppLocalizedKeys.waitingTime.localized)
            appointments = viewModel.generateNextThreeDates(from: viewModel.doctorData?.doctorServiceSpecialtyIds?[0].appointments ?? [])}
        ChooseYourAppointmentLabel.text = AppLocalizedKeys.ChooseYourAppointment.localized
        appointmentsCollectionView.reloadData()
        
        view.layoutIfNeeded()

    }
    
    // MARK: - Actions
    @IBAction func loadNextAppoinmentPage(_ sender: Any) {
        appointments = viewModel.generateNextThreeDates(from: viewModel.doctorData?.doctorServiceSpecialtyIds?[0].appointments ?? [])
        appointmentsCollectionView.reloadData()
    }
    
    @IBAction func backToPreviousAppoinmantPage(_ sender: Any) {
        if let previousAppointments = viewModel.getPreviousAppointments() {
                   appointments = previousAppointments
                   appointmentsCollectionView.reloadData()
               }
    }
    
    @IBAction func specialityExtendAction(_ sender: Any) {
        subSpecialityExtenableView.isHidden.toggle()
    }
    
    @IBAction func navBack(_ sender: Any) {
        viewModel.coordinator?.navigateBack()
    }
    
}

// MARK: - UICollectionView Extensions
extension DoctorProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == appointmentsCollectionView {
            return appointments?.count ?? 0
        } else {
            return doctorsData?.images?.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == appointmentsCollectionView {
            let cell = collectionView.dequeue(indexpath: indexPath) as AppointmentsCollectionViewCell
            if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
                let day = appointments?[indexPath.row].day.nameAr ?? ""
                let date =
                (appointments?[indexPath.row].day.date?.convertDateFormat() ?? "Not Available" ).prepend(day, separator: " ")
                cell.appointDate.text = date
                cell.fromHour.text = (appointments?[indexPath.row].hour[0].from.convertTo12HourFormat() ?? "Not Available").prepend(AppLocalizedKeys.From.localized)
                cell.ToHour.text = (appointments?[indexPath.row].hour[0].to.convertTo12HourFormat() ?? "Not Available").prepend(AppLocalizedKeys.To.localized)
            }
            else{
                let day = appointments?[indexPath.row].day.nameEn ?? ""
                let date =
                (appointments?[indexPath.row].day.date?.convertDateFormat() ?? "Not Available" ).prepend(day, separator: " ")
                cell.appointDate.text = date
                cell.fromHour.text = (appointments?[indexPath.row].hour[0].from.convertTo12HourFormat() ?? "Not Available").appendingWithSpace(AppLocalizedKeys.From.localized)
                cell.ToHour.text = (appointments?[indexPath.row].hour[0].to.convertTo12HourFormat() ?? "Not Available").appendingWithSpace(AppLocalizedKeys.To.localized)
            }
//            let date =
//            (appointments?[indexPath.row].day.date?.convertDateFormat() ?? "Not Available" ).prepend(day, separator: " ")
         
         
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
                print("Error: Doctor data is unavailable.")
                return
            }
            let day = appointments?[indexPath.row].day.nameEn ?? ""
            let date = appointments?[indexPath.row].day.date ?? "Not Available"
            viewModel.navToAppointmentsScreen(doctor: doctor, date: date, day: day, doctorServiceSpecialityId: doctor.doctorServiceSpecialtyIds?[0].id ?? 0)
        }
    }
}
