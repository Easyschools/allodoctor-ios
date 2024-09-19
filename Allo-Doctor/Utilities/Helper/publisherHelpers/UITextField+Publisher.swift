//
//  UITextField+Publisher.swift
//  DataFlowProject
//
//  Created by Karin Prater on 29.03.21.
//

import Foundation
import UIKit
import Combine

extension UITextField {
    
    // Publisher that emits changes to the text field's text
    func textPublisher() -> AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }
//    var textPublisher: AnyPublisher<String, Never> {
//           NotificationCenter.default
//               .publisher(for: UITextField.textDidChangeNotification, object: self)
//               .compactMap { $0.object as? UITextField }
//               .map { $0.text ?? "" }
//               .eraseToAnyPublisher()
//       }
    // Binds the text field to a subject for two-way binding
    func bindText(to subject: CurrentValueSubject<String, Never>,
                  storeIn subscriptions: inout Set<AnyCancellable>) {

        subject
            .filter { [weak self] in $0 != self?.text }
            .sink { [weak self] in self?.text = $0 }
            .store(in: &subscriptions)

        self.textPublisher()
            .filter { $0 != subject.value }
            .sink { subject.send($0) }
            .store(in: &subscriptions)
    }
}
