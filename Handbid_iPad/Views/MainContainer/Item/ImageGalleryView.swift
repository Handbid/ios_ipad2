// Copyright (c) 2024 by Handbid. All rights reserved.

import ProgressIndicatorView
import SwiftUI

struct ImageGalleryView: View {
	@Binding var selectedImage: String?
	@Binding var remainingTime: Int
	@Binding var progress: CGFloat
	@Binding var loadImages: Bool
	let item: ItemModel
	let images: [ItemImageModel]
	let resetTimer: () -> Void

	var body: some View {
		GeometryReader { geometry in
			let itemWidth = (geometry.size.width - 50) / 4
			let itemHeight = itemWidth * 9 / 13

			VStack(spacing: 10) {
				ZStack(alignment: .topTrailing) {
					Rectangle()
						.foregroundColor(Color.accentGrayForm.opacity(0.2))
						.overlay(
							Group {
								if loadImages {
									if let selectedImageUrl = selectedImage, let url = URL(string: selectedImageUrl) {
										AsyncImage(url: url) { phase in
											imageLoader(phase: phase)
										}
									}
									else if let firstImageUrl = images.first?.itemImageUrl, let url = URL(string: firstImageUrl) {
										AsyncImage(url: url) { phase in
											imageLoader(phase: phase)
										}
									}
									else if let fallbackImageUrl = item.imageUrl, let url = URL(string: fallbackImageUrl) {
										AsyncImage(url: url) { phase in
											imageLoader(phase: phase)
										}
									}
								}
							}
						)
						.cornerRadius(15)
						.padding([.horizontal, .top])
						.onTapGesture {
							resetTimer()
						}
						.accessibilityAction {
							resetTimer()
						}
						.accessibilityIdentifier("imageOverlay")

					if item.isLive ?? false || item.isDirectPurchaseItem ?? false {
						Text(item.isLive ?? false ? "LIVE" : "FOR SALE")
							.font(.caption)
							.fontWeight(.medium)
							.foregroundColor(.white)
							.padding(5)
							.background(item.isLive ?? false ? Color.green : Color.accentViolet)
							.cornerRadius(20)
							.padding([.top, .trailing], 10)
							.accessibilityLabel(item.isLive ?? false ? "Live item" : "Item for sale")
							.accessibilityIdentifier("badgeItem")
					}
				}
				.frame(height: geometry.size.height * 0.50)

				ScrollView(.vertical, showsIndicators: false) {
					LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
						ForEach(Array(images.enumerated()), id: \.offset) { index, image in
							ZStack {
								Rectangle()
									.foregroundColor(Color.accentGrayBackground)
									.aspectRatio(13 / 9, contentMode: .fit)
									.cornerRadius(15)
									.accessibilityIdentifier("imageSlot_\(index)")

								if let imageUrl = image.itemImageUrl, let url = URL(string: imageUrl), loadImages {
									AsyncImage(url: url) { phase in
										imageLoader(phase: phase, selectedImage: selectedImage, imageUrl: imageUrl, index: index, itemWidth: itemWidth, itemHeight: itemHeight)
									}
								}
							}
						}

						if images.count < 4 {
							ForEach(images.count ..< 4, id: \.self) { _ in
								Color.clear
									.frame(width: itemWidth, height: itemHeight)
									.accessibilityIdentifier("emptySlot")
							}
						}
					}
					.padding(.horizontal)
					.accessibilityIdentifier("imageGrid")
				}
				.frame(height: geometry.size.height * 0.35)

				Spacer()

				HStack {
					ProgressIndicatorView(isVisible: .constant(true), type: .circle(progress: $progress, lineWidth: 3, strokeColor: .accentViolet, backgroundColor: .accentLightViolet))
						.frame(width: 14, height: 14)
						.padding(5)
						.accessibilityLabel("Progress indicator")
						.accessibilityIdentifier("progressIndicator")
					Text("\(String(format: NSLocalizedString("itemGallery_label_screenClose", comment: ""))) \(remainingTime) \(String(format: NSLocalizedString("itemGallery_label_seconds", comment: ""))).")
						.font(.callout)
						.fontWeight(.light)
						.padding(.leading, 5)
						.accessibilityLabel("Screen will close in \(remainingTime) seconds")
						.accessibilityIdentifier("remainingTimeText")
					Spacer()
				}
				.accessibilityIdentifier("footer")
				.padding(3)
			}
			.accessibilityIdentifier("imageGalleryView")
		}
	}

	@ViewBuilder
	private func imageLoader(phase: AsyncImagePhase, selectedImage: String? = nil, imageUrl: String? = nil, index: Int = 0, itemWidth: CGFloat = 0, itemHeight: CGFloat = 0) -> some View {
		switch phase {
		case .empty:
			ProgressView()
				.accessibilityLabel("Loading image")
				.accessibilityIdentifier("loadingImage_\(index)")
		case let .success(image):
			image.resizable()
				.scaledToFit()
				.clipped()
				.background(Color.accentGrayBackground)
				.frame(width: itemWidth, height: itemHeight)
				.cornerRadius(10)
				.onTapGesture {
					self.selectedImage = imageUrl
				}
				.accessibilityLabel("Image loaded successfully")
				.accessibilityIdentifier("loadedImage_\(index)")
				.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(selectedImage == imageUrl ? Color.blue : Color.clear, lineWidth: 2)
				)
		case .failure:
			Image("default_photo")
				.resizable()
				.scaledToFit()
				.clipped()
				.background(Color.accentGrayBackground)
				.frame(width: itemWidth, height: itemHeight)
				.cornerRadius(10)
				.accessibilityLabel("Image failed to load")
				.accessibilityIdentifier("imageError_\(index)")
		@unknown default:
			EmptyView()
		}
	}
}
