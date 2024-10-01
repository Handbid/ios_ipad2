// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import Foundation
import SwiftUI
import UIKit

class AlertManager: ObservableObject {
	static let shared = AlertManager()

	@Published var alertStack: [AnyView] = []
	var backgroundColor: Color = .black.opacity(0.4)

	private init() {}

	func showAlert(_ alert: some View, backgroundColor: Color = Color.black.opacity(0.4)) {
		self.backgroundColor = backgroundColor
		DispatchQueue.main.async {
			self.alertStack.append(AnyView(alert))
		}
	}

	func dismissAlert() {
		DispatchQueue.main.async {
			_ = self.alertStack.popLast()
		}
	}
}

enum AlertType {
	case addCard(title: String)
	//    case deleteCard(title: String, message: String, cardNumber: String)
	//    case sendInvoice(title: String, message: String)
	case enterPin(title: String, body: String)
	// Additional cases as needed
}

class DelegateHolder<T: AnyObject> {
	weak var delegate: T?
	init(delegate: T?) {
		self.delegate = delegate
	}
}

protocol AddCardAlertDelegate: AnyObject {
	func didAddCard(details: CardDetails)
}

protocol EnterPinAlertDelegate: AnyObject {
	func didEnterPin(pin: String)
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

struct CardDetails {
	let cardNumber: String
	let expiryDate: String
}

struct AddCardAlertView: View {
	var title: String
	@ObservedObject var viewModel: AddCardAlertViewModel

	var body: some View {
		VStack(spacing: 16) {
			Text(title)
				.font(.headline)

			TextField("Card Number", text: $viewModel.cardNumber)
				.textFieldStyle(RoundedBorderTextFieldStyle())

			TextField("Expiry Date", text: $viewModel.expiryDate)
				.textFieldStyle(RoundedBorderTextFieldStyle())

			HStack {
				Button("Close") {
					AlertManager.shared.dismissAlert()
				}
				Spacer()
				Button("Save") {
					viewModel.save()
					AlertManager.shared.dismissAlert()
				}
			}
		}
		.padding()
		.background(Color.white)
		.cornerRadius(12)
		.padding()
	}
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

struct EnterPinAlertView: View {
	var title: String
	var bodyText: String
	@ObservedObject var viewModel: EnterPinAlertViewModel

	var body: some View {
		VStack(spacing: 16) {
			Text(title)
				.font(.headline)
			Text(bodyText)
			SecureField("PIN", text: $viewModel.pin)
				.textFieldStyle(RoundedBorderTextFieldStyle())

			HStack {
				Button("Cancel") {
					AlertManager.shared.dismissAlert()
				}
				Spacer()
				Button("Confirm") {
					viewModel.confirm()
					AlertManager.shared.dismissAlert()
				}
			}
		}
		.padding()
		.background(Color.white)
		.cornerRadius(12)
		.padding()
	}
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
