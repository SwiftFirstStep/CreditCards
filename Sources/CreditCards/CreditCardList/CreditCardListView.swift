import SwiftUI

// MARK: - Views
public struct CreditCardListView: View {
    @State public var showAddCardDrawer = false
    @ObservedObject public var presenter: CreditCardPresenter
    @State private var showAlert = false
    @State private var cardToDelete: CreditCard?
    @State private var selectedCard: CreditCard?
    @State private var navigateToDetails = false

    public init(presenter: CreditCardPresenter) {
        self.presenter = presenter
    }

    public var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(presenter.creditCards) { card in
                        NavigationLink(
                            destination: CreditCardDetailsView(card: card),
                            label: {
                                CreditCardView(card: card)
                                    .onTapGesture {
                                        selectedCard = card
                                        navigateToDetails = true
                                    }
                            }
                        )
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
                .listStyle(PlainListStyle())

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
}

public struct CreditCardDetailsView: View {
    public let card: CreditCard

    public var body: some View {
        VStack(spacing: 20) {
            Text("Card Details")
                .font(.largeTitle)
                .padding(.top)

            Text(card.name)
                .font(.title2)
                .padding(.bottom, 10)

            Button(action: {
                // Handle Black Card logic
            }) {
                Text("Black Card")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button(action: {
                // Handle Set Limit logic
            }) {
                Text("Set Limit")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button(action: {
                // Handle Pay Credit Card Bill logic
            }) {
                Text("Pay Credit Card Bill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Spacer()
        }
        .padding()
        .navigationTitle(card.name)
        .navigationBarTitleDisplayMode(.inline)
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
