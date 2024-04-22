// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import NetworkService
import SwiftUI
import ViewInspector
import XCTest

final class ChooseEnvironmentViewTests: XCTestCase {
	private var view: ChooseEnvironmentView<RegistrationPage>!
	private var sut: AnyView!
	private var coordinator: Coordinator<RegistrationPage, Any?>!
	private var mockViewModel: MockChooseEnvironmentViewModel!

	override func setUp() {
		super.setUp()
		coordinator = Coordinator<RegistrationPage, Any?>(viewBuilder: { _ in AnyView(EmptyView()) })
		mockViewModel = MockChooseEnvironmentViewModel()
		view = ChooseEnvironmentView(viewModel: mockViewModel)
		sut = AnyView(view.environmentObject(coordinator))
	}

	override func tearDown() {
		coordinator = nil
		mockViewModel = nil
		view = nil
		sut = nil
		super.tearDown()
	}

	func testInitialContent() throws {
		var inspectionError: Error? = nil

		ViewHosting.host(view: sut)
		do {
			_ = try sut.inspect()
				.find(viewWithAccessibilityIdentifier: "AppLogo")
			_ = try sut.inspect()
				.find(viewWithAccessibilityIdentifier: "registration_label_chooseEnvironmentToConnect")
			for option in mockViewModel.environmentOptions {
				_ = try sut.inspect()
					.find(ViewType.Button.self) { view in
						do {
							_ = try view.labelView().find(text: option.rawValue)
							return true
						}
						catch {
							return false
						}
					}
			}
			_ = try sut.inspect()
				.find(viewWithAccessibilityIdentifier: "registration_btn_save")
		}
		catch {
			inspectionError = error
		}

		XCTAssertNil(inspectionError)
	}

	func testEnvironmentIsSavedOnClickingButton() {
		var inspectionError: Error? = nil

		let exp = view.inspection.inspect(onReceive: mockViewModel.$saveEnvironmentCalled) { _ in
			XCTAssert(self.mockViewModel.saveEnvironmentCalled)
			XCTAssert(self.mockViewModel.selectedOption == .qa)
		}

		ViewHosting.host(view: sut)

		do {
			let button = try sut.inspect()
				.find(ViewType.Button.self) { view in
					do {
						_ = try view.labelView().find(text: AppEnvironmentType.qa.rawValue)
						return true
					}
					catch {
						return false
					}
				}
			try button.tap()

			let saveButton = try sut.inspect()
				.find(viewWithAccessibilityIdentifier: "registration_btn_save").button()

			try saveButton.tap()
		}
		catch {
			inspectionError = error
		}

		XCTAssertNil(inspectionError)
		wait(for: [exp], timeout: 1)
	}
}
