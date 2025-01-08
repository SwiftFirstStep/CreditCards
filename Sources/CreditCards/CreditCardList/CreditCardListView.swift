import SwiftUI

// MARK: - Views
public struct CreditCardListView: View {
    @State public var showAddCardDrawer = false
    @ObservedObject public var presenter: CreditCardPresenter
    
    public init(presenter: CreditCardPresenter) {
        self.presenter = presenter
    }

    public var body: some View {
            VStack {
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(presenter.creditCards) { card in
                            CreditCardView(card: card)
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
            .navigationBarTitleDisplayMode(.inline) // Small title
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
