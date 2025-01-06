//
//  CreditCardsInteractor.swift
//  Bank
//
//  Created by vijay pokuri on 23/12/24.
//

import SwiftUI
import Combine

// MARK: - Entity
public struct CreditCard: Identifiable {
    public let id = UUID()
    let cardHolderName: String
    let cardNumber: String
    let expiryDate: String
    let cvv: String
    let cardType: String
    let gradientColors: [Color]
}

// MARK: - Interactor
protocol CreditCardInteractorProtocol {
    func fetchCreditCards() -> [CreditCard]
    func validateCardDetails(name: String, number: String, expiry: String, cvv: String, type: String) -> Bool
}

public class CreditCardInteractor: CreditCardInteractorProtocol {
    public func fetchCreditCards() -> [CreditCard] {
        return [
            CreditCard(
                cardHolderName: "John Doe",
                cardNumber: "1234 5678 9012 3456",
                expiryDate: "12/25",
                cvv: "123",
                cardType: "Visa",
                gradientColors: [Color.blue, Color.purple]
            ),
            CreditCard(
                cardHolderName: "Jane Smith",
                cardNumber: "9876 5432 1098 7654",
                expiryDate: "11/28",
                cvv: "456",
                cardType: "MasterCard",
                gradientColors: [Color.orange, Color.red]
            )
        ]
    }

    public func validateCardDetails(name: String, number: String, expiry: String, cvv: String, type: String) -> Bool {
        return !name.isEmpty && number.count == 19 && expiry.contains("/") && cvv.count == 3 && !type.isEmpty
    }
}
