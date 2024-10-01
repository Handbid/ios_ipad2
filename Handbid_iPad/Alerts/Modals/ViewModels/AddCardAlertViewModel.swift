// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine

protocol AddCardAlertDelegate: AnyObject {
	func didAddCard(details: CardDetails)
}

struct CardDetails {
	let cardNumber: String
	let expiryDate: String
}

class AddCardAlertViewModel: ObservableObject {
	@Published var cardNumber: String = ""
	@Published var expiryDate: String = ""

	weak var delegate: AddCardAlertDelegate?
	var combineSubject: PassthroughSubject<CardDetails, Never>?

	init(delegate: AddCardAlertDelegate? = nil, combineSubject: PassthroughSubject<CardDetails, Never>? = nil) {
		self.delegate = delegate
		self.combineSubject = combineSubject
	}

	func save() {
		let details = CardDetails(cardNumber: cardNumber, expiryDate: expiryDate)
		delegate?.didAddCard(details: details)
		combineSubject?.send(details)
	}
}
