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
		status: .open,
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
		try verifyText(sut, identifier: "auctionNameLabel", expected: "Auction Name")
		try verifyTextContains(sut, identifier: "auctionItemsLabel", position: 0, expected: "10")
		try verifyText(sut, identifier: "auctionStatusLabel", expected: "OPEN")
		try verifyExists(sut, identifier: "auctionImage")
		try verifyText(sut, identifier: "auctionAddressLabel", expected: "123 Street")
		try verifyEndTime(sut, identifier: "auctionEndTimeLabel", position: 2, timestamp: auction.endTime)
	}

	private func verifyText(_ view: AnyView, identifier: String, expected: String) throws {
		let text = try view.inspect().find(viewWithAccessibilityIdentifier: identifier).text().string()
		XCTAssertEqual(text, expected)
	}

	private func verifyTextContains(_ view: AnyView, identifier: String, position: Int, expected: String) throws {
		let hStack = try view.inspect().find(viewWithAccessibilityIdentifier: identifier).hStack()
		let text = try hStack.text(position).string()
		XCTAssertTrue(text.contains(expected))
	}

	private func verifyExists(_ view: AnyView, identifier: String) throws {
		let _ = try view.inspect().find(viewWithAccessibilityIdentifier: identifier)
		XCTAssertTrue(true)
	}

	private func verifyEndTime(_ view: AnyView, identifier: String, position: Int, timestamp: Int?) throws {
		let hStack = try view.inspect().find(viewWithAccessibilityIdentifier: identifier).hStack()
		let text = try hStack.text(position).string()
		XCTAssertEqual(text, convertTimestampToDate(timestamp: TimeInterval(timestamp ?? 0)))
	}
}
