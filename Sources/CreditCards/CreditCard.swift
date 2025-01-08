import Foundation
import SwiftUI

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
