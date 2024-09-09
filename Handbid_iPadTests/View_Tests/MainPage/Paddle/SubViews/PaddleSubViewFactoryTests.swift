// Copyright (c) 2024 by Handbid. All rights reserved.

import ViewInspector
import XCTest

@testable import Handbid_iPad

class PaddleSubViewFactoryTests: XCTestCase {
	private var mockViewModel: MockPaddleViewModel!
	private var factory: PaddleSubViewFactory!

	override func setUp() {
		mockViewModel = MockPaddleViewModel()
		factory = PaddleSubViewFactory(viewModel: mockViewModel)
	}

	func testDisplayingSubViews() {
		let expFindPaddle = factory.inspection
			.inspect(onReceive: mockViewModel.$subView) { v in
				XCTAssertNoThrow(try v.find(FindPadleView.self))
				self.mockViewModel.subView = .createAccount
			}

		let expCreateAccount = factory.inspection
			.inspect(onReceive: mockViewModel.$subView.dropFirst()) { v in
				XCTAssertNoThrow(try v.find(CreateAccountView.self))
				self.mockViewModel.subView = .userFound(RegistrationModel())
			}

		let expUserFound = factory.inspection
			.inspect(onReceive: mockViewModel.$subView.dropFirst(2)) { v in
				XCTAssertNoThrow(try v.find(UserFoundView.self))
				self.mockViewModel.subView = .confirmInformation(RegistrationModel())
			}

		let expConfirmInformation = factory.inspection
			.inspect(onReceive: mockViewModel.$subView.dropFirst(3)) { v in
				XCTAssertNoThrow(try v.find(ConfirmUserInformationView.self))
			}

		ViewHosting.host(view: factory)

		wait(for: [expFindPaddle, expCreateAccount, expUserFound, expConfirmInformation],
		     timeout: 2,
		     enforceOrder: true)
	}
}
