// Copyright (c) 2024 by Handbid. All rights reserved.

import ProgressIndicatorView
import SwiftUI

struct ImageGalleryView: View {
	@ObservedObject var detailState: ItemDetailState
	@Binding var loadImages: Bool
	let item: ItemModel
	let images: [ItemImageModel]

	var body: some View {
		VStack(spacing: 10) {
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
										let imageUrlString = detailState.selectedImage ?? images.first?.itemImageUrl ?? item.imageUrl
										if let imageUrlString, let url = URL(string: imageUrlString) {
											AsyncImage(url: url) { phase in
												switch phase {
												case .empty:
													ProgressView()
												case let .success(image):
													image.resizable()
														.scaledToFit()
														.clipped()
														.cornerRadius(15)
												case .failure:
													Image("default_photo")
														.resizable()
														.scaledToFit()
														.clipped()
														.cornerRadius(15)
												@unknown default:
													EmptyView()
												}
											}
											.id(imageUrlString)
										}
										else {
											Image("default_photo")
												.resizable()
												.scaledToFit()
												.clipped()
												.cornerRadius(15)
										}
									}
								}
							)
							.cornerRadius(15)
							.padding([.horizontal, .top])
							.onTapGesture {
								detailState.resetTimer()
							}
							.accessibilityAction {
								detailState.resetTimer()
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
											imageLoader(
												phase: phase,
												imageUrl: imageUrl,
												index: index,
												itemWidth: itemWidth,
												itemHeight: itemHeight
											)
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
				}
			}
			.frame(height: UIScreen.main.bounds.height * 0.75)

			Spacer()

			HStack {
				ProgressIndicatorView(
					isVisible: .constant(true),
					type: .circle(
						progress: $detailState.progress,
						lineWidth: 3,
						strokeColor: .accentViolet,
						backgroundColor: .accentLightViolet
					)
				)
				.frame(width: 14, height: 14)
				.padding(5)
				.accessibilityLabel("Progress indicator")
				.accessibilityIdentifier("progressIndicator")

				Text("Screen will close in \(detailState.remainingTime) seconds")
					.font(.callout)
					.fontWeight(.light)
					.padding(.leading, 5)
					.accessibilityLabel("Screen will close in \(detailState.remainingTime) seconds")
					.accessibilityIdentifier("remainingTimeText")
				Spacer()
			}
			.accessibilityIdentifier("footer")
			.padding(3)
		}
		.accessibilityIdentifier("imageGalleryView")
		.onAppear {
			if detailState.selectedImage == nil {
				detailState.selectedImage = images.first?.itemImageUrl ?? item.imageUrl
			}
		}
	}

	@ViewBuilder
	private func imageLoader(
		phase: AsyncImagePhase,
		imageUrl: String? = nil,
		index: Int = 0,
		itemWidth: CGFloat? = nil,
		itemHeight: CGFloat? = nil
	) -> some View {
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
					if let imageUrl {
						detailState.selectedImage = imageUrl
					}
				}
				.accessibilityLabel("Image loaded successfully")
				.accessibilityIdentifier("loadedImage_\(index)")
				.overlay(
					RoundedRectangle(cornerRadius: 10)
						.stroke(detailState.selectedImage == imageUrl ? Color.blue : Color.clear, lineWidth: 2)
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
