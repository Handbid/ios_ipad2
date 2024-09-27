// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

struct InvoiceItem: Identifiable {
	let id: Int
	let name: String
	let amount: Double
	let tax: Int
}

class InvoiceViewModel: ObservableObject {
	@Published var auctionId: Int
	@Published var paddleNumber: Int

	@Published var invoiceDate: Date = .init()
	@Published var auctionName: String = "HandbidTest"
	@Published var invoiceItems: [InvoiceItem] = []
	@Published var coverFees: Bool = true

	@Published var subtotal: Double?
	@Published var transactionFees: Double?
	@Published var ccThxFees: Double?
	@Published var alreadyPaid: Double?
	@Published var due: Double?

	@Published var creditCards: [CreditCardModel] = []
	@Published var selectedCard: CreditCardModel?

	private var cancellables = Set<AnyCancellable>()

	init(auctionId: Int, paddleNumber: Int) {
		self.auctionId = auctionId
		self.paddleNumber = paddleNumber
	}

	var invoiceDateString: String {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		return formatter.string(from: invoiceDate)
	}

	func fetchInvoice() {
		invoiceItems = [
			InvoiceItem(id: 101, name: "Item 1", amount: 150.0, tax: 10),
			InvoiceItem(id: 102, name: "Item 2", amount: 200.0, tax: 8),
			InvoiceItem(id: 103, name: "Item 3", amount: 300.0, tax: 5),
		]

		subtotal = invoiceItems.reduce(0) { $0 + $1.amount }
		transactionFees = coverFees ? (subtotal! * 0.05) : nil
		ccThxFees = coverFees ? (subtotal! * 0.02) : nil
		alreadyPaid = 100.0
		due = (subtotal! + (transactionFees ?? 0) + (ccThxFees ?? 0)) - (alreadyPaid ?? 0)

		creditCards = [
			CreditCardModel(id: 1, lastFour: "1234", cardType: .visa),
			CreditCardModel(id: 2, lastFour: "5678", cardType: .mastercard),
		]
		selectedCard = creditCards.first
	}

	func makePayment() {}

	func sendSMSInvoice() {}

	func sendEmailInvoice() {}
}
