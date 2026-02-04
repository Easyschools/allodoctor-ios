//
//  DoctorProfileViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 03/10/2024.
//
import UIKit
import Kingfisher
class DoctorProfileViewController: BaseViewController<DoctorProfileViewModel> {
    @IBOutlet weak var insuranceStack: UIStackView!
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
    private var selectedSpecialtyIndex: Int = 0
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    // MARK: - Life Cycle
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        // FIXED: Toggle switch callback with proper address localization
        placesToggleSwitch.onToggle = { [weak self] index in
            guard let self = self else { return }
            
            // Store the selected index
            self.selectedSpecialtyIndex = index
            
            // Reset the view model or any relevant state
            viewModel.reset()
            
            // Update the address based on the selected index and doctor place
            let selectedSpecialty = viewModel.doctorData?.doctorServiceSpecialtyIds?[index]
            
            // FIXED: Address localization based on device language
            let isArabic = UserDefaultsManager.sharedInstance.getLanguage() == .ar
            
            if viewModel.doctorPlace == .outpatientClinics {
                // Use external clinic service address
                addressLabel.text = selectedSpecialty?.externalClinicService?.address
            } else {
                // Use info service address with proper localization
                addressLabel.text = selectedSpecialty?.infoService?.address
            }
            
            // Generate the new data for the collection view
            appointments = viewModel.generateNextThreeDates(
                from: viewModel.doctorData?.doctorServiceSpecialtyIds?[index].appointments ?? []
            )
                addressLabel.text = self.getAddressForSelectedLocation(isArabic: isArabic)
                
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
    
    private func getAddressForSelectedLocation(isArabic: Bool) -> String {
        guard let doctorData = viewModel.doctorData else { return "" }
        
        let selectedSpecialty = doctorData.doctorServiceSpecialtyIds?[selectedSpecialtyIndex]
        
        // Try to get detailed address from doctor_districts
        if let infoServiceId = selectedSpecialty?.infoService?.id {
            // Match by district id
            if let matchingDistrict = doctorData.doctorDistricts?.first(where: {
                $0.district?.id == infoServiceId
            }) {
                return matchingDistrict.address ?? ""
            }
        }
        
        // Fallback to info_service name
        if isArabic {
            return selectedSpecialty?.infoService?.nameAr ?? ""
        } else {
            return selectedSpecialty?.infoService?.nameEn ?? ""
        }
    }
    
    // MARK: - Data Binding
    // MARK: - Data Binding
    private func bindDoctorData() {
        viewModel.$doctorData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] doctor in
                self?.clinicPhotosCollectionView.reloadData()
                self?.doctorsData = doctor
                self?.populateDoctorData()
                
                // Check doctorPlace to determine toggle switch options
                if self?.viewModel.doctorPlace == .outpatientClinics {
                    // Use external clinics for outpatient clinics
                    if let doctorServiceSpecialtyIds = self?.viewModel.doctorData?.doctorServiceSpecialtyIds {
                        let externalClinicNames = doctorServiceSpecialtyIds.compactMap { specialty in
                            if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
                                return specialty.externalClinicService?.infoService?.nameAr
                            } else {
                                return specialty.externalClinicService?.infoService?.nameEn
                            }
                        }.filter { !$0.isEmpty } // Filter out empty names
                        
                        self?.placesToggleSwitch.setToggleOptions(externalClinicNames.isEmpty ? ["Not Available"] : externalClinicNames)
                    } else {
                        self?.placesToggleSwitch.setToggleOptions(["Not Available"])
                    }
                } else {
                    // Use info services for doctor clinics (existing logic)
                    if let doctorServiceSpecialtyIds = self?.viewModel.doctorData?.doctorServiceSpecialtyIds {
                        let infoServices = doctorServiceSpecialtyIds.compactMap { specialty in
                            if UserDefaultsManager.sharedInstance.getLanguage() == .ar {
                                return specialty.infoService?.nameAr
                            } else {
                                return specialty.infoService?.nameEn
                            }
                        }.filter { !$0.isEmpty } // Filter out empty names
                        
                        self?.placesToggleSwitch.setToggleOptions(infoServices.isEmpty ? ["Not Available"] : infoServices)
                    } else {
                        self?.placesToggleSwitch.setToggleOptions(["Not Available"])
                    }
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
    
    // MARK: - FIXED: populateDoctorData with proper address localization
    private func populateDoctorData() {
        let doctorData = viewModel.doctorData
        
        if let imageUrl = URL(string: doctorData?.mainImage ?? "") {
            doctorPhoto.kf.setImage(with: imageUrl)
        }
        
        if let insurances = viewModel.doctorData?.medicalInsurance, !insurances.isEmpty {
            insuranceStack.isHidden = false
        } else {
            insuranceStack.isHidden = true
        }
        
        if doctorData?.images?.count == 0 {
            clinicPhotosStackView.isHidden = true
        }
        
        ratingView.configure(withRating: doctorData?.avgRating ?? 0)
        ratingCount.text = (doctorData?.reviewsCount?.toString().prepend("(") ?? "0")+")"
        
        // FIXED: Proper address localization
        let isArabic = UserDefaultsManager.sharedInstance.getLanguage() == .ar
        
        if isArabic {
            doctorNameLabel.text = doctorData?.nameAr
            doctorFeesLabel.text = doctorData?.price?.prepend(AppLocalizedKeys.fees.localized, separator: ": ").appendingWithSpace(AppLocalizedKeys.EGP.localized)
            doctorSpecialityLabel.text = doctorData?.descriptionAr
            doctorDetailsLabel.text = doctorData?.titleAr
            waitingTimeLabel.text = doctorData?.waitingTime.map { $0.toString().appendingWithSpace(AppLocalizedKeys.waitingTime.localized) } ?? ""
            
            // FIXED: Address in Arabic
            if viewModel.doctorPlace == .outpatientClinics {
                addressLabel.text = doctorData?.doctorServiceSpecialtyIds?.first?.externalClinicService?.address
            } else {
                addressLabel.text = doctorData?.doctorServiceSpecialtyIds?.first?.infoService?.address
            }
            addressLabel.text = getAddressForSelectedLocation(isArabic: true)

            setupMedicalInsuranceText(isArabic: true)
            
        } else {
            doctorNameLabel.text = doctorData?.nameEn
            doctorFeesLabel.text = doctorData?.price?.prepend(AppLocalizedKeys.fees.localized, separator: ": ").appendingWithSpace(AppLocalizedKeys.EGP.localized)
            doctorSpecialityLabel.text = doctorData?.descriptionEn
            doctorDetailsLabel.text = doctorData?.titleEn
            waitingTimeLabel.text = doctorData?.waitingTime.map { $0.toString().appendingWithSpace(AppLocalizedKeys.waitingTime.localized) } ?? ""
            
            // FIXED: Address in English
            if viewModel.doctorPlace == .outpatientClinics {
                addressLabel.text = doctorData?.doctorServiceSpecialtyIds?.first?.externalClinicService?.address
            } else {
                addressLabel.text = doctorData?.doctorServiceSpecialtyIds?.first?.infoService?.address
            }
            addressLabel.text = getAddressForSelectedLocation(isArabic: false)

            setupMedicalInsuranceText(isArabic: false)
        }
        
        appointments = viewModel.generateNextThreeDates(from: viewModel.doctorData?.doctorServiceSpecialtyIds?[0].appointments ?? [])
        
        ChooseYourAppointmentLabel.text = AppLocalizedKeys.ChooseYourAppointment.localized
        appointmentsCollectionView.reloadData()
        
        view.layoutIfNeeded()
    }



    // MARK: - Medical Insurance Setup (Names Only)
    private func setupMedicalInsuranceText(isArabic: Bool) {
        guard let medicalInsurance = viewModel.doctorData?.medicalInsurance,
              !medicalInsurance.isEmpty else {
            subSpecialityExtenableView.isHidden = true
            return
        }
        
        let headerText = isArabic ? "التأمينات المقبولة:" : "Accepted Insurance:"
        
        let insuranceNames = medicalInsurance.compactMap { insurance in
            isArabic ? insurance.nameAr : insurance.nameEn
        }.filter { !$0.isEmpty } // Filter out empty names
        
        guard !insuranceNames.isEmpty else {
            insuranceStack.isHidden = true
            return
        }
        
        let insuranceText = headerText + "\n" + insuranceNames.joined(separator: " • ")
        
        subSpecialityTextView.text = insuranceText
        subSpecialityTextView.sizeToFit()
        doctorSpecialityExtenabaleConstraint.constant = subSpecialityTextView.contentSize.height + 40
//        subSpecialityExtenableView.isHidden = false
    }

    
    // MARK: - Actions
    @IBAction func loadNextAppoinmentPage(_ sender: Any) {
        if let nextAppointments = viewModel.getNextAppointments() {
            appointments = nextAppointments
            appointmentsCollectionView.reloadData()
        }
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
            
            let isArabic = UserDefaultsManager.sharedInstance.getLanguage() == .ar
            
            guard let appointment = appointments?[indexPath.row] else {
                return cell
            }
            
            // Format date as dd/MM (day/month without year)
            let formattedDate: String
            if let dateString = appointment.day.date,
               let date = dateFormatter.date(from: dateString) {
                let displayFormatter = DateFormatter()
                displayFormatter.dateFormat = "dd/MM" // e.g., "31/01" or "03/02"
                formattedDate = displayFormatter.string(from: date)
            } else {
                formattedDate = isArabic ? "غير متوفر" : "Not Available"
            }
            
            if isArabic {
                let dayName = appointment.day.nameAr.replacingOccurrences(of: "\n", with: "")
                
                // Display: Day name on first line, date (dd/MM) on second line
                cell.appointDate.text = "\(dayName)\n\(formattedDate)"
                cell.appointDate.numberOfLines = 2
                cell.appointDate.textAlignment = .center
                
                // Show ALL available hours
                let hours = appointment.hour.compactMap { $0.from?.convertTo12HourFormat() }
                let hoursText = hours.isEmpty ? "غير متوفر" : hours.joined(separator: ", ")
                
                cell.fromHour.text = "من: \(hoursText)"
                cell.ToHour.text = "" // Clear the "To" field since we're showing all hours in "From"
                
            } else {
                let dayName = appointment.day.nameEn
                
                // Display: Day name on first line, date (dd/MM) on second line
                cell.appointDate.text = "\(dayName)\n\(formattedDate)"
                cell.appointDate.numberOfLines = 2
                cell.appointDate.textAlignment = .center
                
                // Show ALL available hours
                let hours = appointment.hour.compactMap { $0.from?.convertTo12HourFormat() }
                let hoursText = hours.isEmpty ? "Not Available" : hours.joined(separator: ", ")
                
                cell.fromHour.text = "From: \(hoursText)"
                cell.ToHour.text = "" // Clear the "To" field since we're showing all hours in "From"
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
                print("Error: Doctor data is unavailable.")
                return
            }
            
            let day = appointments?[indexPath.row].day.nameEn ?? ""
            let date = appointments?[indexPath.row].day.date ?? "Not Available"
            
            // Get the selected toggle switch index to determine which specialty was chosen
            let selectedSpecialtyIndex = placesToggleSwitch.selectedIndex
            let selectedSpecialtyId = doctor.doctorServiceSpecialtyIds?[selectedSpecialtyIndex].id ?? 0
            
            viewModel.navToAppointmentsScreen(
                doctor: doctor,
                date: date,
                day: day,
                doctorServiceSpecialityId: selectedSpecialtyId
            )
        }
    }
}
