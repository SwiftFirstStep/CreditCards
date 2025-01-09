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
                            presenter.updateNewCardNumber(value: value)
                        }
                    
                    ZStack {
                        VStack {
                            HStack {
                                TextField("Expiry Date (MM/YY)", text: $presenter.newExpiryDate)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numbersAndPunctuation)
                                    .onChange(of: presenter.newExpiryDate) { value in
                                        presenter.updateNewExpiryDate(value: value)
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
                                            ForEach(presenter.months, id: \.self) { month in
                                                Text(String(format: "%02d", month)).tag(month)
                                            }
                                        }
                                        .pickerStyle(WheelPickerStyle())
                                        .frame(width: 150) // Control width of the month picker
                                        
                                        Picker("Select Year", selection: $selectedYear) {
                                            ForEach(presenter.years, id: \.self) { year in
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
                            presenter.updateNewCVV(value: value)
                        }
                    
                    TextField("Card Type", text: $presenter.cardType)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .disabled(true)
                    
                    TextField("Cardholder Name", text: $presenter.newCardHolderName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .onChange(of: presenter.newCardHolderName) { value in
                            presenter.updateNewCardHolderName(value: value)
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
