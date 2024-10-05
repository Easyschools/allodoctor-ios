//
//  SelectlanguageViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 02/09/2024.
//

import UIKit

class SelectlanguageViewController: BaseViewController<SelectlanguageViewModel> {
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var arabicUiview: UIView!
    @IBOutlet weak var SelectLanguageLabel: UILabel!
  
    @IBOutlet weak var englishUIview: UIView!
    
    @IBOutlet weak var arabicLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
   
    @IBAction func enlishButtonAction(_ sender: Any) {
        SelectLanguageLabel.textAlignment = .left
        arabicUiview.backgroundColor = .white
        englishUIview.backgroundColor = .appColor
        nextButton.setupButton(color: .appColor, title: "Next", borderColor: .appColor, textColor: .white)
        englishLabel.textColor = .white
        arabicLabel.textColor = .black
        SelectLanguageLabel.text = "Select language"
        viewDidLayoutSubviews()
    }
    
    @IBAction func NextAction(_ sender: Any) {
        viewModel.goToBordingScreen()
    }
    @IBAction func arabicButtonAction(_ sender: Any) {
        arabicUiview.backgroundColor = .appColor
        englishUIview.backgroundColor = .white
        nextButton.setupButton(color: .appColor, title: "تاكيد", borderColor: .appColor, textColor: .white)
        englishLabel.textColor = .black
        arabicLabel.textColor = .white
        SelectLanguageLabel.text = "اختر اللغه"
        SelectLanguageLabel.textAlignment = .right
        viewDidLayoutSubviews()
       
    }
    private var selectedLanguage: Language = .english

    weak var coordinator: HomeCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.setupButton(color: .appColor, title: "Next", borderColor: .appColor, textColor: .white)
        
      
    }
    


}
