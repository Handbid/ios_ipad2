// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

protocol PageProtocol: RawRepresentable, Identifiable, Hashable where RawValue == String {}

enum RegistrationPage: String, PageProtocol, Identifiable, Hashable {
	case getStarted, logIn
	var id: String {
		rawValue
	}
}

protocol CoordinatorBase {
	associatedtype PageType: PageProtocol
	associatedtype PageView: View
	var navigationStack: [PageType] { get set }
	var pages: [PageType] { get set }
	var currentPageIndex: Int { get set }
	var viewModels: [PageType: [Any]] { get set }

	mutating func push(_ page: PageType, with models: [Any]?)
	mutating func pop()
	mutating func popToRoot()
	func build(page: PageType) -> PageView
	func viewForCurrentPage() -> PageView
	mutating func navigateTo(_ index: Int)
}

extension CoordinatorBase where PageType == RegistrationPage, PageView: View {
	mutating func push(_ page: PageType, with models: [Any]?) {
		navigationStack.append(page)
		if let models {
			viewModels[page] = models
		}
	}

	mutating func pop() {
		guard !navigationStack.isEmpty else { return }
		navigationStack.removeLast()
	}

	mutating func popToRoot() {
		navigationStack.removeAll()
	}

	func build(page: PageType) -> PageView {
		switch page {
		case .getStarted:
			return AnyView(GetStartedView<RegistrationPage>()) as! PageView
		case .logIn:
			return AnyView(LogInView<RegistrationPage>()) as! PageView
		}
	}

	func viewForCurrentPage() -> PageView {
		if pages.indices.contains(currentPageIndex) {
			return build(page: pages[currentPageIndex])
		}
		else {
			return AnyView(Text("No page selected")) as! PageView
		}
	}

	mutating func navigateTo(_ index: Int) {
		guard pages.indices.contains(index) else { return }
		currentPageIndex = index
	}
}

protocol PageView: View {
	associatedtype PageType: PageProtocol
}

struct RegistrationCoordinator<T: PageProtocol, PageViewType: PageView>: CoordinatorBase where T == PageViewType.PageType {
	typealias PageType = T
	typealias PageView = PageViewType

	var navigationStack = [T]()
	var pages = [T]()
	var viewModels: [T: [Any]] = [:] // Change to accept an array of models
	var currentPageIndex: Int = 0
	var userRegistration: UserRegistrationModel?
	let registrationPageType: RegistrationPage.Type // Additional parameter

	init(registrationPageType: RegistrationPage.Type) { // Additional initializer
		self.registrationPageType = registrationPageType
	}

	mutating func push(_ page: T, with models: [Any]?) { // Update to accept an array of models
		navigationStack.append(page)
		if let models {
			viewModels[page] = models
		}
	}

	mutating func pop() {
		guard !navigationStack.isEmpty else { return }
		navigationStack.removeLast()
	}

	mutating func popToRoot() {
		navigationStack.removeAll()
	}

	func build(page: T) -> PageView {
		switch page {
		case let page as RegistrationPage:
			switch page {
			case .getStarted:
				return AnyView(GetStartedView<T>()) as! PageView
			case .logIn:
				return AnyView(LogInView<T>()) as! PageView
			}
		default:
			return AnyView(Text("Unknown page")) as! PageView
		}
	}

	func viewForCurrentPage() -> PageView {
		if pages.indices.contains(currentPageIndex) {
			return build(page: pages[currentPageIndex])
		}
		else {
			return AnyView(Text("No page selected")) as! PageView
		}
	}

	mutating func navigateTo(_ index: Int) {
		guard pages.indices.contains(index) else { return }
		currentPageIndex = index
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
