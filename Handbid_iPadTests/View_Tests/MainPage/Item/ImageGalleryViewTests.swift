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

		let selectedImage = Binding<String?>(wrappedValue: nil)
		let remainingTime = Binding<Int>(wrappedValue: 30)
		let progress = Binding<CGFloat>(wrappedValue: 0.5)
		let loadImages = Binding<Bool>(wrappedValue: true)

		let view = ImageGalleryView(
			selectedImage: selectedImage,
			remainingTime: remainingTime,
			progress: progress,
			loadImages: loadImages,
			item: item,
			images: images,
			resetTimer: {}
		)

		let hostingController = UIHostingController(rootView: view)
		XCTAssertNotNil(hostingController.view)

		XCTAssertNil(selectedImage.wrappedValue)

		selectedImage.wrappedValue = images.first?.itemImageUrl
		XCTAssertEqual(selectedImage.wrappedValue, "https://service.handbid.com/sample_image.jpeg")

		let asyncImage = try view.inspect().find(ViewType.AsyncImage.self)
		XCTAssertNoThrow(asyncImage)

		if let progressView = try? asyncImage.find(ViewType.ProgressView.self) {
			XCTAssertEqual(try progressView.accessibilityIdentifier(), "loadingSelectedImage")
		}
		else if let imageView = try? asyncImage.find(ViewType.Image.self) {
			XCTAssertEqual(try imageView.accessibilityIdentifier(), "selectedImage")
		}
		else if let errorImageView = try? asyncImage.find(ViewType.Image.self) {
			XCTAssertEqual(try errorImageView.accessibilityIdentifier(), "selectedImageError")
		}
		else {
			XCTFail("None of the expected phases (loading, success, error) were found in AsyncImage")
		}
	}

	func testFallbackImage() throws {
		let item = ItemModel(imageUrl: "https://service.handbid.com/fallback_image.jpeg")
		let images: [ItemImageModel] = []

		let selectedImage = Binding<String?>(wrappedValue: nil)
		let remainingTime = Binding<Int>(wrappedValue: 30)
		let progress = Binding<CGFloat>(wrappedValue: 0.5)
		let loadImages = Binding<Bool>(wrappedValue: true)

		let view = ImageGalleryView(
			selectedImage: selectedImage,
			remainingTime: remainingTime,
			progress: progress,
			loadImages: loadImages,
			item: item,
			images: images,
			resetTimer: {}
		)

		let hostingController = UIHostingController(rootView: view)
		XCTAssertNotNil(hostingController.view)

		let asyncImage = try view.inspect().find(ViewType.AsyncImage.self)
		XCTAssertNoThrow(asyncImage)

		if let fallbackImage = try? asyncImage.find(ViewType.Image.self) {
			if try fallbackImage.accessibilityIdentifier() == "fallbackImage" {
				XCTAssertEqual(try fallbackImage.accessibilityIdentifier(), "fallbackImage")
			}
			else {
				XCTAssertEqual(try fallbackImage.accessibilityIdentifier(), "fallbackImageError")
			}
		}
		else {
			XCTFail("Neither fallback image nor error image was found in AsyncImage")
		}
	}

	func testBadgeDisplay() throws {
		let item = ItemModel(isLive: true)
		let images: [ItemImageModel] = []

		let selectedImage = Binding<String?>(wrappedValue: nil)
		let remainingTime = Binding<Int>(wrappedValue: 30)
		let progress = Binding<CGFloat>(wrappedValue: 0.5)
		let loadImages = Binding<Bool>(wrappedValue: true)

		let view = ImageGalleryView(
			selectedImage: selectedImage,
			remainingTime: remainingTime,
			progress: progress,
			loadImages: loadImages,
			item: item,
			images: images,
			resetTimer: {}
		)

		let hostingController = UIHostingController(rootView: view)
		XCTAssertNotNil(hostingController.view)

		let badge = try view.inspect().find(ViewType.Text.self)
		XCTAssertEqual(try badge.string(), "LIVE")
		XCTAssertEqual(try badge.accessibilityIdentifier(), "badgeItem")
	}

	func testAsyncImagePhases() throws {
		let item = ItemModel()
		let images = [ItemImageModel(itemImageUrl: "https://service.handbid.com/sample_image.jpeg")]

		let selectedImage = Binding<String?>(wrappedValue: nil)
		let remainingTime = Binding<Int>(wrappedValue: 30)
		let progress = Binding<CGFloat>(wrappedValue: 0.5)
		let loadImages = Binding<Bool>(wrappedValue: true)

		let view = ImageGalleryView(
			selectedImage: selectedImage,
			remainingTime: remainingTime,
			progress: progress,
			loadImages: loadImages,
			item: item,
			images: images,
			resetTimer: {}
		)

		let hostingController = UIHostingController(rootView: view)
		XCTAssertNotNil(hostingController.view)

		let asyncImage = try view.inspect().find(ViewType.AsyncImage.self)

		loadImages.wrappedValue = false
		if let progressView = try? asyncImage.find(ViewType.ProgressView.self) {
			let identifier = try progressView.accessibilityIdentifier()
			XCTAssertTrue(identifier == "loadingSelectedImage" || identifier == "loadingFirstImage", "Unexpected identifier: \(identifier)")
		}

		loadImages.wrappedValue = true
		if let imageView = try? asyncImage.find(ViewType.Image.self) {
			let identifier = try imageView.accessibilityIdentifier()
			XCTAssertTrue(
				identifier == "selectedImage" ||
					identifier == "firstImage" ||
					identifier == "selectedImageError" ||
					identifier == "firstImageError",
				"Unexpected identifier during success or failure: \(identifier)"
			)
		}
		else {
			XCTFail("Image view not found in AsyncImage after loading images.")
		}

		// Testowanie fazy błędu (failure)
		selectedImage.wrappedValue = nil
		loadImages.wrappedValue = true
		if let errorImageView = try? asyncImage.find(ViewType.Image.self) {
			let identifier = try errorImageView.accessibilityIdentifier()
			XCTAssertTrue(identifier == "selectedImageError" || identifier == "firstImageError", "Unexpected identifier: \(identifier)")
		}
	}

	func testRenderingEmptySpacesInGrid() throws {
		let item = ItemModel()
		let images = [ItemImageModel(itemImageUrl: "https://service.handbid.com/sample_image.jpeg")]

		let selectedImage = Binding<String?>(wrappedValue: nil)
		let remainingTime = Binding<Int>(wrappedValue: 30)
		let progress = Binding<CGFloat>(wrappedValue: 0.5)
		let loadImages = Binding<Bool>(wrappedValue: true)

		let view = ImageGalleryView(
			selectedImage: selectedImage,
			remainingTime: remainingTime,
			progress: progress,
			loadImages: loadImages,
			item: item,
			images: images,
			resetTimer: {}
		)

		let hostingController = UIHostingController(rootView: view)
		XCTAssertNotNil(hostingController.view)

		let emptySlots = try view.inspect().find(ViewType.LazyVGrid.self).findAll(ViewType.Color.self)

		let totalSlots = 6
		let expectedEmptySlotsCount = totalSlots - images.count
		XCTAssertEqual(emptySlots.count, expectedEmptySlotsCount)
	}

	func testProgressIndicatorAndFooter() throws {
		let item = ItemModel()
		let images = [ItemImageModel(itemImageUrl: "https://service.handbid.com/sample_image.jpeg")]

		let selectedImage = Binding<String?>(wrappedValue: nil)
		let remainingTime = Binding<Int>(wrappedValue: 30)
		let progress = Binding<CGFloat>(wrappedValue: 0.5)
		let loadImages = Binding<Bool>(wrappedValue: true)

		let view = ImageGalleryView(
			selectedImage: selectedImage,
			remainingTime: remainingTime,
			progress: progress,
			loadImages: loadImages,
			item: item,
			images: images,
			resetTimer: {}
		)

		let hostingController = UIHostingController(rootView: view)
		XCTAssertNotNil(hostingController.view)

		let progressIndicator = try view.inspect().find(ViewType.View<ProgressIndicatorView>.self)
		XCTAssertEqual(try progressIndicator.accessibilityIdentifier(), "progressIndicator")

		let footerText = try view.inspect().find(ViewType.Text.self)
	}
}
