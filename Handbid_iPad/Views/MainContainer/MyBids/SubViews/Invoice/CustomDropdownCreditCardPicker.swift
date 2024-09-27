//Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct CustomDropdownCreditCardPicker: View {
    @Binding var selectedCard: CreditCardModel?
    var creditCards: [CreditCardModel]

    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Credit Card")
                .font(.caption)
                .foregroundColor(Color.gray)

            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selectedCard != nil ? "\(selectedCard!.cardType?.rawValue ?? "Unknown") *\(selectedCard!.lastFour ?? "****")" : "Select a card")
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                        .imageScale(.small)
                }
                .padding()
                .frame(height: 50)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
            .buttonStyle(PlainButtonStyle())

            if isExpanded {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(creditCards) { card in
                        Button(action: {
                            selectedCard = card
                            withAnimation {
                                isExpanded = false
                            }
                        }) {
                            HStack {
                                Text("\(card.cardType?.rawValue ?? "Unknown") *\(card.lastFour ?? "****")")
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .background(Color.white)
                        .overlay(
                            Divider(),
                            alignment: .bottom
                        )
                    }
                }
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
        }
        .animation(.easeInOut, value: isExpanded)
    }
}
