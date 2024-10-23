// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

enum AlertType {
	case addCard(title: String, delegate: AddCardAlertDelegate, combineSubject: PassthroughSubject<CardDetails, Never>)
	case sendReceipt(sendMethod: String, sendTo: String, errorSend: Bool)
	case enterPin(delegate: EnterPinAlertDelegate)
}

class AlertFactory {
	static func createAlert(type: AlertType) -> AnyView {
		switch type {
		case let .addCard(title, delegate, combineSubject):
			let viewModel = AddCardAlertViewModel(
				delegate: delegate,
				combineSubject: combineSubject
			)
			let alert = AddCardAlertView(title: title, viewModel: viewModel)
			return AnyView(alert)

		case let .sendReceipt(sendMethod: sendMethod, sendTo: sendTo, errorSend: errorSend):
			let alert = SendReceiptAlertView(sendMethod: sendMethod, sendTo: sendTo, errorSend: errorSend)
			return AnyView(alert)
		case let .enterPin(delegate):
			let viewModel = EnterPinAlertViewModel(delegate: delegate)
			let alert = EnterPinAlertView(title: "", bodyText: "", viewModel: viewModel)
			return AnyView(alert)
		}
	}
}
