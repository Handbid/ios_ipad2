// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

final class AuctionCollectionCellViewTests: XCTestCase {
	let auction = AuctionModel(
		id: "1",
		identity: 1,
		key: "key",
		imageUrl: "https://example.com/image.png",
		auctionGuid: "guid",
		name: "Auction Name",
		status: "Active",
		endTime: 1_650_000_000,
		totalItems: 10,
		auctionAddressStreet1: "123 Street"
	)

	private var view: AuctionCollectionCellView<MainContainerPage>!
	private var sut: AnyView!
	private var coordinator: Coordinator<MainContainerPage, Any?>!
	var inspectionError: Error? = nil

	override func setUp() {
		super.setUp()
		coordinator = Coordinator<MainContainerPage, Any?>(viewBuilder: { _ in AnyView(EmptyView()) })
		view = AuctionCollectionCellView(colorScheme: .light, auction: auction)
		sut = AnyView(view.environmentObject(coordinator))
	}

	func testAuctionCollectionCellViewDisplaysCorrectData() throws {
		ViewHosting.host(view: sut)

		do {
			let nameLabel = try sut.inspect().find(viewWithAccessibilityIdentifier: "auctionNameLabel").text().string()
			XCTAssertEqual(nameLabel, "Auction Name")
		}
		catch {
			XCTFail("Failed to find auction name label: \(error)")
		}

		do {
			let itemsLabelHStack = try sut.inspect().find(viewWithAccessibilityIdentifier: "auctionItemsLabel").hStack()
			let itemsText1 = try itemsLabelHStack.text(0).string()
			let itemsText2 = try itemsLabelHStack.text(1).string()
			XCTAssertTrue(itemsText1.contains("10"))
		}
		catch {
			XCTFail("Failed to find auction items label: \(error)")
		}

		// Test auction status label
		do {
			let statusLabel = try sut.inspect().find(viewWithAccessibilityIdentifier: "auctionStatusLabel").text().string()
			XCTAssertEqual(statusLabel, "ACTIVE")
		}
		catch {
			XCTFail("Failed to find auction status label: \(error)")
		}

		// Test auction image (success case)
		do {
			let image = try sut.inspect().find(viewWithAccessibilityIdentifier: "auctionImage")
			XCTAssertNotNil(image)
		}
		catch {
			XCTFail("Failed to find auction image: \(error)")
		}

		// Test auction address label
		do {
			let addressLabel = try sut.inspect().find(viewWithAccessibilityIdentifier: "auctionAddressLabel").text().string()
			XCTAssertEqual(addressLabel, "123 Street")
		}
		catch {
			XCTFail("Failed to find auction address label: \(error)")
		}

		// Test auction end time label
		do {
			let endTimeLabelHStack = try sut.inspect().find(viewWithAccessibilityIdentifier: "auctionEndTimeLabel").hStack()
			let endTimeText = try endTimeLabelHStack.text(2).string() // Skip the spacers and clock icon
			XCTAssertEqual(endTimeText, convertTimestampToDate(timestamp: TimeInterval(auction.endTime ?? 0)))
		}
		catch {
			XCTFail("Failed to find auction end time label: \(error)")
		}
	}
}
