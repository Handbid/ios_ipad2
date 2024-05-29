// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import NetworkService
import XCTest

class ChooseEnvironmentViewModel_Tests: XCTestCase {
	var viewModel: ChooseEnvironmentViewModel!

	override func setUp() {
		super.setUp()
		viewModel = ChooseEnvironmentViewModel(NetworkingClient())
	}

	override func tearDown() {
		viewModel = nil
		super.tearDown()
	}

	func testSaveEnvironmentWithSelectedOption() {
		let selectedOption: AppEnvironmentType = .prod
		viewModel.selectedOption = selectedOption
		viewModel.saveEnvironment()
		XCTAssertEqual(AppEnvironmentType.currentState, selectedOption)
	}

	func testEnvironmentChange() {
		let selectedOption: AppEnvironmentType = .d1
		viewModel.selectedOption = selectedOption
		viewModel.saveEnvironment()
		XCTAssertEqual(AppEnvironmentType.currentState, selectedOption)

		let newSelectedOption: AppEnvironmentType = .qa
		viewModel.selectedOption = newSelectedOption
		viewModel.saveEnvironment()
		XCTAssertEqual(AppEnvironmentType.currentState, newSelectedOption)
	}
}
