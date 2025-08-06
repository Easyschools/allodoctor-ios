//
//  DoctorSearchCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 23/09/2024.
//

import UIKit
import Kingfisher

class DoctorSearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var reviewsCount: CairoRegular!
    @IBOutlet weak var ratingView: StarRatingView!
    @IBOutlet weak var doctorImage: CircularImageView!
    @IBOutlet weak var doctorName: CairoBold!
    @IBOutlet weak var avalibailtyLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var waitingTime: CairoBold!
    @IBOutlet weak var feesLabel: CairoBold!
    @IBOutlet weak var AdressLabel: CairoBold!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var customAdressLabel: NSLayoutConstraint!
    var resolvedInfoService: InfoService?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension DoctorSearchCollectionViewCell {
    func setupCell(with doctor: DoctorProfile, doctorPlace: DoctorPlace) {
        
        // MARK: - Language Handling
        let isArabic = UserDefaultsManager.sharedInstance.getLanguage() == .ar

        // MARK: - Doctor Name
        doctorName.text = isArabic ? doctor.nameAr : doctor.nameEn

        // MARK: - Availability
        if let day = doctor.appointments?.first?.day {
            let dayName = isArabic ? day.nameAr : day.nameEn
            avalibailtyLabel.text = dayName.prepend(AppLocalizedKeys.availableOn.localized, separator: " ")
        } else {
            avalibailtyLabel.text = AppLocalizedKeys.notAvailable.localized
        }

        // MARK: - Description
        descriptionLabel.text = isArabic ? doctor.titleAr : doctor.titleEn

        // MARK: - Waiting Time
        waitingTime.text = (doctor.waitingTime?.toString() ?? "Zero")
            .appendingWithSpace(AppLocalizedKeys.mintutes.localized)

        // MARK: - Fees
        feesLabel.text = (doctor.price ?? "Free")
            .appendingWithSpace(AppLocalizedKeys.EGP.localized)

        // MARK: - Address (based on doctorPlace)
        var resolvedAddress: String?

        if doctorPlace == .outpatientClinics {
            // Use externalClinicService → infoService.name
            if let services = doctor.doctorServiceSpecialtyIds,
               let matchedService = services.first(where: { $0.externalClinicService != nil }),
               let externalClinic = matchedService.externalClinicService,
               let infoService = externalClinic.infoService {
                
                resolvedAddress = isArabic
                    ? (infoService.nameAr ?? infoService.name)
                    : (infoService.nameEn ?? infoService.name)
            }
        } else {
            // Use doctorServiceSpecialtyIds → infoService.address
            if let specialties = doctor.doctorServiceSpecialtyIds,
               let matchedSpecialty = specialties.first(where: { $0.infoService != nil }),
               let infoService = matchedSpecialty.infoService,
               let address = infoService.address {
                resolvedAddress = address
            }
        }

        // Fallback
        AdressLabel.text = resolvedAddress ?? AppLocalizedKeys.addressNotAvailable.localized

        // MARK: - Reviews Count
        reviewsCount.text = "(\(doctor.reviewsCount?.toString() ?? AppLocalizedKeys.notAvailable.localized))"

        // MARK: - Rating View
        ratingView.configure(rating: doctor.avgRating ?? 0)

        // MARK: - Load Doctor Image
        if let imageUrl = URL(string: doctor.mainImage ?? "") {
            doctorImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholder"))
        }
    }
}
