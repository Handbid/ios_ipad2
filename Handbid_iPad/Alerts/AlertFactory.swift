// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

enum AlertType {
	case addCard(title: String)
	//    case deleteCard(title: String, message: String, cardNumber: String)
	//    case sendInvoice(title: String, message: String)
	case enterPin(title: String, body: String)
	// Additional cases as needed
}

class AlertFactory {
	static func createAlert(type: AlertType, delegate: AnyObject? = nil, combineSubject: Any? = nil) -> AnyView {
		switch type {
		case let .addCard(title):
			let viewModel = AddCardAlertViewModel(
				delegate: delegate as? AddCardAlertDelegate,
				combineSubject: combineSubject as? PassthroughSubject<CardDetails, Never>
			)
			let alert = AddCardAlertView(title: title, viewModel: viewModel)
			return AnyView(alert)

		case let .enterPin(title, body):
			let viewModel = EnterPinAlertViewModel(
				delegate: delegate as? EnterPinAlertDelegate,
				combineSubject: combineSubject as? PassthroughSubject<String, Never>
			)
			let alert = EnterPinAlertView(title: title, bodyText: body, viewModel: viewModel)
			return AnyView(alert)
		}
	}
}
