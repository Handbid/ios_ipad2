// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import NetworkService
import SwiftUI
import ViewInspector
import XCTest

final class ChooseAuctionViewTests: XCTestCase {
	private var view: ChooseAuctionView<MainContainerPage>!
	private var coordinator: Coordinator<MainContainerPage, Any?>!
	private var mockViewModel: ChooseAuctionViewModel!
	private var repositoryMock: ChooseAuctionRepositoryMock!
	private var dataManagerMock: DataManagerMock!
	private var sut: AnyView!

	override func setUp() {
		super.setUp()
		coordinator = Coordinator<MainContainerPage, Any?>(viewBuilder: { _ in AnyView(EmptyView()) })
		repositoryMock = ChooseAuctionRepositoryMock()
		dataManagerMock = DataManagerMock(database: DatabaseServiceMock())
		mockViewModel = ChooseAuctionViewModel(repository: repositoryMock, organization: OrganizationModel.mockOrganization(), dataManager: dataManagerMock)
		view = ChooseAuctionView(viewModel: mockViewModel, selectedView: .selectAuction)
		sut = AnyView(view.environmentObject(coordinator))
	}

	override func tearDown() {
		coordinator = nil
		mockViewModel = nil
		view = nil
		super.tearDown()
	}

	func testInitialContent() throws {
		var inspectionError: Error? = nil

		ViewHosting.host(view: sut)
		do {
			_ = try sut.inspect().find(viewWithAccessibilityIdentifier: "TopBarContent")
			_ = try sut.inspect().find(viewWithAccessibilityIdentifier: "HorizontalScrollView")
			_ = try sut.inspect().find(viewWithAccessibilityIdentifier: "AuctionScrollView")
		}
		catch {
			inspectionError = error
		}

		XCTAssertNil(inspectionError)
	}

	func testFilterButtonTapChangesSelection() throws {
		let auction = AuctionModel.mockAuction()
		mockViewModel.auctions = [auction]
		mockViewModel.filterAuctions()

		var inspectionError: Error? = nil

		let exp = expectation(description: "Inspection")
		ViewHosting.host(view: sut)
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			do {
				let inspectableView = try self.sut.inspect()
				let filterButton = try inspectableView.find(viewWithAccessibilityIdentifier: "FilterButton_open")
				try filterButton.button().tap()
				XCTAssertTrue(self.mockViewModel.buttonViewModels[.open]?.isSelected ?? false)
				exp.fulfill()
			}
			catch {
				inspectionError = error
				XCTFail("Inspection failed: \(error)")
			}
		}
		wait(for: [exp], timeout: 2.0)
		XCTAssertNil(inspectionError)
	}

	func testAuctionCellContent() throws {
		let auction = AuctionModel.mockAuction()
		mockViewModel.auctions = [auction]
		mockViewModel.filterAuctions()

		var inspectionError: Error? = nil

		let exp = expectation(description: "Inspection")
		ViewHosting.host(view: sut)
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			do {
				let inspectableView = try self.sut.inspect()
				let cell = try inspectableView.find(viewWithAccessibilityIdentifier: "AuctionCollectionCellView_\(auction.id)")
				XCTAssertNotNil(cell)
				exp.fulfill()
			}
			catch {
				inspectionError = error
				XCTFail("Inspection failed: \(error)")
			}
		}
		wait(for: [exp], timeout: 2.0)
		XCTAssertNil(inspectionError)
	}

	func testBackToPreviewViewPressedNavigatesBack() throws {
		let exp = expectation(description: "Inspection")
		ViewHosting.host(view: sut)
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.mockViewModel.backToPreviewViewPressed = true
			XCTAssertTrue(self.mockViewModel.backToPreviewViewPressed)
			exp.fulfill()
		}
		wait(for: [exp], timeout: 2.0)
	}
}
