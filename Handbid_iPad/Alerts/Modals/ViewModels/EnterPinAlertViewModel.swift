// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine

protocol EnterPinAlertDelegate: AnyObject {
	func didEnterPin(pin: String)
}

class EnterPinAlertViewModel: ObservableObject {
	@Published var pin: String = ""

	weak var delegate: EnterPinAlertDelegate?
	var combineSubject: PassthroughSubject<String, Never>?

	init(delegate: EnterPinAlertDelegate? = nil, combineSubject: PassthroughSubject<String, Never>? = nil) {
		self.delegate = delegate
		self.combineSubject = combineSubject
	}

	func confirm() {
		delegate?.didEnterPin(pin: pin)
		combineSubject?.send(pin)
	}
}
