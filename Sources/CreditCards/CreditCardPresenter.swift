//
//  CreditsCardPresenter.swift
//  Bank
//
//  Created by vijay pokuri on 23/12/24.
//

import SwiftUI
import Combine

// MARK: - Presenter
public protocol CreditCardPresenterProtocol: ObservableObject {
    var creditCards: [CreditCard] { get }
    var newCardHolderName: String { get set }
    var newCardNumber: String { get set }
    var newExpiryDate: String { get set }
    var newCVV: String { get set }
    var cardType: String { get set }
    var isAddCardButtonEnabled: Bool { get }
    func addCreditCard()
    func updateCardType(for number: String)
    func autoFormatCardNumber(_ number: inout String)
    func autoFormatExpiryDate(_ expiry: inout String)
}

public class CreditCardPresenter: CreditCardPresenterProtocol {
    @Published private(set) public var creditCards: [CreditCard] = []
    @Published public var newCardHolderName: String = ""
    @Published public var newCardNumber: String = ""
    @Published public var newExpiryDate: String = ""
    @Published public var newCVV: String = ""
    @Published public var cardType: String = ""
    @Published public var gradientColors = [Color.gray, Color.black]
    @Published private(set) public var isAddCardButtonEnabled: Bool = false

    private var interactor: CreditCardInteractorProtocol
    private var cancellables = Set<AnyCancellable>()

    init(interactor: CreditCardInteractorProtocol) {
        self.interactor = interactor
        setupBindings()
        creditCards = interactor.fetchCreditCards()
    }

    private func setupBindings() {
        // Combine the latest values from the published properties
        Publishers.CombineLatest4($newCardHolderName, $newCardNumber, $newExpiryDate, $newCVV)
            .combineLatest($cardType)
            .map { [weak self] (details, type) in
                // Unpack the tuple
                let (name, number, expiry, cvv) = details
                // Validate the card details
                return self?.interactor.validateCardDetails(name: name, number: number, expiry: expiry, cvv: cvv, type: type) ?? false
            }
            .assign(to: &$isAddCardButtonEnabled)
    }




    public func addCreditCard() {
        let gradientColors: [Color]
        switch cardType {
        case "Visa":
            gradientColors = [Color.blue, Color.purple]
        case "MasterCard":
            gradientColors = [Color.orange, Color.red]
        case "American Express":
            gradientColors = [Color.cyan, Color.mint]
        case "Rupay":
            gradientColors = [Color.pink, Color.yellow]
        default:
            gradientColors = [Color.gray, Color.black]
        }

        let newCard = CreditCard(
            cardHolderName: newCardHolderName,
            cardNumber: newCardNumber,
            expiryDate: newExpiryDate,
            cvv: newCVV,
            cardType: cardType,
            gradientColors: gradientColors
        )

        creditCards.append(newCard)
        clearForm()
        isAddCardButtonEnabled = false // Disable the button after adding a card
        NotificationCenter.default.post(name: .dismissAddCardView, object: nil)
    }


    public func updateCardType(for number: String) {
        let prefix = String(number.prefix(4).replacingOccurrences(of: " ", with: ""))
        switch prefix {
        case "1111":
            cardType = "MasterCard"
            gradientColors = [Color.orange, Color.red]
        case "2222":
            cardType = "Visa"
            gradientColors = [Color.blue, Color.purple]
        case "3333":
            cardType = "American Express"
            gradientColors = [Color.cyan, Color.mint]
        case "4444":
            cardType = "Rupay"
            gradientColors = [Color.pink, Color.yellow]
        case "":
            cardType = ""
            gradientColors = [Color.gray, Color.black]
            
        default:
            cardType = "Unknown"
            gradientColors = [Color.gray, Color.black]
        }
    }

    public func autoFormatCardNumber(_ number: inout String) {
        number = number.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        number = stride(from: 0, to: number.count, by: 4).map {
            let start = number.index(number.startIndex, offsetBy: $0)
            let end = number.index(start, offsetBy: 4, limitedBy: number.endIndex) ?? number.endIndex
            return String(number[start..<end])
        }.joined(separator: " ")
    }

    public func autoFormatExpiryDate(_ expiry: inout String) {
        expiry = expiry.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        if expiry.count > 2 {
            expiry.insert("/", at: expiry.index(expiry.startIndex, offsetBy: 2))
        }
    }

    private func clearForm() {
        newCardHolderName = ""
        newCardNumber = ""
        newExpiryDate = ""
        newCVV = ""
        cardType = ""
    }
}

