// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
@testable import Handbid_iPad
import ProgressIndicatorView
import SwiftUI
import ViewInspector
import XCTest

final class ImageGalleryViewTests: XCTestCase {
	func testInitialSelectedImage() throws {
		let item = ItemModel()
		let images = [ItemImageModel(itemImageUrl: "https://service.handbid.com/sample_image.jpeg")]

		let detailState = ItemDetailState()
		detailState.selectedImage = nil

		let loadImages = Binding<Bool>(wrappedValue: true)

		let view = ImageGalleryView(
			detailState: detailState,
			loadImages: loadImages,
			item: item,
			images: images
		)

		let hostingController = UIHostingController(rootView: view)
		XCTAssertNotNil(hostingController.view)

		XCTAssertNil(detailState.selectedImage)

		detailState.selectedImage = images.first?.itemImageUrl
		XCTAssertEqual(detailState.selectedImage, "https://service.handbid.com/sample_image.jpeg")

		let asyncImage = try view.inspect().find(ViewType.AsyncImage.self)
		XCTAssertNoThrow(asyncImage)
	}

	func testFallbackImage() throws {
		let item = ItemModel(imageUrl: "https://service.handbid.com/fallback_image.jpeg")
		let images: [ItemImageModel] = []

		let detailState = ItemDetailState()
		detailState.selectedImage = nil

		let loadImages = Binding<Bool>(wrappedValue: true)

		let view = ImageGalleryView(
			detailState: detailState,
			loadImages: loadImages,
			item: item,
			images: images
		)

		let hostingController = UIHostingController(rootView: view)
		XCTAssertNotNil(hostingController.view)

		let asyncImage = try view.inspect().find(ViewType.AsyncImage.self)
		XCTAssertNoThrow(asyncImage)
	}

	func testBadgeDisplay() throws {
		let item = ItemModel(isLive: true)
		let images: [ItemImageModel] = []

		let detailState = ItemDetailState()

		let loadImages = Binding<Bool>(wrappedValue: true)

		let view = ImageGalleryView(
			detailState: detailState,
			loadImages: loadImages,
			item: item,
			images: images
		)

		let hostingController = UIHostingController(rootView: view)
		XCTAssertNotNil(hostingController.view)

		let badge = try view.inspect().find(ViewType.Text.self, where: { try $0.accessibilityIdentifier() == "badgeItem" })
		XCTAssertEqual(try badge.string(), "LIVE")
		XCTAssertEqual(try badge.accessibilityIdentifier(), "badgeItem")
	}

	func testRenderingEmptySpacesInGrid() throws {
		let item = ItemModel()
		let images = [ItemImageModel(itemImageUrl: "https://service.handbid.com/sample_image.jpeg")]

		let detailState = ItemDetailState()
		detailState.selectedImage = nil

		let loadImages = Binding<Bool>(wrappedValue: true)

		let view = ImageGalleryView(
			detailState: detailState,
			loadImages: loadImages,
			item: item,
			images: images
		)

		let hostingController = UIHostingController(rootView: view)
		XCTAssertNotNil(hostingController.view)
	}

	func testProgressIndicatorAndFooter() throws {
		let item = ItemModel()
		let images = [ItemImageModel(itemImageUrl: "https://service.handbid.com/sample_image.jpeg")]

		let detailState = ItemDetailState()
		detailState.remainingTime = 30
		detailState.progress = 0.5

		let loadImages = Binding<Bool>(wrappedValue: true)

		let view = ImageGalleryView(
			detailState: detailState,
			loadImages: loadImages,
			item: item,
			images: images
		)

		let hostingController = UIHostingController(rootView: view)
		XCTAssertNotNil(hostingController.view)

		let progressIndicator = try view.inspect().find(ViewType.View<ProgressIndicatorView>.self, where: { try $0.accessibilityIdentifier() == "progressIndicator" })
		XCTAssertNoThrow(progressIndicator)

		let footer = try view.inspect().find(ViewType.HStack.self, where: { try $0.accessibilityIdentifier() == "footer" })
		let footerText = try footer.find(ViewType.Text.self, where: { try $0.accessibilityIdentifier() == "remainingTimeText" })
		XCTAssertEqual(try footerText.string(), "Screen will close in 30 seconds")
	}
}
