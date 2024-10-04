// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

enum AlertType {
	case addCard(title: String)
	case enterPin(title: String, body: String)
	case sendReceipt(sendMethod: String, sendTo: String, errorSend: Bool)
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

		case let .sendReceipt(sendMethod: sendMethod, sendTo: sendTo, errorSend: errorSend):
			let alert = SendReceiptAlertView(sendMethod: sendMethod, sendTo: sendTo, errorSend: errorSend)
			return AnyView(alert)
		}
	}
}
