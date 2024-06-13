// Copyright (c) 2024 by Handbid. All rights reserved.

import ProgressIndicatorView
import SwiftUI

struct AuctionView: View {
	@ObservedObject var viewModel: AuctionViewModel
	@State var categories: [CategoryModel] = []
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
				Color.black.opacity(0.5)
					.onTapGesture {
						withAnimation {
							showDetailView = false
						}
					}

				ZStack {
					ItemDetailView(item: selectedItem, isVisible: $showDetailView)
						.transition(.move(edge: .bottom))
						.animation(.easeInOut(duration: 0.4), value: showDetailView)
						.padding(10)
						.background(Color.accentViolet.opacity(0.5))
				}
			}
		}
	}

	private var noItemsView: some View {
		VStack {
			Spacer()

			ZStack {
				Circle()
					.stroke(Color.accentViolet.opacity(0.3), lineWidth: 1.0)
					.frame(width: 100, height: 100, alignment: .center)

				Image("noItemsIcon")
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: 50, height: 50, alignment: .center)
			}
			.padding()

			Text(LocalizedStringKey("auction_label_noItems"))
				.applyTextStyle(style: .body)

			Spacer()
		}
	}

	private var categoriesList: some View {
		ScrollView(.vertical) {
			LazyVStack {
				ForEach(categories, id: \.id) { category in
					createCategoryView(for: category)
				}
			}
		}
	}

	private func createCategoryView(for category: CategoryModel) -> AnyView {
		AnyView(VStack {
			Text(category.name ?? "nil")
				.applyTextStyle(style: .subheader)
				.padding()

			ScrollView(.horizontal) {
				LazyHStack {
					ForEach(category.items ?? [], id: \.id) { item in
						ItemView(item: item)
							.onTapGesture {
								withAnimation {
									selectedItem = item
									showDetailView = true
								}
							}
					}
					.padding()
				}
			}
			.defaultScrollAnchor(.leading)
			.frame(height: 370)
		})
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
						HStack {
							ImageGalleryView(selectedImage: $selectedImage, remainingTime: $remainingTime, progress: $progress, images: images, resetTimer: resetTimer)
							VStack(spacing: 0) {
								ScrollView {
									DetailInfoView(isVisible: $isVisible, resetTimer: resetTimer)
										.background(Color.white)
										.frame(maxHeight: .infinity)
										.clipped()
								}
								.simultaneousGesture(DragGesture().onChanged { _ in resetTimer() })
								ButtonSectionView(item: item, resetTimer: resetTimer)
									.background(Color.white)
									.frame(maxWidth: .infinity)
									.clipped()
									.padding()
							}
						}
						.padding(.top, 10)
					}
					else {
						VStack {
							HStack {
								Spacer()
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
								.padding([.top, .trailing], 20)
							}
							ScrollView {
								VStack(spacing: 0) {
									ImageGalleryView(selectedImage: $selectedImage, remainingTime: $remainingTime, progress: $progress, images: images, resetTimer: resetTimer)
										.frame(height: geometry.size.height * 0.5)
									DetailInfoView(isVisible: $isVisible, resetTimer: resetTimer)
										.background(Color.white)
										.frame(maxHeight: .infinity)
										.clipped()
								}
							}
							.simultaneousGesture(DragGesture().onChanged { _ in resetTimer() })
							ButtonSectionView(item: item, resetTimer: resetTimer)
								.background(Color.white)
								.frame(maxWidth: .infinity)
								.padding(.bottom, 10)
						}
						.padding(.horizontal, 10)
						.padding(.top, 10)
					}
				}
				.background(Color.white)
				.cornerRadius(20)
				.offset(y: offset)
				.gesture(
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
				)
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
								.padding([.top, .trailing], 20)
							}
						}
					}
					Spacer()
				}
			}
			.gesture(
				TapGesture()
					.onEnded {
						resetTimer()
					}
			)
		}
		.background(Color.clear)
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
								}
								else if let firstImage = images.first {
									Image(firstImage)
										.resizable()
										.scaledToFit()
										.clipped()
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
						.fontWeight(.bold)
						.foregroundColor(.white)
						.padding(5)
						.background(Color.green)
						.cornerRadius(5)
						.padding([.top, .trailing], 10)
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
					Text("This screen will close in \(remainingTime) seconds.")
						.foregroundColor(.black)
						.fontWeight(.light)
						.padding(.leading, 5)
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
			Text("Category Name #123 | 12 BIDS")
				.font(.headline)
				.foregroundColor(.gray)

			Text("Item Description - Name and List of Included Items")
				.font(.title2)
				.fontWeight(.bold)

			HStack(spacing: 30) {
				VStack(alignment: .leading) {
					Text("VALUE")
						.font(.caption)
						.foregroundColor(.gray)
					Text("$5,000.00")
						.font(.headline)
				}
				VStack(alignment: .leading) {
					Text("INCREMENT")
						.font(.caption)
						.foregroundColor(.gray)
					Text("$100.00")
						.font(.headline)
				}
				VStack(alignment: .leading) {
					Text("BUY NOW")
						.font(.caption)
						.foregroundColor(.gray)
					Text("$3,200.00")
						.font(.headline)
				}
			}

			Text("Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet. Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet. Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet. Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet. Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet. Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet. Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet. Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet. Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.")
				.font(.body)
				.padding(.vertical)
				.onTapGesture {
					resetTimer()
				}

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
				TextField("", text: .constant("$99,99"))
					.padding()
					.background(Color(white: 0.9))
					.cornerRadius(10)
					.frame(width: 100, height: 40)
				Button(action: {
					resetTimer()
				}) {
					Text("+")
						.padding()
						.frame(width: 40, height: 40)
						.background(Color(white: 0.9))
						.cornerRadius(10)
				}
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
			}
		}
	}
}
