//
//  CalendarDropDownView.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 24/11/2024.
//
import UIKit
import Combine

class CalendarDropdownView: UIView {

    // Combine publisher for date selection
    private let dateSelectionSubject = PassthroughSubject<(date: Date, formattedString: String), Never>()
    var dateSelection: AnyPublisher<(date: Date, formattedString: String), Never> {
        dateSelectionSubject.eraseToAnyPublisher()
    }

    private let dropdownButton: UILabel = {
        let label = UILabel()
        // Set initial text to today's date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            formatter.locale = Locale(identifier: "ar")
        }
        else{
            formatter.locale = Locale(identifier: "en")} // Arabic locale
        formatter.calendar = Calendar(identifier: .gregorian) // Gregorian calendar
        label.text = formatter.string(from: Date()).prepend(AppLocalizedKeys.Today.localized, separator: ",")
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let chevronIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .blueApp
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDropdown))
        view.addGestureRecognizer(tapGesture)
        return view
    }()

    private lazy var datePickerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.clipsToBounds = false
        return view
    }()

    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.date = Date()
        picker.minimumDate = Calendar.current.startOfDay(for: Date()) // Restrict to today and future dates
        picker.calendar = Calendar(identifier: .gregorian) // Ensure Gregorian calendar
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            picker.locale = Locale(identifier: "ar")
            // Arabic locale
        }
            else{
                picker.locale = Locale(identifier: "en")
            }
        return picker
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(AppLocalizedKeys.Confirm.localized, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .blueApp
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()

    private var isOpen = false
    private weak var windowOverlay: UIView?
    private weak var pickerContainerView: UIView?

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            formatter.locale = Locale(identifier: "ar")
            // Arabic locale
        }
            else{
             
                formatter.locale = Locale(identifier: "en")
            }
      // Arabic locale
        formatter.calendar = Calendar(identifier: .gregorian) // Gregorian calendar
        return formatter
    }()

    private let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if UserDefaultsManager.sharedInstance.getLanguage() == .ar{
            formatter.locale = Locale(identifier: "ar")
            // Arabic locale
        }
            else{
             
                formatter.locale = Locale(identifier: "en")
            } // Arabic locale
        formatter.calendar = Calendar(identifier: .gregorian) // Gregorian calendar
        return formatter
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(dropdownButton)
        addSubview(chevronIcon)
        setupConstraints()
        setupActions()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dropdownButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            dropdownButton.trailingAnchor.constraint(equalTo: chevronIcon.leadingAnchor, constant: -8),
            dropdownButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            dropdownButton.heightAnchor.constraint(equalToConstant: 40),

            chevronIcon.trailingAnchor.constraint(equalTo: trailingAnchor),
            chevronIcon.centerYAnchor.constraint(equalTo: dropdownButton.centerYAnchor),
            chevronIcon.widthAnchor.constraint(equalToConstant: 20),
            chevronIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleDropdown))
        dropdownButton.addGestureRecognizer(tapGesture)
    }

    @objc private func toggleDropdown() {
        if isOpen {
            dismissDropdown()
        } else {
            showDropdown()
        }
    }

    private func showDropdown() {
        guard let window = UIApplication.shared.windows.first else { return }

        isOpen = true
        chevronIcon.image = UIImage(systemName: "chevron.up")

        overlayView.frame = window.bounds
        window.addSubview(overlayView)
        windowOverlay = overlayView

        datePickerContainer.frame = CGRect(x: 20,
                                           y: window.bounds.height,
                                           width: window.bounds.width - 40,
                                           height: 400)

        window.addSubview(datePickerContainer)
        pickerContainerView = datePickerContainer

        datePickerContainer.addSubview(datePicker)
        datePickerContainer.addSubview(doneButton)

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: datePickerContainer.topAnchor, constant: 16),
            datePicker.leadingAnchor.constraint(equalTo: datePickerContainer.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: datePickerContainer.trailingAnchor, constant: -16),

            doneButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 16),
            doneButton.leadingAnchor.constraint(equalTo: datePickerContainer.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: datePickerContainer.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: datePickerContainer.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        UIView.animate(withDuration: 0.3) {
            self.overlayView.alpha = 1
            self.datePickerContainer.frame.origin.y = window.bounds.height - 400 - window.safeAreaInsets.bottom
        }
    }

    @objc private func dismissDropdown() {
        guard let window = UIApplication.shared.windows.first else { return }

        isOpen = false
        chevronIcon.image = UIImage(systemName: "chevron.down")

        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView.alpha = 0
            self.datePickerContainer.frame.origin.y = window.bounds.height
        }) { _ in
            self.windowOverlay?.removeFromSuperview()
            self.pickerContainerView?.removeFromSuperview()
            self.windowOverlay = nil
            self.pickerContainerView = nil
        }
    }

    @objc private func doneButtonTapped() {
        updateSelectedDate()
        dismissDropdown()

        let selectedDate = datePicker.date
        let formattedString = apiDateFormatter.string(from: selectedDate)

        // Emit the selected date through the Combine publisher
        dateSelectionSubject.send((date: selectedDate, formattedString: formattedString))
    }

    private func updateSelectedDate() {
        let selectedDate = datePicker.date

        // Check if selected date is today
        if Calendar.current.isDateInToday(selectedDate) {
            dropdownButton.text = dateFormatter.string(from: selectedDate).prepend(AppLocalizedKeys.Today.localized, separator: ",")
        } else {
            dropdownButton.text = dateFormatter.string(from: selectedDate)
        }

        dropdownButton.textColor = .black
    }
}
