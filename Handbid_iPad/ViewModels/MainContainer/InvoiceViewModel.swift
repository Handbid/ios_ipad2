// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

class InvoiceViewModel: ObservableObject {
	@Published var lineItems: [ReceiptLineItemModel] = []
	@Published var coverFees: Bool = true
	@Published var subtotal: Double?
	@Published var transactionFees: Double?
	@Published var ccThxFees: Double?
	@Published var alreadyPaid: Double?
	@Published var due: Double?
	@Published var isPaid: Bool?
	@Published var creditCards: [CreditCardModel] = []
	@Published var selectedCard: CreditCardModel?
	@Published var receipt: ReceiptModel?
	@Published var isDataLoaded: Bool = false
	@Published var showAlert: Bool = false
	@Published var alertMessage: String = ""

	let myBidsViewModel: MyBidsViewModel
	private var cancellables = Set<AnyCancellable>()

	init(myBidsViewModel: MyBidsViewModel) {
		self.myBidsViewModel = myBidsViewModel

		myBidsViewModel.$receiptBidder
			.compactMap { $0 }
			.sink { [weak self] receipt in
				self?.processReceipt(receipt)
			}
			.store(in: &cancellables)

		myBidsViewModel.$showAlert
			.receive(on: DispatchQueue.main)
			.assign(to: &$showAlert)

		myBidsViewModel.$alertMessage
			.receive(on: DispatchQueue.main)
			.assign(to: &$alertMessage)
	}

	func fetchInvoice() {
		isDataLoaded = false
		myBidsViewModel.requestFetchReceipt()
	}

	private func processReceipt(_ receipt: ReceiptModel) {
		self.receipt = receipt

		lineItems = receipt.lineItems ?? []

		subtotal = Double(receipt.subTotal ?? 0)

		if coverFees {
			transactionFees = subtotal! * 0.05
			ccThxFees = subtotal! * 0.02
		}
		else {
			transactionFees = 0.0
			ccThxFees = 0.0
		}

		alreadyPaid = Double(receipt.amountPaid ?? 0)

		due = (subtotal! + transactionFees! + ccThxFees!) - alreadyPaid!

		isPaid = receipt.paid

		creditCards = myBidsViewModel.selectedBidder?.creditCards ?? []
		selectedCard = creditCards.first

		isDataLoaded = true

		print(receipt)
	}

	func makePayment() {
		// Implement payment logic here
	}

	func sendSMSInvoice() {
		myBidsViewModel.sendReceipt()
	}

	func sendEmailInvoice() {
		myBidsViewModel.sendReceipt(email: myBidsViewModel.selectedBidder?.email)
	}
}
