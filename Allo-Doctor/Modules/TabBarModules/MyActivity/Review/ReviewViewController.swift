//
//  ReviewViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 16/07/2025.
//

import UIKit
import Combine

// MARK: - Review Data Models
struct ReviewRequest: Codable {
    let rating: String
    let comment: String
    let reviewable_entity: String
    let reviewable_id: Int
}

struct ReviewResponse: Codable {
    let message: String
    // Add other response fields as needed
}

// MARK: - Star Rating View
class StarRatingViews: UIView {
    private var starButtons: [UIButton] = []
    private let maxRating = 5
  
    var rating: Int = 0 {
        didSet {
            updateStarAppearance()
            onRatingChanged?(rating)
        }
    }
    
    var onRatingChanged: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStars()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStars()
    }
    
    private func setupStars() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for i in 0..<maxRating {
            let button = UIButton(type: .system)
            button.setTitle("★", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            button.setTitleColor(.lightGray, for: .normal)
            button.tag = i + 1
            button.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
            
            starButtons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func starTapped(_ sender: UIButton) {
        rating = sender.tag
    }
    
    private func updateStarAppearance() {
        for (index, button) in starButtons.enumerated() {
            if index < rating {
                button.setTitleColor(.systemYellow, for: .normal)
            } else {
                button.setTitleColor(.lightGray, for: .normal)
            }
        }
    }
}

// MARK: - Review View Controller
class ReviewViewController: UIViewController {
    
    // MARK: - UI Components
    private var reviableType : String?
    private let apiClient: APIClient = APIClient()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let ratingLabel = UILabel()
    private let starRatingView = StarRatingViews()
    private let commentLabel = UILabel()
    private let commentTextView = UITextView()
    private let submitButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let reviewableEntity: String
    private let reviewableId: Int
    private let apiURL = "https://Backend.allo-doctor.com/api/admin/review/create"
    
    // MARK: - Initialization
    init(reviewableEntity: String, reviewableId: Int) {
        self.reviewableEntity = reviewableEntity
        self.reviewableId = reviewableId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Navigation
        title = AppLocalizedKeys.writeReview.localized
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        
        // Scroll View
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Title Label
        titleLabel.text = AppLocalizedKeys.rateAndReview.localized
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Rating Label
        ratingLabel.text = AppLocalizedKeys.howWouldYouRateThis.localized
        ratingLabel.font = UIFont.systemFont(ofSize: 16)
        ratingLabel.textAlignment = .center
        ratingLabel.numberOfLines = 0
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Star Rating View
        starRatingView.translatesAutoresizingMaskIntoConstraints = false
        
        // Comment Label
        commentLabel.text = AppLocalizedKeys.addCommentOptional.localized
        commentLabel.font = UIFont.systemFont(ofSize: 16)
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Comment Text View
        commentTextView.font = UIFont.systemFont(ofSize: 16)
        commentTextView.layer.borderColor = UIColor.systemGray4.cgColor
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.cornerRadius = 8
        commentTextView.translatesAutoresizingMaskIntoConstraints = false
        
        // Submit Button
        submitButton.setTitle(AppLocalizedKeys.submitReview.localized , for: .normal)
        submitButton.backgroundColor = .systemBlue
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 8
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Activity Indicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        // Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [titleLabel, ratingLabel, starRatingView, commentLabel, commentTextView, submitButton, activityIndicator].forEach {
            contentView.addSubview($0)
        }
        let dismissButton = UIButton(type: .system)
        dismissButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        dismissButton.tintColor = .grey6B7280
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        view.addSubview(dismissButton)

        // Replace the empty NSLayoutConstraint.activate([]) with these constraints:
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dismissButton.widthAnchor.constraint(equalToConstant: 30),
            dismissButton.heightAnchor.constraint(equalToConstant: 30)
        ])

    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Rating Label
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            ratingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Star Rating View
            starRatingView.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 20),
            starRatingView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            starRatingView.heightAnchor.constraint(equalToConstant: 50),
            starRatingView.widthAnchor.constraint(equalToConstant: 250),
            
            // Comment Label
            commentLabel.topAnchor.constraint(equalTo: starRatingView.bottomAnchor, constant: 30),
            commentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Comment Text View
            commentTextView.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 10),
            commentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            commentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            commentTextView.heightAnchor.constraint(equalToConstant: 120),
            
            // Submit Button
            submitButton.topAnchor.constraint(equalTo: commentTextView.bottomAnchor, constant: 30),
            submitButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            // Activity Indicator
            activityIndicator.centerXAnchor.constraint(equalTo: submitButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor)
        ])
    }
    
    private func setupActions() {
        starRatingView.onRatingChanged = { [weak self] rating in
            self?.updateSubmitButtonState()
        }
        
        submitButton.addTarget(self, action: #selector(submitReview), for: .touchUpInside)
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func updateSubmitButtonState() {
        submitButton.isEnabled = starRatingView.rating > 0
        submitButton.alpha = starRatingView.rating > 0 ? 1.0 : 0.5
    }
    
    // MARK: - Actions
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func submitReview() {
        guard starRatingView.rating > 0 else {
            showAlert(title: "", message: AppLocalizedKeys.pleaseSelectRating.localized )
            return
        }
        
        setLoadingState(true)
       
        if reviewableEntity == "booking" {
            reviableType = "doctor"
        }
        else if reviewableEntity == "labBookings"{
            reviableType = "lab"
        }
        let reviewRequest = ReviewRequest(
            rating: starRatingView.rating.toString(),
            comment: commentTextView.text ?? "",
            reviewable_entity: reviableType ?? "",
            reviewable_id: reviewableId
        )
        
        guard let url = URL(string: apiURL) else {
            setLoadingState(false)
            showAlert(title: "Error", message: "Invalid URL")
            return
        }
        print(reviewRequest)
        // Use your existing postData function
        apiClient.postData(to: url, body: reviewRequest, as: ReviewResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.setLoadingState(false)
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.showAlert(title: AppLocalizedKeys.error.localized, message: AppLocalizedKeys.somethingHappen.localized)
                    }
                },
                receiveValue: { [weak self] response in
                    if response.message == "Review created successfully" {
                        self?.showAlert(title: "", message: AppLocalizedKeys.reviewCreatedSuccessfully.localized ) {
                            self?.dismiss(animated: true)
                        }
                    } else {
                        self?.showAlert(title: "", message: response.message)
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    private func setLoadingState(_ isLoading: Bool) {
        submitButton.isEnabled = !isLoading
        if isLoading {
            activityIndicator.startAnimating()
            submitButton.setTitle("", for: .normal)
        } else {
            activityIndicator.stopAnimating()
            submitButton.setTitle(AppLocalizedKeys.submitReview.localized , for: .normal)
        }
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:AppLocalizedKeys.ok.localized, style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
}
