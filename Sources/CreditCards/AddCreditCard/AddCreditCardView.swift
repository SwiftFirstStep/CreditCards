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
    
    public var body: some View {
        NavigationView {
            VStack {
                TextField("Card Number", text: $presenter.newCardNumber)
                    .onChange(of: presenter.newCardNumber) { value in
                        presenter.updateCardNumber(value)
                    }

                TextField("Expiry Date", text: $presenter.newExpiryDate)
                    .onChange(of: presenter.newExpiryDate) { value in
                        presenter.updateExpiryDate(value)
                    }

                Button("Activate") {
                    presenter.addCreditCard()
                    showAddCardDrawer = false
                }
                .disabled(!presenter.isAddCardButtonEnabled)
            }
        }
    }
}
