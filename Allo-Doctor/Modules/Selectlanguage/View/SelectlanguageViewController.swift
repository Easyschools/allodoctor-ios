//
//  SelectlanguageViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 02/09/2024.
//

import UIKit

class SelectlanguageViewController: UIViewController {
    enum Language {
        case english
        case arabic
    }
    @IBAction func enlishButtonAction(_ sender: Any) {
        updateButtons(for: .english)
    }
    
    @IBAction func arabicButtonAction(_ sender: Any) {
        updateButtons(for: .arabic)
    }
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var englishButton: CustomButton!
    @IBOutlet weak var arabicButton: CustomButton!
    weak var coordinator: MainCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.setupButton(color: UIColor.blueApp, font: .body, title: "Next",borderColor: UIColor.appColor, textColor: UIColor.white)
        englishButton.setupButton(color: UIColor.white, font: .body, title: "English",borderColor: UIColor.offWhite, textColor: UIColor.black)
        arabicButton.setupButton(color: UIColor.white, font: .body, title: "عربي",borderColor: UIColor.offWhite, textColor: UIColor.black)
    }


}
extension SelectlanguageViewController{
    func updateButtons(for selectedLanguage: Language) {
        switch selectedLanguage {
        case .english:
            englishButton.configureImage(for: .english)
            arabicButton.setupButton(color: .white, font: .body, title: "عربي", borderColor: .offWhite, textColor: .black)
            englishButton.setupButton(color: .appColor, font: .body, title: "English", borderColor: .appColor, textColor: .white)
        case .arabic:
            arabicButton.configureImage(for: .arabic)
            englishButton.setupButton(color: .white, font: .body, title: "English", borderColor: .offWhite, textColor: .black)
            arabicButton.setupButton(color: .appColor, font: .body, title: "عربي", borderColor: .appColor, textColor: .white)
        }
    }
}
