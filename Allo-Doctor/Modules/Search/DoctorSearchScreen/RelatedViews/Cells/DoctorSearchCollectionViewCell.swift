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
//        contentView.semanticContentAttribute = isArabic ? .forceRightToLeft : .forceLeftToRight

        // MARK: - Doctor Name
        doctorName.text = isArabic ? doctor.nameAr : doctor.nameEn

        // MARK: - Availability
        if let day = doctor.appointments?.first?.day {
            let dayName = isArabic ? day.nameAr : day.nameEn
            avalibailtyLabel.text = dayName.prepend(AppLocalizedKeys.availableOn.localized, separator: " ")
        } else {
            avalibailtyLabel.text = ""
        }

        // MARK: - Description
        descriptionLabel.text = isArabic ? doctor.titleAr : doctor.titleEn

        // MARK: - Waiting Time
        waitingTime.text = (doctor.waitingTime?.toString() ?? "0")
            .appendingWithSpace(AppLocalizedKeys.mintutes.localized)

        // MARK: - Fees
        feesLabel.text = (doctor.price ?? "Free")
            .appendingWithSpace(AppLocalizedKeys.EGP.localized)

        // MARK: - FINAL FIX: Address using SHORT area names (name_en/name_ar)
        AdressLabel.text = getShortLocalizedAddress(for: doctor, doctorPlace: doctorPlace, isArabic: isArabic)

        // MARK: - Reviews Count
        reviewsCount.text = "(\(doctor.reviewsCount?.toString() ?? AppLocalizedKeys.notAvailable.localized))"

        // MARK: - Rating View
        ratingView.configure(rating: doctor.avgRating ?? 0)

        // MARK: - Load Doctor Image
        if let imageUrl = URL(string: doctor.mainImage ?? "") {
            doctorImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholder"))
        }
    }
    private func getShortLocalizedAddress(for doctor: DoctorProfile, doctorPlace: DoctorPlace, isArabic: Bool) -> String {
          
          // STRATEGY: Always use the SHORT area name from name_en/name_ar
          // This prevents text truncation and matches Doctor Profile screen
          
          if doctorPlace == .outpatientClinics {
              // ============================================
              // OUTPATIENT CLINICS: Show clinic location name
              // ============================================
              
              // Try externalClinicService → infoService → name_en/name_ar
              if let services = doctor.doctorServiceSpecialtyIds,
                 let matchedService = services.first(where: { $0.externalClinicService != nil }),
                 let externalClinic = matchedService.externalClinicService,
                 let infoService = externalClinic.infoService {
                  
                  if isArabic {
                      return infoService.nameAr ?? infoService.name ?? AppLocalizedKeys.addressNotAvailable.localized
                  } else {
                      return infoService.nameEn ?? infoService.name ?? AppLocalizedKeys.addressNotAvailable.localized
                  }
              }
              
              // Fallback: Try infoService array
              if let infoServices = doctor.infoService, !infoServices.isEmpty {
                  let firstService = infoServices[0]
                  if isArabic {
                      return firstService.nameAr ?? firstService.name ?? AppLocalizedKeys.addressNotAvailable.localized
                  } else {
                      return firstService.nameEn ?? firstService.name ?? AppLocalizedKeys.addressNotAvailable.localized
                  }
              }
              
          } else {
              // ============================================
              // DOCTOR CLINICS: Show SHORT area name
              // ============================================
              
              // PRIORITY 1: Use doctorServiceSpecialtyIds → infoService → name_en/name_ar
              // This gives us short, clean area names like "Fifth Settlement" or "التجمع الخامس"
              if let specialties = doctor.doctorServiceSpecialtyIds,
                 let matchedSpecialty = specialties.first(where: { $0.infoService != nil }),
                 let infoService = matchedSpecialty.infoService {
                  
                  if isArabic {
                      return infoService.nameAr ?? infoService.name ?? AppLocalizedKeys.addressNotAvailable.localized
                  } else {
                      return infoService.nameEn ?? infoService.name ?? AppLocalizedKeys.addressNotAvailable.localized
                  }
              }
              
              // PRIORITY 2: Use infoService array
              if let infoServices = doctor.infoService, !infoServices.isEmpty {
                  let firstService = infoServices[0]
                  if isArabic {
                      return firstService.nameAr ?? firstService.name ?? AppLocalizedKeys.addressNotAvailable.localized
                  } else {
                      return firstService.nameEn ?? firstService.name ?? AppLocalizedKeys.addressNotAvailable.localized
                  }
              }
              
              // PRIORITY 3: Fallback to doctor_districts if nothing else available
              // (This should rarely happen with the API structure you have)
              if let doctorDistricts = doctor.doctorDistricts, !doctorDistricts.isEmpty {
                  if let districtName = doctorDistricts.first?.district?.name {
                      return districtName
                  }
              }
          }
          
          // ULTIMATE FALLBACK
          return AppLocalizedKeys.addressNotAvailable.localized
      }
    
}
