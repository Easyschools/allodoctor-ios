//
//  MyActivityTableViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 10/11/2024.
//

import UIKit

class MyActivityTableViewCell: UITableViewCell {
    @IBOutlet weak var appointmentName: UILabel!
    @IBOutlet weak var appointmentImage: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusColor: CircularImageView!
    @IBOutlet weak var appointmentDate: CairoRegular!
    @IBOutlet weak var appointmentNo: CairoRegular!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 11, bottom: 10, right: 11))
        contentView.applyDropShadow()
    }
    func setupCell(name: String, date: String, appointmentNumber: String, image: UIImage?,status:String) {
        // Set the content
        appointmentName.text = name
        appointmentDate.text = date
        appointmentNo.text = appointmentNumber
        appointmentImage.image = image ?? UIImage(named: "default_appointment")
        setupStatus(status: status)
        
    }
    
  private func setupStatus(status:String){
      if status == "Confirmed" {
            statusColor.backgroundColor = .green4D932C
          statusLabel.text = AppLocalizedKeys.confirmed.localized
        }
        else if status == "Canceled" {
            statusColor.backgroundColor = .redD32F2F
            statusLabel.text = AppLocalizedKeys.cancelled.localized
        }
        else {
             statusColor.backgroundColor = .appColor
             statusLabel.text = AppLocalizedKeys.pending.localized
         }
    }
}
