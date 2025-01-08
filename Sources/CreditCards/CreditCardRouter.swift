//
//  CreditCardRouter.swift
//  Bank
//
//  Created by vijay pokuri on 23/12/24.
//

import SwiftUI

// MARK: - Router
public struct CreditCardRouter {
    static func makeAddCreditCardView(presenter: CreditCardPresenter, showAddCardDrawer: Binding<Bool>) -> some View {
        AddCreditCardView(presenter: presenter, showAddCardDrawer: showAddCardDrawer)
    }
    
    func dismissAddCardView(_ show: inout Bool) {
        show = false
    }

}
