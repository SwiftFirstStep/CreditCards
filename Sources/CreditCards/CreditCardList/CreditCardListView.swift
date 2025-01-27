import SwiftUI

// MARK: - Views
public struct CreditCardListView: View {
    @State public var showAddCardDrawer = false
    @ObservedObject public var presenter: CreditCardPresenter
    @State private var showAlert = false
    @State private var cardToDelete: CreditCard?

    public init(presenter: CreditCardPresenter) {
        self.presenter = presenter
    }

    public var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(presenter.creditCards) { card in
                        CreditCardView(card: card)
                            .swipeActions {
                                Button(role: .destructive) {
                                    cardToDelete = card
                                    showAlert = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
                .padding(.vertical)
            }

            Button(action: {
                showAddCardDrawer.toggle()
            }) {
                Text("Activate Credit Card")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
            .sheet(isPresented: $showAddCardDrawer) {
                AddCreditCardView(presenter: presenter, showAddCardDrawer: $showAddCardDrawer)
            }
        }
        .navigationTitle("Credit Cards")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Confirm Delete", isPresented: $showAlert, actions: {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                if let card = cardToDelete {
                    presenter.deleteCard(card)
                }
            }
        }, message: {
            Text("Are you sure you want to delete this card?")
        })
    }
}

extension Notification.Name {
    static let dismissAddCardView = Notification.Name("dismissAddCardView")
}

// MARK: - Preview
//struct CreditCardListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreditCardListView()
//    }
//}
