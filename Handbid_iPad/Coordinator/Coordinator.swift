// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

protocol CoordinatorProtocol {
	associatedtype Page: PageProtocol
	associatedtype Model

	var navigationStack: [Page] { get }
	var currentPageIndex: Int { get }
	var isLoggedIn: Bool { get set }
	var model: Model? { get set }

	func push(_ page: Page, with model: Model?)
	func pop()
	func popToRoot()
	func build(page: Page) -> AnyView
	func navigateTo(_ index: Int)
}

class Coordinator<T: PageProtocol, U>: CoordinatorProtocol, ObservableObject {
	@Published var navigationStack = [T]()
	private(set) var currentPageIndex: Int = 0
	var viewModels = [T: Any]()
	var isLoggedIn: Bool = false
	var model: U?

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
		guard navigationStack.indices.contains(index) else { return }
		currentPageIndex = index
	}
}
