// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
@testable import Handbid_iPad
import NetworkService
import XCTest

class ChooseAuctionViewModelTests: XCTestCase {
	var viewModel: ChooseAuctionViewModel!
	var repositoryMock: ChooseAuctionRepositoryMock!
	var dataManagerMock: DataManagerMock!
	var cancellables: Set<AnyCancellable>!

	override func setUp() {
		super.setUp()
		repositoryMock = ChooseAuctionRepositoryMock()
		dataManagerMock = DataManagerMock(database: DatabaseServiceMock())
		viewModel = .init(repository: repositoryMock, organization: OrganizationModel(id: "12345", name: "Test Organization"), dataManager: dataManagerMock)
		cancellables = []
	}

	override func tearDown() {
		viewModel = nil
		repositoryMock = nil
		dataManagerMock = nil
		cancellables = nil
		super.tearDown()
	}

	func testFetchAuctionsIfNeededFetchesAuctionsWhenEmpty() {
		XCTAssertTrue(viewModel.auctions.isEmpty)
		let expectation = expectation(description: "Fetch auctions")
		viewModel.fetchAuctionsIfNeeded()
		DispatchQueue.main.async {
			XCTAssertTrue(self.repositoryMock.fetchUserAuctionsCalled)
			expectation.fulfill()
		}
		waitForExpectations(timeout: 1, handler: nil)
	}

	func testFetchAuctionsIfNeededDoesNotFetchWhenNotEmpty() {
		viewModel.auctions = [AuctionModel.mockAuction()]
		viewModel.fetchAuctionsIfNeeded()
		XCTAssertFalse(repositoryMock.fetchUserAuctionsCalled)
	}

	func testSetupInitialSelection() {
		XCTAssertTrue(viewModel.buttonViewModels[.all]?.isSelected ?? false)
		viewModel.filterAuctions()
		XCTAssertTrue(viewModel.filteredAuctions.isEmpty)
	}

	func testHandleStateChangeUpdatesSelection() {
		viewModel.handleStateChange(for: .all, isSelected: true)
		XCTAssertTrue(viewModel.buttonViewModels[.all]?.isSelected ?? false)
		XCTAssertFalse(viewModel.buttonViewModels[.open]?.isSelected ?? false)
	}

	func testHandleStateChangeDeselectsOthersWhenAllSelected() {
		viewModel.handleStateChange(for: .all, isSelected: true)
		XCTAssertTrue(viewModel.buttonViewModels[.all]?.isSelected ?? false)
		viewModel.buttonViewModels.forEach { if $0.key != .all { XCTAssertFalse($0.value.isSelected) } }
	}

	func testHandleStateChangeSelectsAllWhenNoneSelected() {
		viewModel.handleStateChange(for: .open, isSelected: true)
		viewModel.handleStateChange(for: .open, isSelected: false)
		XCTAssertTrue(viewModel.buttonViewModels[.all]?.isSelected ?? false)
	}

	func testFilterAuctions() {
		viewModel.auctions = [AuctionModel.mockAuction()]
		viewModel.buttonViewModels[.all]?.isSelected = true
		viewModel.filterAuctions()
		XCTAssertEqual(viewModel.filteredAuctions.count, 1)
	}

	func testUpdateCenterViewData() {
		let organization = OrganizationModel.mockOrganization()
		viewModel.organization = organization
		viewModel.updateCenterViewData()
		XCTAssertEqual(viewModel.organization?.name, organization.name)
	}

	func testHandleCompletionHandlesError() {
		let error = NetworkingError.unknownError
		viewModel.handleCompletion(.failure(error))
	}

	func testHandleAuctionsReceivedUpdatesAuctions() {
		let auctions = [AuctionModel.mockAuction()]
		viewModel.handleAuctionsReceived(auctions)
		XCTAssertEqual(viewModel.auctions.count, auctions.count)
		XCTAssertEqual(viewModel.filteredAuctions.count, auctions.count)
	}

	func testCloseView() {
		XCTAssertFalse(viewModel.backToPreviewViewPressed)
		viewModel.closeView()
		XCTAssertTrue(viewModel.backToPreviewViewPressed)
	}
}
