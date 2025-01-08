//
//  File.swift
//  
//
//  Created by vijay pokuri on 08/01/25.
//

import Foundation
import SwiftUI

// MARK: - Repository Protocol
protocol CreditCardRepositoryProtocol {
    func getCreditCards() -> [CreditCard]
}

// MARK: - Repository Implementation
public class CreditCardRepository: CreditCardRepositoryProtocol {
    public func getCreditCards() -> [CreditCard] {
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
}
