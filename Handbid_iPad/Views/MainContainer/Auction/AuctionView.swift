// Copyright (c) 2024 by Handbid. All rights reserved.

import ProgressIndicatorView
import SwiftUI

struct AuctionView: View {
	@ObservedObject var viewModel: AuctionViewModel
	@State private var categories: [CategoryModel] = []
	@State private var selectedItem: ItemModel? = nil
	@State private var showDetailView: Bool = false

	init(viewModel: AuctionViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		ZStack {
			VStack {
				if categories.isEmpty {
					noItemsView
				}
				else {
					categoriesList
				}
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(Color(.systemBackground))
			.edgesIgnoringSafeArea(.all)
			.onReceive(viewModel.$categories) { categories in
				self.categories = categories
			}
			.onAppear {
				viewModel.refreshData()
			}

			if let selectedItem, showDetailView {
				overlayView
				itemDetailView(for: selectedItem)
			}
		}
	}

	private var noItemsView: some View {
		VStack {
			Spacer()
			ZStack {
				Circle()
					.stroke(Color.accentViolet.opacity(0.3), lineWidth: 1.0)
					.frame(width: 100, height: 100)
				Image("noItemsIcon")
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: 50, height: 50)
			}
			.padding()
			Text(LocalizedStringKey("auction_label_noItems"))
				.applyTextStyle(style: .body)
			Spacer()
		}
		.accessibilityIdentifier("noItemsView")
	}

	private var categoriesList: some View {
		ScrollView(.vertical) {
			LazyVStack {
				ForEach(categories, id: \.id) { category in
					CategoryView(category: category) { item in
						withAnimation {
							selectedItem = item
							showDetailView = true
						}
					}
				}
			}
		}
		.accessibilityIdentifier("categoriesList")
	}

	private var overlayView: some View {
		Color.black.opacity(0.5)
			.onTapGesture {
				withAnimation {
					showDetailView = false
				}
			}
			.accessibilityIdentifier("overlay")
	}

	private func itemDetailView(for item: ItemModel) -> some View {
		ItemDetailView(item: item, isVisible: $showDetailView)
			.transition(.move(edge: .bottom))
			.animation(.easeInOut(duration: 0.4), value: showDetailView)
			.padding(10)
			.background(Color.accentViolet.opacity(0.5))
			.accessibilityIdentifier("itemDetailView")
	}
}

struct CategoryView: View {
	let category: CategoryModel
	let onItemSelect: (ItemModel) -> Void

	var body: some View {
		VStack {
			Text(category.name ?? "nil")
				.applyTextStyle(style: .subheader)
				.padding()
				.accessibilityIdentifier("categoryName")
			ScrollView(.horizontal) {
				LazyHStack {
					ForEach(category.items ?? [], id: \.id) { item in
						ItemView(item: item)
							.onTapGesture {
								onItemSelect(item)
							}
							.accessibilityIdentifier("itemView")
					}
					.padding()
				}
			}
			.defaultScrollAnchor(.leading)
			.frame(height: 370)
		}
		.accessibilityIdentifier("categoryView")
	}
}

struct ItemDetailView: View {
	var item: ItemModel
	@Binding var isVisible: Bool
	@State private var offset: CGFloat = 0
	@State private var selectedImage: String? = nil
	@State private var timer: Timer?
	@State private var remainingTime: Int = 60
	@State private var progress: CGFloat = 1.0
	let images: [String] = ["SplashBackground", "LogoLogin"]

	var body: some View {
		GeometryReader { geometry in
			let isLandscape = geometry.size.width > geometry.size.height
			let isPad = UIDevice.current.userInterfaceIdiom == .pad

			ZStack {
				VStack(spacing: 10) {
					if isPad, isLandscape {
						landscapeView
					}
					else {
						portraitView(geometry: geometry)
					}
				}
				.background(Color.white)
				.cornerRadius(20)
				.offset(y: offset)
				.gesture(dragGesture(geometry: geometry))
				.animation(.easeInOut(duration: 0.4), value: offset)
				.onAppear {
					startTimer()
				}
				.onDisappear {
					stopTimer()
				}
				.padding(10)

				VStack {
					if isLandscape {
						HStack {
							Spacer()
							if offset == 0 {
								closeButton
							}
						}
					}
					Spacer()
				}
			}
			.gesture(TapGesture().onEnded {
				resetTimer()
			})
		}
		.background(Color.clear)
	}

	private var landscapeView: some View {
		HStack {
			ImageGalleryView(selectedImage: $selectedImage, remainingTime: $remainingTime, progress: $progress, images: images, resetTimer: resetTimer)
				.accessibilityIdentifier("imageGalleryView")
			VStack(spacing: 0) {
				ScrollView {
					DetailInfoView(isVisible: $isVisible, resetTimer: resetTimer)
						.background(Color.white)
						.frame(maxHeight: .infinity)
						.clipped()
						.accessibilityIdentifier("detailInfoView")
				}
				.simultaneousGesture(DragGesture().onChanged { _ in resetTimer() })
				ButtonSectionView(item: item, resetTimer: resetTimer)
					.background(Color.white)
					.frame(maxWidth: .infinity)
					.clipped()
					.padding()
					.accessibilityIdentifier("buttonSectionView")
			}
		}
		.padding(.top, 10)
	}

	private func portraitView(geometry: GeometryProxy) -> some View {
		VStack {
			HStack {
				Spacer()
				closeButton
					.padding([.top, .trailing], 20)
			}
			ScrollView {
				VStack(spacing: 0) {
					ImageGalleryView(selectedImage: $selectedImage, remainingTime: $remainingTime, progress: $progress, images: images, resetTimer: resetTimer)
						.frame(height: geometry.size.height * 0.5)
						.accessibilityIdentifier("imageGalleryView")
					DetailInfoView(isVisible: $isVisible, resetTimer: resetTimer)
						.background(Color.white)
						.frame(maxHeight: .infinity)
						.clipped()
						.accessibilityIdentifier("detailInfoView")
				}
			}
			.simultaneousGesture(DragGesture().onChanged { _ in resetTimer() })
			ButtonSectionView(item: item, resetTimer: resetTimer)
				.background(Color.white)
				.frame(maxWidth: .infinity)
				.padding(.bottom, 10)
				.accessibilityIdentifier("buttonSectionView")
		}
		.padding(.horizontal, 10)
		.padding(.top, 10)
	}

	private var closeButton: some View {
		Button(action: {
			withAnimation {
				isVisible = false
			}
		}) {
			Image(systemName: "xmark")
				.foregroundColor(.black)
				.padding(10)
				.background(Color(white: 0.9))
				.clipShape(Circle())
		}
		.accessibilityIdentifier("closeButton")
	}

	private func dragGesture(geometry: GeometryProxy) -> some Gesture {
		DragGesture()
			.onChanged { gesture in
				if gesture.translation.height > 0 {
					offset = gesture.translation.height
				}
				resetTimer()
			}
			.onEnded { gesture in
				if gesture.translation.height > 100 {
					withAnimation {
						offset = geometry.size.height
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
							isVisible = false
							offset = 0
						}
					}
				}
				else {
					withAnimation {
						offset = 0
					}
				}
			}
	}

	private func startTimer() {
		stopTimer()
		remainingTime = 60
		timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
			if remainingTime > 0 {
				remainingTime -= 1
				progress = CGFloat(remainingTime) / 60.0
			}
			else {
				isVisible = false
			}
		}
	}

	private func stopTimer() {
		timer?.invalidate()
		timer = nil
	}

	private func resetTimer() {
		remainingTime = 60
		progress = 1.0
	}
}

struct ImageGalleryView: View {
	@Binding var selectedImage: String?
	@Binding var remainingTime: Int
	@Binding var progress: CGFloat
	let images: [String]
	let resetTimer: () -> Void

	var body: some View {
		GeometryReader { geometry in
			let itemWidth = (geometry.size.width - 50) / 4
			let itemHeight = itemWidth * 9 / 13

			VStack(spacing: 10) {
				ZStack(alignment: .topTrailing) {
					Rectangle()
						.foregroundColor(Color.accentGrayBackground)
						.overlay(
							Group {
								if let selectedImage {
									Image(selectedImage)
										.resizable()
										.scaledToFit()
										.clipped()
										.accessibilityIdentifier("selectedImage")
								}
								else if let firstImage = images.first {
									Image(firstImage)
										.resizable()
										.scaledToFit()
										.clipped()
										.accessibilityIdentifier("firstImage")
								}
							}
						)
						.cornerRadius(15)
						.padding([.horizontal, .top])
						.onTapGesture {
							resetTimer()
						}

					Text("LIVE")
						.font(.caption)
						.fontWeight(.medium)
						.foregroundColor(.white)
						.padding(5)
						.background(Color.green)
						.cornerRadius(20)
						.padding([.top, .trailing], 10)
						.accessibilityIdentifier("liveLabel")
				}
				.frame(height: geometry.size.height * 0.50)

				ScrollView(.vertical, showsIndicators: false) {
					LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
						ForEach(Array(images.enumerated()), id: \.offset) { _, image in
							ZStack {
								Rectangle()
									.foregroundColor(Color.accentGrayBackground)
									.aspectRatio(13 / 9, contentMode: .fit)
									.cornerRadius(15)

								Image(image)
									.resizable()
									.scaledToFit()
									.clipped()
									.background(Color.accentGrayBackground)
									.frame(width: itemWidth, height: itemHeight)
									.cornerRadius(10)
									.onTapGesture {
										selectedImage = image
										resetTimer()
									}
									.accessibilityIdentifier("galleryImage_\(image)")
									.overlay(
										RoundedRectangle(cornerRadius: 10)
											.stroke(selectedImage == image ? Color.blue : Color.clear, lineWidth: 2)
									)
							}
						}

						if images.count < 4 {
							ForEach(images.count ..< 4, id: \.self) { _ in
								Color.clear
									.frame(width: itemWidth, height: itemHeight)
							}
						}
					}
					.padding(.horizontal)
				}
				.frame(height: geometry.size.height * 0.35)

				Spacer()

				HStack {
					ProgressIndicatorView(isVisible: .constant(true), type: .circle(progress: $progress, lineWidth: 3, strokeColor: .accentViolet, backgroundColor: .accentLightViolet))
						.frame(width: 14, height: 14)
						.accessibilityIdentifier("progressIndicator")
					Text("This screen will close in \(remainingTime) seconds.")
						.foregroundColor(.black)
						.fontWeight(.light)
						.padding(.leading, 5)
						.accessibilityIdentifier("remainingTimeText")
					Spacer()
				}
				.padding()
			}
		}
	}
}

struct DetailInfoView: View {
	@Binding var isVisible: Bool
	let resetTimer: () -> Void

	var body: some View {
		VStack(alignment: .leading, spacing: 15) {
			HStack {
				Spacer()
				Text("Category Name")
					.foregroundColor(.black)
					.fontWeight(.light)
					.accessibilityIdentifier("categoryName")
				Text(" | ")
					.foregroundColor(.gray)
				Text("#123")
					.foregroundColor(.black)
					.fontWeight(.light)
					.accessibilityIdentifier("itemID")
				Text(" | ")
					.foregroundColor(.gray)
				Text("12 bids")
					.foregroundColor(.accentViolet)
					.fontWeight(.light)
					.accessibilityIdentifier("bidCount")
				Spacer()
			}
			HStack {
				Spacer()
				Text("Item Description - Name and List of Included Items")
					.font(.title2)
					.fontWeight(.medium)
					.multilineTextAlignment(.center)
					.accessibilityIdentifier("itemDescription")
				Spacer()
			}

			HStack(spacing: 30) {
				Spacer()
				VStack(alignment: .leading) {
					Text("VALUE")
						.font(.caption)
						.foregroundColor(.gray)
					Text("$5,000.00")
						.font(.headline)
						.accessibilityIdentifier("itemValue")
				}
				VStack(alignment: .leading) {
					Text("INCREMENT")
						.font(.caption)
						.foregroundColor(.gray)
					Text("$100.00")
						.font(.headline)
						.accessibilityIdentifier("bidIncrement")
				}
				VStack(alignment: .trailing) {
					Text("BUY NOW")
						.font(.caption)
						.foregroundColor(.gray)
					Text("$3,200.00")
						.font(.headline)
						.accessibilityIdentifier("buyNowPrice")
				}
				Spacer()
			}

			Text("Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet. Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet. Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet. Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet. Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet. Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet. Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.")
				.font(.body)
				.padding(.vertical)
				.onTapGesture {
					resetTimer()
				}
				.accessibilityIdentifier("itemLongDescription")

			Spacer()
		}
		.padding()
		.padding(.trailing, 20)
		.onTapGesture {
			resetTimer()
		}
		.frame(maxHeight: .infinity)
		.clipped()
	}
}

struct ButtonSectionView: View {
	var item: ItemModel
	let resetTimer: () -> Void

	var body: some View {
		VStack {
			if item.itemType == "forsale" {
				specialButtons
			}
			else {
				defaultButtons
			}
		}
		.padding()
		.padding(.trailing, 20)
		.onTapGesture {
			resetTimer()
		}
	}

	private var specialButtons: some View {
		VStack {
			Button(action: {
				resetTimer()
			}) {
				Text("SPECIAL BID")
					.padding()
					.frame(maxWidth: .infinity, maxHeight: 40)
					.background(Color.red)
					.foregroundColor(.white)
					.cornerRadius(10)
			}
			.accessibilityIdentifier("specialBidButton")
		}
	}

	private var defaultButtons: some View {
		VStack {
			HStack {
				Button(action: {
					resetTimer()
				}) {
					Text("-")
						.padding()
						.frame(width: 40, height: 40)
						.background(Color(white: 0.9))
						.cornerRadius(10)
				}
				.accessibilityIdentifier("decreaseBidButton")
				TextField("", text: .constant("$99,99"))
					.padding()
					.background(Color(white: 0.9))
					.cornerRadius(10)
					.frame(width: 100, height: 40)
					.accessibilityIdentifier("bidTextField")
				Button(action: {
					resetTimer()
				}) {
					Text("+")
						.padding()
						.frame(width: 40, height: 40)
						.background(Color(white: 0.9))
						.cornerRadius(10)
				}
				.accessibilityIdentifier("increaseBidButton")
				Button(action: {
					resetTimer()
				}) {
					Text("BID NOW")
						.padding()
						.frame(maxWidth: .infinity, maxHeight: 40)
						.background(Color.black)
						.foregroundColor(.white)
						.cornerRadius(10)
				}
				.accessibilityIdentifier("bidNowButton")
			}
			.padding(.bottom, 10)

			HStack {
				Button(action: {
					resetTimer()
				}) {
					Text("SET MAX BID")
						.padding()
						.frame(maxWidth: .infinity, maxHeight: 40)
						.background(Color.purple)
						.foregroundColor(.white)
						.cornerRadius(10)
				}
				.accessibilityIdentifier("setMaxBidButton")

				Button(action: {
					resetTimer()
				}) {
					Text("BUY NOW")
						.padding()
						.frame(maxWidth: .infinity, maxHeight: 40)
						.background(Color.purple)
						.foregroundColor(.white)
						.cornerRadius(10)
				}
				.accessibilityIdentifier("buyNowButton")
			}
		}
	}
}
