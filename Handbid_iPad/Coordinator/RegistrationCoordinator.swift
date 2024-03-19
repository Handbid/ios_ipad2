// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

@MainActor
class RegistrationCoordinator<T: PageProtocol>: ObservableObject {
	@Published var navigationStack = [T]()
	@Published var pages = [T]()
	@Published var currentPageIndex: Int = 0
	var viewModels: [T: Any] = [:]
	var userRegistration: UserRegistrationModel?

	var isLoggedIn: Bool = false {
		didSet {
			if isLoggedIn {
				popToRoot()
			}
		}
	}

	func push(_ page: T, with userRegistration: UserRegistrationModel? = nil) {
		navigationStack.append(page)
		viewModels[page] = userRegistration

		if let userRegistration {
			self.userRegistration = userRegistration
		}
	}

	func pop() {
		guard !navigationStack.isEmpty else { return }
		navigationStack.removeLast()
	}

	func popToRoot() {
		navigationStack.removeAll()
	}

	@ViewBuilder
	func build(page: T) -> some View {
		switch page {
		case let registrationPage as RegistrationPage:
			switch registrationPage {
			case .getStarted:
				GetStartedView<RegistrationPage>()
			case .logIn:
				LogInView<RegistrationPage>()
			}

		default:
			EmptyView()
		}
	}

	@ViewBuilder
	func viewForCurrentPage() -> some View {
		if pages.indices.contains(currentPageIndex) {
			build(page: pages[currentPageIndex])
		}
		else {
			Text("No page selected")
		}
	}

	func navigateTo(_ index: Int) {
		guard pages.indices.contains(index) else { return }
		currentPageIndex = index
	}
}
