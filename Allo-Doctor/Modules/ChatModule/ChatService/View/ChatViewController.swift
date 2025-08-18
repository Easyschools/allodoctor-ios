//
//  ChatViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 30/12/2024.
//
import UIKit
import FirebaseFirestore
import FirebaseAuth
import Combine

class ChatViewController: BaseViewController<ChatViewModel> {
    // MARK: - IBOutlets
    @IBOutlet weak var chatTypeLabel: UILabel!
    @IBOutlet weak var chatImage: UIImageView!
    @IBOutlet weak var chatView: UIStackView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var AttachmentButton: UIButton!
    @IBOutlet weak var buttonConstraint: NSLayoutConstraint!
    // MARK: - Properties
    private let db = Firestore.firestore()
    private var keyboardHeight: CGFloat = 0
    private var originalButtonConstraintConstant: CGFloat = 0
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        chatTableView.contentInsetAdjustmentBehavior = .never
        
        // Store original constraint constant
        originalButtonConstraintConstant = buttonConstraint.constant
    }
    
    override func setupUI() {
        setupTableView()
        setupMessageTextField()
        bindViewModel()
        setupTapGesture()
        handleChatTypeView()
        // Don't start listening immediately - wait for first message
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    override func bindViewModel() {
        bindViewModelData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upperView.roundCorners([.bottomLeft, .bottomRight], radius: 25)
        chatView.roundCorners([.topLeft, .topRight], radius: 15)
    }
    
    deinit {
        removeKeyboardObservers()
    }
    
    // MARK: - Setup Methods
    private func setupTableView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.registerCell(cellClass: MessageTableViewCell.self)
        chatTableView.keyboardDismissMode = .none // Changed to .none to prevent keyboard dismissal
        chatTableView.separatorStyle = .none
        chatTableView.backgroundColor = .systemBackground
        // Add padding to the bottom of the table view
        chatTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        chatTableView.scrollIndicatorInsets = chatTableView.contentInset
    }
    
    private func setupMessageTextField() {
        messageTextField.delegate = self
        messageTextField.layer.cornerRadius = 20
        messageTextField.layer.masksToBounds = true
        messageTextField.backgroundColor = .systemGray6
        messageTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: messageTextField.frame.height))
        messageTextField.leftViewMode = .always
        messageTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: messageTextField.frame.height))
        messageTextField.rightViewMode = .always
    }
    
    private func setupTapGesture() {
        // Only add tap gesture to upperView, not the entire view or chatTableView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnUpperView))
        tapGesture.cancelsTouchesInView = false
        upperView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTapOnUpperView() {
        // Only dismiss keyboard when tapping on upperView
        messageTextField.resignFirstResponder()
    }
    
    private func bindViewModelData() {
        viewModel.$messages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.chatTableView.reloadData()
                self?.scrollToBottom(animated: true)
            }
            .store(in: &cancellables)
        
    }
    
    private func scrollToBottom(animated: Bool = true) {
        guard viewModel.messages.count > 0 else { return }
        let lastIndex = IndexPath(row: viewModel.messages.count - 1, section: 0)
        
        DispatchQueue.main.async {
            self.chatTableView.scrollToRow(at: lastIndex, at: .bottom, animated: animated)
        }
    }
    
    // MARK: - Actions
    @IBAction func sendMessageAction(_ sender: Any) {
        guard let message = messageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !message.isEmpty else { return }

        viewModel.sendMessage(message)
        messageTextField.text = ""
        textFieldDidChangeSelection(messageTextField)
    }


    @IBAction func sendAttachmentAction(_ sender: Any) {
        print("helloo")
        openImagePicker()

        //let image = UIImage(named: "add-dependency.png")

    }
    
    @IBAction func navBackAction(_ sender: Any) {
        viewModel.navBack()
    }
    
    // MARK: - Keyboard Handling
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func handleKeyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }
        
        // Convert keyboard frame to view coordinates
        let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
        let keyboardHeight = view.bounds.height - keyboardFrameInView.origin.y
        
        self.keyboardHeight = keyboardHeight
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.AnimationOptions(rawValue: curve),
            animations: {
                // Move the chat input area up by the keyboard height
                self.buttonConstraint.constant = self.originalButtonConstraintConstant + keyboardHeight

                // Adjust table view content inset to account for keyboard
                let bottomInset = keyboardHeight + 20 // 20 is the original bottom padding
                self.chatTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
                self.chatTableView.scrollIndicatorInsets = self.chatTableView.contentInset
                
                // Update layout
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                // Scroll to bottom after animation completes
                self.scrollToBottom(animated: true)
            }
        )
    }

    @objc private func handleKeyboardWillHide(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }

        self.keyboardHeight = 0

        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.AnimationOptions(rawValue: curve),
            animations: {
                // Reset the button constraint to original position
                self.buttonConstraint.constant = self.originalButtonConstraintConstant
                
                // Reset table view content inset to original
                self.chatTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
                self.chatTableView.scrollIndicatorInsets = self.chatTableView.contentInset
                
                // Update layout
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(indexPath: indexPath) as MessageTableViewCell
        let message = viewModel.messages[indexPath.row]
        
        // Make the first message always of type .sender, rest based on actual sender
        let messageType: messageType
        if indexPath.row == 0 {
            messageType = .sender
        } else {
            messageType = viewModel.isCurrentUserMessage(message) ? .sender : .reciver
        }
        
        // Setup cell with message and type

        cell.setupCell(message: message.message ?? "", dataUrl: message.attachmentUrl ?? "", messageType: messageType, chadId: message.chatId ?? "\n chat not found")
        cell.selectionStyle = .none
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // Prevent tableView taps from dismissing keyboard
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Do nothing - this prevents the default behavior
    }
}

// MARK: - UITextFieldDelegate
extension ChatViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Small delay to ensure keyboard animation has started
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollToBottom(animated: true)
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // Optional: Implement dynamic height for text field if needed
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        // Send message when return is tapped
//        sendMessageAction(textField)
//        return false // Don't dismiss keyboard
//    }
}
extension ChatViewController{
    private func handleChatTypeView(){
        if viewModel.chatType == .customerServiceType{
            self.chatImage.image = .customerServiceIcon
            self.chatTypeLabel.text = AppLocalizedKeys.CustomerService.localized
        }
        else{
            self.chatImage.image = .doctorIconWhite
            self.chatTypeLabel.text = AppLocalizedKeys.doctorCustomerService.localized
        }
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage,
           let imageData = image.jpegData(compressionQuality: 0.1 ){

            // 👉 Upload to your backend
            viewModel.sendAttachment(imageData)

            print("image uploaded")
        }
        picker.dismiss(animated: true)
    }
}

