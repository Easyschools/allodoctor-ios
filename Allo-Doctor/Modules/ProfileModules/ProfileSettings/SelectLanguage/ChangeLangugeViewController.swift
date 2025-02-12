//
//  ChangeLangugeViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 21/12/2024.
//

import UIKit

class ChangeLangugeViewController: UIViewController {

    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var arabicEclipseImage: UIImageView!
    @IBOutlet weak var englishEclipseImage: UIImageView!
    @IBOutlet weak var confirmButton: CustomButton!
   private var selectedLanguage :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.isUserInteractionEnabled = false
        confirmButton.backgroundColor = .grey6B7280
        languageLabel.text = AppLocalizedKeys.language.localized
    }

    @IBAction func dimissAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func confirmationButtonAction(_ sender: Any) {
        if selectedLanguage == Language.arabic.rawValue{
            LocalizationManager.shared.setLanguage(language: .arabic, fromTabBar: false)
            UserDefaultsManager.sharedInstance.setLanguage(language: .ar)
        }
        else
        {
            LocalizationManager.shared.setLanguage(language: .english, fromTabBar: false)
            UserDefaultsManager.sharedInstance.setLanguage(language: .en)
        }
    }
    @IBAction func setArabicAction(_ sender: Any) {
        confirmButton.isUserInteractionEnabled = true
        confirmButton.backgroundColor = .blueApp
        arabicEclipseImage.image = .eclipseFilled
        englishEclipseImage.image = .eclipse
        selectedLanguage = Language.arabic.rawValue
        
    }
    @IBAction func setEnglishAction(_ sender: Any) {
        confirmButton.isUserInteractionEnabled = true
        confirmButton.backgroundColor = .blueApp
        arabicEclipseImage.image = .eclipse
        englishEclipseImage.image = .eclipseFilled
        selectedLanguage = Language.english.rawValue
    }
    
   

}
