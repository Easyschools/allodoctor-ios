//
//  ProductDetailsViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 23/10/2024.
//

import UIKit
import Kingfisher
class ProductDetailsViewController: BaseViewController<ProductDetailsViewModel> {
    
    // MARK: - IBOutlets
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet private weak var addToCartButton: CustomButton!
    @IBOutlet private weak var addToCartView: UIView!
    @IBOutlet private weak var productDescDynamicHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var productDescriptionView: UIView!
    @IBOutlet private weak var relatedProductsCollectionView: UICollectionView!
    @IBOutlet private weak var quantityIncreaseButton: UIButton!
    @IBOutlet private weak var productDescription: UITextView!
    @IBOutlet weak var priceAfterDiscount: UILabel!
    @IBOutlet private weak var quantityDecreaseButton: UIButton!
    @IBOutlet private weak var productPrice: UILabel!
    @IBOutlet private weak var productName: UILabel!
    @IBOutlet private weak var extendButton: UIButton!
    @IBOutlet private weak var productImage: UIImageView!
    @IBOutlet private weak var dismissButton: UIButton!
    private let addToCartSubject = PassthroughSubject<Product, Never>()
    private let buttonTapSubject = PassthroughSubject<Void, Never>()
    weak var delegate: addToCartTapped?
    // MARK: - Properties
    private var isDescriptionExpanded = false {
        didSet {
            updateDescriptionState()
        }
    }
    let orderDetailsPublisher = PassthroughSubject<(Int, Double), Never>()
    var buttonTapPublisher: AnyPublisher<Void, Never> {
           buttonTapSubject.eraseToAnyPublisher()
       }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
      
       
        
    }
    
    // MARK: - Private Methods
     override func setupUI() {
         priceAfterDiscount.isHidden = true
        setupInitialState()
        setupProductDescription()
        setupQuantity()
       
    }
    
    private func setupProductDescription() {
        let product = viewModel.product
       
        productDescription.isScrollEnabled = false
        productDescription.isEditable = false
        productDescDynamicHeightConstraint.constant = self.productDescription.contentSize.height
        productImage.kf.setImage(with:URL(string: product?.mainImage ?? "") )
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            productName.text = product?.nameAr
            productDescription.text = product?.descriptionAr
        }
        else{
            productName.text = product?.nameEn
            productDescription.text = product?.descriptionEn
        }
        let priceAfterDiscounts = viewModel.product?.medicationPharmacies?.first?.priceAfterDiscount
        let price = viewModel.product?.medicationPharmacies?.first?.price
        if let discounted = priceAfterDiscounts, !discounted.isEmpty {
            // Show discounted price
            priceAfterDiscount.isHidden = false
            priceAfterDiscount.text = discounted.withoutDecimals.appendingWithSpace(AppLocalizedKeys.EGP.localized)

            // Apply strikethrough to original price
            let attributedString = NSAttributedString(
                string: price?.withoutDecimals.appendingWithSpace(AppLocalizedKeys.EGP.localized) ?? "",
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            productPrice.tintColor = .black
            productPrice.attributedText = attributedString
        } else {
            // No discount: hide discounted label and show price normally
            priceAfterDiscount.isHidden = true
            productPrice.attributedText = nil
            productPrice.text = price?.withoutDecimals.appendingWithSpace(AppLocalizedKeys.EGP.localized)
        }
//        productPrice.text = product?.medicationPharmacies?[0].price?.appendingWithSpace(AppLocalizedKeys.EGP.localized)
    }
    @IBAction func decrementQuantityAction(_ sender: Any) {
        if viewModel.quantity > 1 {
                   viewModel.quantity -= 1
               }
       
    }
    @IBAction func incrementQuantityAction(_ sender: Any) {
    let qty = viewModel.product?.medicationPharmacies?.first?.quantity
        if qty ?? 0 >  viewModel.quantity {
                viewModel.quantity += 1
        }
        else {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.maximumQuantityReached.localized, message: "")
        }
    }
    
    private func setupInitialState() {
        productDescriptionView.isHidden = true
        updateExtendButtonImage()
    }
    
    private func updateDescriptionHeight() {
        productDescDynamicHeightConstraint.constant = productDescription.contentSize.height
        view.layoutIfNeeded()
    }
    
    private func updateDescriptionState() {
        productDescriptionView.animate(isHidden: !isDescriptionExpanded) { [weak self] _ in
            self?.updateExtendButtonImage()
        }
    }
    
    private func updateExtendButtonImage() {
        let image = isDescriptionExpanded ? UIImage.arrowDownCircle : UIImage.arrowUpCircle
        UIView.transition(with: extendButton, duration: 0.3, options: .transitionCrossDissolve) {
            self.extendButton.setImage(image, for: .normal)
        }
     
    }
    
    // MARK: - IBActions
    @IBAction private func addToCartAction(_ sender: Any) {
        viewModel.addTocart()
        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
        GrandTotalManger.updateOtherViewControllers()
    }
    
    @IBAction private func extentDescriptionButtonAction(_ sender: Any) {
        isDescriptionExpanded.toggle()
    }
    @IBAction func dismissButtton(_ sender: Any){
        viewModel.coordinator?.dismissPresnetiontabBarNav(self)
    }
    private func setupQuantity() {
            viewModel.$quantity
                .map { "\($0)" }
                .assign(to: \.text, on: quantityLabel)
                .store(in: &cancellables)
        }
    
}

// MARK: - Optional: Custom Button States Enum
extension ProductDetailsViewController {
    enum ButtonState {
        case expanded
        case collapsed
        
        var image: UIImage? {
            switch self {
            case .expanded:
                return UIImage.arrowDownCircle
            case .collapsed:
                return UIImage.arrowUpCircle
            }
        }
    }
}
