import SwiftUI

public struct CreditCardListView: View {
    @State public var showAddCardDrawer = false
    @ObservedObject public var presenter: CreditCardPresenter
    @State private var showAlert = false
    @State private var cardToDelete: CreditCard?
    @State private var selectedCard: CreditCard?

    public init(presenter: CreditCardPresenter) {
        self.presenter = presenter
    }

    public var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(presenter.creditCards) { card in
                        NavigationLink(
                            destination: CreditCardDetailView(card: card),
                            label: {
                                CreditCardView(card: card)
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

public struct CreditCardDetailView: View {
    let card: CreditCard

    public var body: some View {
        VStack(spacing: 20) {
            // Credit Card Preview
            CreditCardView(card: card)
                .padding()

            // Action Buttons
            VStack(spacing: 16) {
                Button(action: {
                    // Action for showing CVV
                }) {
                    ActionButtonView(label: "Preview CVV", icon: "eye")
                }

                Button(action: {
                    // Action for black card
                }) {
                    ActionButtonView(label: "Request Black Card", icon: "creditcard")
                }

                Button(action: {
                    // Action for increasing limit
                }) {
                    ActionButtonView(label: "Increase Limit", icon: "arrow.up.circle")
                }

                Button(action: {
                    // Action for paying credit card due
                }) {
                    ActionButtonView(label: "Pay Credit Card Due", icon: "dollarsign.circle")
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .navigationTitle(card.cardHolderName)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
}

// Custom Button View for Actions
struct ActionButtonView: View {
    let label: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .padding(.leading, 12)

            Spacer()

            Text(label)
                .font(.headline)
                .foregroundColor(.white)

            Spacer()
        }
        .frame(height: 50)
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4)
    }
}

