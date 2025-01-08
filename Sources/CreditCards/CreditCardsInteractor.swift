//
//  CreditCardsInteractor.swift
//  Bank
//
//  Created by vijay pokuri on 23/12/24.
//

import SwiftUI
import Combine

// MARK: - Interactor
protocol CreditCardInteractorProtocol {
    func fetchCreditCards() -> [CreditCard]
    func validateCardDetails(name: String, number: String, expiry: String, cvv: String, type: String) -> Bool
}

public class CreditCardInteractor: CreditCardInteractorProtocol {
    private let repository: CreditCardRepositoryProtocol

    public init(repository: CreditCardRepositoryProtocol) {
        self.repository = repository
    }

    public func fetchCreditCards() -> [CreditCard] {
        return repository.getCreditCards()
    }

    public func validateCardDetails(name: String, number: String, expiry: String, cvv: String, type: String) -> Bool {
        return !name.isEmpty && number.count == 19 && expiry.contains("/") && cvv.count == 3 && !type.isEmpty
    }
}
