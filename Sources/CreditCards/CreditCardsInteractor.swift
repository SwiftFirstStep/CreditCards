//
//  CreditCardsInteractor.swift
//  Bank
//
//  Created by vijay pokuri on 23/12/24.
//

import SwiftUI
import Combine

// MARK: - Interactor
public protocol CreditCardInteractorProtocol {
    func fetchCreditCards() -> [CreditCard]
    func validateCardDetails(name: String, number: String, expiry: String, cvv: String, type: String) -> Bool
    func validateAndFormatCardNumber(_ value: inout String)
    func validateExpiryDate(_ value: inout String)
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
    
    //--
    public func validateAndFormatCardNumber(_ value: inout String) {
        value = value.filter { $0.isNumber || $0 == " " }
        let digits = value.filter { $0.isNumber }
        let spaces = value.filter { $0 == " " }
        
        if digits.count > 16 {
            value = String(digits.prefix(16))
        }
        if spaces.count > 3 {
            value = String(value.prefix(digits.count + 3))
        }
    }

    public func validateExpiryDate(_ value: inout String) {
        value = value.filter { $0.isNumber || $0 == "/" }
        if value.count > 2, !value.contains("/") {
            value.insert("/", at: value.index(value.startIndex, offsetBy: 2))
        }
        
        let components = value.split(separator: "/")
        if components.count == 2 {
            let month = components[0]
            var year = components[1]
            
            if let yearInt = Int(year), yearInt < 24 {
                year = "24"
            } else if let yearInt = Int(year), yearInt > 34 {
                year = "34"
            }
            
            value = "\(month)/\(year)"
        }
    }
    //--
    
}
