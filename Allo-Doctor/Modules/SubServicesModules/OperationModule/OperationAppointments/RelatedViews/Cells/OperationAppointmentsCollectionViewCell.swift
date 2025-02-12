//
//  OperationAppointmentsCollectionViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 17/11/2024.
//

import UIKit
class OperationAppointmentsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var workingHoursLabel: CairoRegular!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak private var day: CairoRegular!
    @IBOutlet weak private var fromTo: UILabel!
    @IBOutlet weak private var date: CairoRegular!

    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    override func layoutSubviews() {
        self.applyDropShadow()
    }
    func setupCell(day: String, fromTo: String, date: String,isAvailable:Bool) {
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            self.date.text = date.toArabicDate()
            self.day.text = day.convertDayToArabic()
        }
        else{
           
            self.day.text = day
            self.date.text = date
        }
        self.workingHoursLabel.text = AppLocalizedKeys.WorkingHours.localized

        self.fromTo.text = fromTo
        if isAvailable == false {
            self.isUserInteractionEnabled = false
            selectButton.backgroundColor = .grey6B7280
            upperView.backgroundColor = .grey6B7280
        }
        else{
            selectButton.backgroundColor = .blueApp
            upperView.backgroundColor = .blueApp
        }
    }

}
