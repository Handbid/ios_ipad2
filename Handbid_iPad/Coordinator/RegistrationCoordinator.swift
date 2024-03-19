// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

protocol PageProtocol: RawRepresentable, Identifiable, Hashable where RawValue == String {}

protocol PageView: View {
	associatedtype PageType: PageProtocol
}

protocol CoordinatorBase {
	associatedtype PageType: PageProtocol
	associatedtype PageView: View
	var navigationStack: [PageType] { get set }
	var currentPageIndex: Int { get set }

	mutating func push(_ page: PageType)
	mutating func pop()
	mutating func popToRoot()
	func build(page: PageType) -> PageView
	func viewForCurrentPage() -> PageView
	mutating func navigateTo(_ index: Int)
	func viewMaker(for page: PageType) -> (() -> AnyView)?
}

extension CoordinatorBase where PageType == RegistrationPage, PageView: View {
	mutating func push(_ page: PageType) {
		navigationStack.append(page)
	}

	mutating func pop() {
		guard !navigationStack.isEmpty else { return }
		navigationStack.removeLast()
	}

	mutating func popToRoot() {
		navigationStack.removeAll()
	}

	func build(page: PageType) -> PageView {
		guard let viewMaker = viewMaker(for: page) else {
			fatalError("No view maker found for page: \(page)")
		}
		return AnyView(viewMaker()) as! PageView
	}

	func viewForCurrentPage() -> PageView {
		if navigationStack.indices.contains(currentPageIndex) {
			return build(page: navigationStack[currentPageIndex])
		}
		else {
			return AnyView(Text("No page selected")) as! PageView
		}
	}

	mutating func navigateTo(_ index: Int) {
		guard navigationStack.indices.contains(index) else { return }
		currentPageIndex = index
	}
}

enum RegistrationPage: String, PageProtocol, Identifiable, Hashable {
    case getStarted, logIn
    var id: String {
        rawValue
    }
}

protocol PageViewFactory {
	func makeGetStartedView() -> AnyView
	func makeLogInView() -> AnyView
}

extension PageViewFactory {
	func makeGetStartedView() -> AnyView {
		fatalError("Not implemented")
	}

	func makeLogInView() -> AnyView {
		fatalError("Not implemented")
	}
}

struct RegistrationCoordinator<Factory: PageViewFactory>: CoordinatorBase {
	typealias PageType = RegistrationPage
	typealias PageView = AnyView

	var navigationStack = [RegistrationPage]()
	var currentPageIndex: Int = 0
	var factory: Factory

	func viewMaker(for page: PageType) -> (() -> AnyView)? {
		switch page {
		case .getStarted:
			{ factory.makeGetStartedView() }
		case .logIn:
			{ factory.makeLogInView() }
		}
	}
}

struct CountryPhoneModel: Hashable, Equatable {
	let name: String
	let code: String
	let flag: String
}

struct UserRegistrationModel {
	var firstName: String
	var lastName: String
	var email: String
	var phoneNumber: String
	var selectedCountry: CountryPhoneModel?
}
