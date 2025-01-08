//
//  SwiftUIView.swift
//  
//
//  Created by vijay pokuri on 08/01/25.
//

import SwiftUI

public struct AddCreditCardView: View {
    @ObservedObject var presenter: CreditCardPresenter
    @Binding var showAddCardDrawer: Bool
    //
    @State private var text: String = ""
    @State private var showPicker: Bool = false
    @State private var selectedMonth = 1
    @State private var selectedYear = Calendar.current.component(.year, from: Date()) % 100
    
    var months = Array(1...12)
    var years = Array(24...34) // Example: 2024-2034, using 2-digit format
    //

    public var body: some View {
        NavigationView {
            ScrollView(){
            VStack(spacing: 20) {
                
                if !presenter.newCardNumber.isEmpty {
                    CreditCardView(
                        card: CreditCard(
                            cardHolderName: presenter.newCardHolderName,
                            cardNumber: presenter.newCardNumber,
                            expiryDate: presenter.newExpiryDate,
                            cvv: presenter.newCVV,
                            cardType: presenter.cardType,
                            gradientColors: presenter.gradientColors
                        )
                    )
                    .padding(.top)
                }
                
                TextField("Card Number", text: $presenter.newCardNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.top)
                    .keyboardType(.numberPad)
                    .onChange(of: presenter.newCardNumber) { value in
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
                        presenter.autoFormatCardNumber(&mutableValue)
                        
                        presenter.newCardNumber = mutableValue
                        presenter.updateCardType(for: mutableValue)
                    }
                
                ZStack {
                    VStack {
                        HStack {
                            TextField("Expiry Date (MM/YY)", text: $presenter.newExpiryDate)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numbersAndPunctuation)
                                .onChange(of: presenter.newExpiryDate) { value in
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
                                    presenter.newExpiryDate = mutableValue
                                }
                            
                            Button(action: {
                                showPicker.toggle()
                            }) {
                                Image(systemName: "calendar")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 10)
                            }
                        }
                        
                        if showPicker {
                            // Small custom view for the picker
                            VStack {
                                HStack {
                                    Picker("Select Month", selection: $selectedMonth) {
                                        ForEach(months, id: \.self) { month in
                                            Text(String(format: "%02d", month)).tag(month)
                                        }
                                    }
                                    .pickerStyle(WheelPickerStyle())
                                    .frame(width: 150) // Control width of the month picker
                                    
                                    Picker("Select Year", selection: $selectedYear) {
                                        ForEach(years, id: \.self) { year in
                                            Text(String(format: "%02d", year)).tag(year)
                                        }
                                    }
                                    .pickerStyle(WheelPickerStyle())
                                    .frame(width: 150) // Control width of the year picker
                                }
                                
                                Button("Done") {
                                    presenter.newExpiryDate = String(format: "%02d / %02d", selectedMonth, selectedYear)
                                    showPicker = false
                                }
                                .padding()
                            }
                            .frame(maxWidth: 320, maxHeight: 150)
                            .padding(.trailing, 50)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .shadow(radius: 10)
                        }
                    }
                    .padding(.horizontal)
                }
                
                TextField("CVV", text: $presenter.newCVV)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .keyboardType(.numberPad)
                    .onChange(of: presenter.newCVV) { value in
                        presenter.newCVV = String(value.filter { $0.isNumber }.prefix(3))
                    }
                
                TextField("Card Type", text: $presenter.cardType)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .disabled(true)
                
                TextField("Cardholder Name", text: $presenter.newCardHolderName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .onChange(of: presenter.newCardHolderName) { value in
                        // Limit the input to 51 characters
                        presenter.newCardHolderName = String(value.prefix(21))
                    }
                
                
                Button(action: {
                    presenter.addCreditCard()
                    showAddCardDrawer = false // Close the sheet after adding the card
                }) {
                    Text("Activate")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(presenter.isAddCardButtonEnabled ? Color.green : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(!presenter.isAddCardButtonEnabled)
                
                Spacer()
            }
            .navigationTitle("Activate Credit Card")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel") {
                showAddCardDrawer = false // Close the sheet when canceling
            } .foregroundColor(.white))
            
        }
    }
    }
}
