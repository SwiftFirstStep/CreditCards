//
//  CreditCardView.swift
//  Bank
//
//  Created by vijay pokuri on 23/12/24.
//

import SwiftUI

struct CreditCardView: View {
    let card: CreditCard

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: card.gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Spacer()
                    Text(card.cardType)
                        .font(.headline)
                        .foregroundColor(.white)
                        .bold()
                }

                Text(card.cardNumber)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .tracking(2)

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Cardholder")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        Text(card.cardHolderName)
                            .font(.headline)
                            .foregroundColor(.white)
                    }

                    Spacer()

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Expires")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        Text(card.expiryDate)
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
        }
        .frame(height: 200)
        .padding(.horizontal)
    }
}

//struct CreditCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreditCardView()
//    }
//}
