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
    
    var months = Array(1...12)
    var years = Array(24...34)
    
    private var interactor: CreditCardInteractorProtocol
    private var cancellables = Set<AnyCancellable>()
    
    public init(interactor: CreditCardInteractorProtocol) {
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
    
    public func updateNewExpiryDate(value: String){
        var mutableValue = value
        mutableValue = mutableValue.filter { $0.isNumber || $0 == "/" }
        if mutableValue.count > 2, !mutableValue.contains("/") {
            mutableValue.insert("/", at: mutableValue.index(mutableValue.startIndex, offsetBy: 2))
        }
        
        // Limit the input to MM/YY format
        let components = mutableValue.split(separator: "/")
        
        switch components.count {
        case 2:
            let month = components[0].prefix(2)
            let year = components[1].prefix(2)
            
            // Validate the year (should be between 24 and 34)
            if let yearInt = Int(year), yearInt < 24 && String(yearInt).count != 1 {
                mutableValue = "\(month)/24" // Set to minimum year
            } else if let yearInt = Int(year), yearInt > 34 {
                mutableValue = "\(month)/34" // Set to maximum year
            } else if let yearInt = Int(year), yearInt == 0 {
                mutableValue = "\(month)/24" // Set to maximum year
            }else {
                mutableValue = "\(month)/\(year)"
            }
            
            // Validate the month (should be between 1 and 12)
            if let monthInt = Int(month), monthInt < 1 {
                mutableValue = "01" // Set to minimum month
            } else if let monthInt = Int(month), monthInt > 12 {
                mutableValue = "12" // Set to maximum month
            }
            
        case 1:
            let month = components[0].prefix(2)
            
            // Validate the month and adjust if necessary
            if let monthInt = Int(month), monthInt > months.last! {
                mutableValue = "12"
            } else if let monthInt = Int(month), monthInt == 0 {
                mutableValue = "0"
            } else if let monthInt = Int(month), monthInt < months.first! {
                mutableValue = "1"
            }
            else {
                mutableValue = "\(month)"
            }
            
        case _ where components.count > 2:
            let month = components[0].prefix(2)
            let year = components[1].prefix(2)
            mutableValue = "\(month)/\(year)"
            
        default:
            break
        }
        // Assign the validated and formatted value
        newExpiryDate = mutableValue
    }
    
    public func updateNewCardNumber(value: String){
        var mutableValue = value
        mutableValue = mutableValue.filter { $0.isNumber || $0 == " " }
        
        // Ensure the input is no more than 16 digits and 3 spaces
        let digits = mutableValue.filter { $0.isNumber }
        let spaces = mutableValue.filter { $0 == " " }
        
        if digits.count > 16 {
            mutableValue = String(digits.prefix(16))
        }
        
        if spaces.count > 3 {
            let maxLength = digits.count + 3
            mutableValue = String(mutableValue.prefix(maxLength))
        }
        
        // Optionally auto-format the card number
        autoFormatCardNumber(&mutableValue)
        
        newCardNumber = mutableValue
        updateCardType(for: mutableValue)
    }
    
    public func updateNewCVV(value: String){
        newCVV = String(value.filter { $0.isNumber }.prefix(3))
    }
    
    public func updateNewCardHolderName(value: String){
        // Limit the input to 51 characters
        newCardHolderName = String(value.prefix(21))
    }
    
    private func clearForm() {
        newCardHolderName = ""
        newCardNumber = ""
        newExpiryDate = ""
        newCVV = ""
        cardType = ""
    }
}

