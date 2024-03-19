// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

@MainActor
class Coordinator<T: PageProtocol, U>: ObservableObject {
	@Published var navigationStack = [T]()
	@Published var pages = [T]()
	@Published var currentPageIndex: Int = 0
	var viewModels: [T: Any] = [:]
	var model: U?

	var isLoggedIn: Bool = false {
		didSet {
			if isLoggedIn {
				popToRoot()
			}
		}
	}

	private let viewBuilder: (T) -> AnyView

	init(viewBuilder: @escaping (T) -> AnyView) {
		self.viewBuilder = viewBuilder
	}

	func push(_ page: T, with model: U? = nil) {
		navigationStack.append(page)
		viewModels[page] = model
		self.model = model
	}

	func pop() {
		guard !navigationStack.isEmpty else { return }
		navigationStack.removeLast()
	}

	func popToRoot() {
		navigationStack.removeAll()
	}

	func build(page: T) -> AnyView {
		viewBuilder(page)
	}

	func navigateTo(_ index: Int) {
		guard pages.indices.contains(index) else { return }
		currentPageIndex = index
	}
}
