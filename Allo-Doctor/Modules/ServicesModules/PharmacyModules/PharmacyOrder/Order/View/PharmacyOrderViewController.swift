//
//  PharmacyOrderViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 05/11/2024.
//

import UIKit
class PharmacyOrderViewController: BaseViewController<PharmacyOrderViewModel> {
    @IBOutlet weak var monthlyButton: SelectableButton!
    @IBOutlet weak var weeklyButton: SelectableButton!
    @IBOutlet weak var deliveryButton: SelectableButton?
    @IBOutlet weak var pickupButton: SelectableButton?
    @IBOutlet weak var deliveryTypeView: UIView?
    @IBOutlet weak var dybamicGeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var coupunTextField: UITextField!
    @IBOutlet weak var disscountPrice: UILabel!
    @IBOutlet weak var deliveyFees: UILabel!
    @IBOutlet weak var selectPaymentTypeLabel: CairoSemiBold!
    @IBOutlet weak var applyCouponButton: UIButton!
    @IBOutlet weak var orderSummaryView: UIView!
    @IBOutlet weak var adressLabel: CairoSemiBold!
    @IBOutlet weak var totalPayConfirmPrice: CairoRegular!
    @IBOutlet weak var totalPay: UILabel!
    @IBOutlet weak var grandTotal: UILabel!
    @IBOutlet weak var navigationBackButton: CustomNavigationBackButton!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var couponView: UIView!
    @IBOutlet weak var adressView: UIView!
    private var isCouponApplied = false
    @IBOutlet weak var disscountView: UIStackView!
    @IBOutlet weak var coupon: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindOrderStatus()
        observeNewAddress()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getPharmacyCart()
    }

    override func setupUI() {
        adressView.applyDropShadow()
        orderSummaryView.applyDropShadow()
        paymentView.applyDropShadow()
        couponView.applyDropShadow()
        deliveryTypeView?.applyDropShadow()
        navigationBackButton.tintColor = .black
        navigationBackButton.setTitleColor(.black, for: .normal)

        // Default: delivery selected
        if let deliveryButton = deliveryButton, let pickupButton = pickupButton {
            deliveryButton.disableAutomaticToggle()
            pickupButton.disableAutomaticToggle()
            deliveryButton.isSelected = true
            pickupButton.isSelected = false
        }
        viewModel.deliveryType = "delivery"

        // Address always visible
        adressView.isHidden = false
    }

    override func bindViewModel() {
        viewModel.getPharmacyCart()
        bindProductsData()
        bindOrdersStatus()
    }

    @IBAction func addPaymentAction(_ sender: Any) {}

    @IBAction func applyCouponAction(_ sender: Any) {
        Task {
            viewModel.errorMessage = nil
            if !coupunTextField.isEmpty {
                viewModel.applyCoupoun(pharmacyId: viewModel.pharmacyId ?? 0, coupounId: coupon.text ?? "")
            }
            viewModel.$coupounStatus
                .receive(on: DispatchQueue.main)
                .sink { status in
                    guard let status = status else { return }
                    switch status {
                    case .success: return
                    case .failure: return
                    }
                }
                .store(in: &cancellables)
        }
    }

    @IBAction func weeklyButtonAction(_ sender: Any) {
        if weeklyButton.isSelected {
            viewModel.remiderType = "weekly"
            monthlyButton.resetSelection()
        } else {
            viewModel.remiderType = ""
        }
    }

    @IBAction func monthlyButtonAction(_ sender: Any) {
        if monthlyButton.isSelected {
            viewModel.remiderType = "monthly"
            weeklyButton.resetSelection()
        } else {
            viewModel.remiderType = ""
        }
    }

    @IBAction func deliveryButtonAction(_ sender: Any) {
        guard let deliveryButton = deliveryButton, let pickupButton = pickupButton else { return }
        deliveryButton.isSelected = true
        pickupButton.isSelected = false
        viewModel.deliveryType = "delivery"
        // Address always visible
    }

    @IBAction func pickupButtonAction(_ sender: Any) {
        guard let deliveryButton = deliveryButton, let pickupButton = pickupButton else { return }
        pickupButton.isSelected = true
        deliveryButton.isSelected = false
        viewModel.deliveryType = "pickup"
        // Address always visible — user may still want to save address for pickup
    }

    @IBAction func selectAdressViewAction(_ sender: Any) {
        let viewModel = UserAdressSelectViewModel()
        let contentViewController = UserAdressSelectViewController(viewModel: viewModel)

        contentViewController.choosedAddress
            .sink { [weak self] (addressName, addressID) in
                guard let self = self else { return }
                self.adressLabel.text = addressName
                self.viewModel.adressId = addressID
            }
            .store(in: &cancellables)

        contentViewController.dismissalSubject
            .sink { [weak self] in
                guard let self = self else { return }
                self.viewModel.showAddressAdd()
            }
            .store(in: &cancellables)

        let sheetController = FWIPNSheetViewController(controller: contentViewController, sizes: [.percent(0.5)])
        present(sheetController, animated: true, completion: nil)
    }

    @IBAction func navigateBackAction(_ sender: Any) {
        viewModel.navBack()
    }

    @IBAction func selectPaymentAction(_ sender: Any) {
        let paymentVC = PaymentViewController()

        paymentVC.paymentMethodSubject
            .sink { [weak self] selectedMethod in
                print("Selected payment method: \(selectedMethod)")
                self?.handleSelectedPaymentMethod(selectedMethod)
            }
            .store(in: &cancellables)

        let paymentVCsheetController = FWIPNSheetViewController(controller: paymentVC, sizes: [.percent(0.3)])
        present(paymentVCsheetController, animated: true, completion: nil)
    }

    @IBAction func confirmOrderAction(_ sender: Any) {
        // Validate delivery type
        if viewModel.deliveryType == nil || viewModel.deliveryType?.isEmpty == true {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.pleaseSelectDeliveryType.localized, message: "")
            return
        }

        // Validate address only for delivery
        if viewModel.deliveryType == "delivery" && viewModel.adressId == nil {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.pleaseSelectAddress.localized, message: "")
            return
        }

        // Validate payment
        if viewModel.paymentType == nil || viewModel.paymentType?.isEmpty == true {
            AlertManager.showAlert(on: self, title: AppLocalizedKeys.pleaseSelectPayment.localized, message: "")
            return
        }

        viewModel.createOrder()

        let confirmationView = ConfirmationView(frame: view.bounds)
        confirmationView.proceedActionPublisher
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
    }

    func setupView() {
        let grandTotalData = viewModel.pharmacyCart
        grandTotal.text = (grandTotalData?.totalPrice ?? AppLocalizedKeys.zero.localized) + AppLocalizedKeys.EGP.localized
        totalPay.text = (grandTotalData?.totalAfterDiscount ?? AppLocalizedKeys.zero.localized) + AppLocalizedKeys.EGP.localized
        totalPayConfirmPrice.text = (grandTotalData?.totalAfterDiscount ?? AppLocalizedKeys.zero.localized) + AppLocalizedKeys.EGP.localized
        disscountPrice.text = (grandTotalData?.discount ?? AppLocalizedKeys.zero.localized).appendingWithSpace(AppLocalizedKeys.EGP.localized)
        deliveyFees.text = (grandTotalData?.deliveryFee ?? AppLocalizedKeys.zero.localized) + AppLocalizedKeys.EGP.localized
    }

    private func observeNewAddress() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewAddress(_:)), name: .newAddressCreated, object: nil)
    }

    @objc private func handleNewAddress(_ notification: Notification) {
        if let addressName = notification.userInfo?["addressName"] as? String,
           let addressId = notification.userInfo?["addressId"] as? Int {
            adressLabel.text = addressName
            viewModel.adressId = addressId
        }
    }

    private func bindProductsData() {
        viewModel.$pharmacyCart
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.setupView()
            }
            .store(in: &cancellables)
    }

    private func bindOrdersStatus() {
        viewModel.$Status
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self = self, let status = status else { return }
                switch status {
                case .success:
                    self.handleSucessTransaction()
                case .failure:
                    AlertManager.showAlert(on: self, title: AppLocalizedKeys.error.localized, message: AppLocalizedKeys.somethingHappen.localized)
                }
            }
            .store(in: &cancellables)
    }

    private func bindOrderStatus() {
        viewModel.$orderCheck
            .receive(on: DispatchQueue.main)
            .sink { [weak self] orderStatus in
                if orderStatus?.nameEn == "Confirmed" {
                    self?.handleSucessTransaction()
                }
            }
            .store(in: &cancellables)
    }

    private func handleSelectedPaymentMethod(_ method: String) {
        switch method {
        case "cash":
            selectPaymentTypeLabel.text = AppLocalizedKeys.Cash.localized
            viewModel.paymentType = method
        case "paymob":
            selectPaymentTypeLabel.text = AppLocalizedKeys.PayOnline.localized
            viewModel.paymentType = method
        default:
            print("Unknown payment method")
        }
    }
}

extension PharmacyOrderViewController: PaymentTaskHandling {
    func handlePaymentCompletion(orderId: Int) {
        viewModel.getStatusCheck(orderID: orderId)
    }

    func handleSucessTransaction() {
        let confirmationView = ConfirmationView(frame: view.bounds)
        confirmationView.setupView(
            message: AppLocalizedKeys.orderPlacedSuccessfully.localized,
            description: AppLocalizedKeys.orderPlacedSuccessfully.localized
        )
        confirmationView.proceedActionPublisher
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
        view.addSubview(confirmationView)
    }

    func handleCoupoun() {}
}
