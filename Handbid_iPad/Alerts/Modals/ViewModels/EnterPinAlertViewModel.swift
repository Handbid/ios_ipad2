// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine

protocol EnterPinAlertDelegate {
	var isSuccess: AnyPublisher<Bool?, Never> { get }

	func didEnterPin(pin: String)
}

class EnterPinAlertViewModel: ObservableObject {
	@Published var pin: String = ""

	var delegate: EnterPinAlertDelegate?

	init(delegate: EnterPinAlertDelegate? = nil) {
		self.delegate = delegate
	}

	func confirm() {
		delegate?.didEnterPin(pin: pin)
	}
}
