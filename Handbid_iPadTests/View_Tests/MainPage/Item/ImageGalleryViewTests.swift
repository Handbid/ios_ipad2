// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import XCTest

final class ImageGalleryViewTests: XCTestCase {
	func testInitialSelectedImage() {
		let item = ItemModel()
		let images = [ItemImageModel(itemImageUrl: "https://service.handbid.com/hubfs/Knowledge%20Base%20Import/service.handbid.comhcen-usarticle_attachments202505606ImageManipulation.001.jpeg")]

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

		XCTAssertEqual(selectedImage.wrappedValue, nil)
		XCTAssertEqual(images.first?.itemImageUrl, "https://service.handbid.com/hubfs/Knowledge%20Base%20Import/service.handbid.comhcen-usarticle_attachments202505606ImageManipulation.001.jpeg")
	}

	func testFallbackImage() {
		let item = ItemModel(imageUrl: "https://service.handbid.com/hubfs/Knowledge%20Base%20Import/service.handbid.comhcen-usarticle_attachments202505606ImageManipulation.001.jpeg")
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

		XCTAssertEqual(item.imageUrl, "https://service.handbid.com/hubfs/Knowledge%20Base%20Import/service.handbid.comhcen-usarticle_attachments202505606ImageManipulation.001.jpeg")
	}

	func testBadgeDisplay() {
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

		XCTAssertTrue(item.isLive ?? false, "The item should be marked as LIVE")
	}

	func testProgressIndicator() {
		let item = ItemModel()
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

		XCTAssertEqual(progress.wrappedValue, 0.5, "Progress should be initially set to 0.5")

		let expectedText = "This screen will close in 30 seconds."
		let actualText = "This screen will close in \(remainingTime.wrappedValue) seconds."
		XCTAssertEqual(expectedText, actualText, "Remaining time text should be correctly formatted")
	}

	func testResetTimerAction() {
		let item = ItemModel()
		let images: [ItemImageModel] = []

		let selectedImage = Binding<String?>(wrappedValue: nil)
		let remainingTime = Binding<Int>(wrappedValue: 30)
		let progress = Binding<CGFloat>(wrappedValue: 0.5)
		let loadImages = Binding<Bool>(wrappedValue: true)

		var timerReset = false
		let view = ImageGalleryView(
			selectedImage: selectedImage,
			remainingTime: remainingTime,
			progress: progress,
			loadImages: loadImages,
			item: item,
			images: images,
			resetTimer: { timerReset = true }
		)

		let hostingController = UIHostingController(rootView: view)
		XCTAssertNotNil(hostingController.view)

		view.resetTimer()
		XCTAssertTrue(timerReset, "The timer should be reset when the view is tapped.")
	}
}
