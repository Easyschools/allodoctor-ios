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
    @IBOutlet weak var chatView: UIStackView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    // MARK: - Properties
    private let db = Firestore.firestore()
    private var keyboardHeight: CGFloat = 0
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        chatTableView.contentInsetAdjustmentBehavior = .always
    }
    
    override func setupUI() {
        setupTableView()
        setupMessageTextField()
        bindViewModel()
        viewModel.listenToChatMessages(chatId: "504125595")
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
        chatTableView.keyboardDismissMode = .interactive
        chatTableView.separatorStyle = .none
        chatTableView.backgroundColor = .systemBackground
        
        // Add padding to the bottom of the table view
        chatTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
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
        chatTableView.scrollToRow(at: lastIndex, at: .bottom, animated: animated)
    }
    
    // MARK: - Actions
    @IBAction func sendMessageAction(_ sender: Any) {
        guard let message = messageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !message.isEmpty else { return }
        viewModel.sendMessage(message)
        messageTextField.text = ""
        textFieldDidChangeSelection(messageTextField)
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
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleKeyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }
        
        let keyboardHeight = keyboardFrame.height
        self.keyboardHeight = keyboardHeight
        
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.AnimationOptions(rawValue: curve),
            animations: {
                self.chatTableView.contentInset = contentInset
                self.chatTableView.scrollIndicatorInsets = contentInset
                self.scrollToBottom(animated: false)
            },
            completion: nil
        )
    }
    
    @objc private func handleKeyboardWillHide(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        else { return }
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.AnimationOptions(rawValue: curve),
            animations: {
                self.chatTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
                self.chatTableView.scrollIndicatorInsets = .zero
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
        
        cell.message?.text = message.message
        cell.message?.numberOfLines = 0
        cell.contentView.frame = cell.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 12, right: 16))
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - UITextFieldDelegate
extension ChatViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollToBottom(animated: true)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // Optional: Implement dynamic height for text field if needed
    }
   
}
