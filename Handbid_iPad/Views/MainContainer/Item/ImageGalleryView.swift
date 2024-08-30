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
									if let selectedImageUrl = selectedImage {
										AsyncImage(url: URL(string: selectedImageUrl)) { phase in
											switch phase {
											case .empty:
												ProgressView()
													.accessibilityLabel("Loading image")
													.accessibilityIdentifier("loadingSelectedImage")
											case let .success(image):
												image.resizable()
													.scaledToFit()
													.clipped()
													.accessibilityLabel("Selected image")
													.accessibilityIdentifier("selectedImage")
											case .failure:
												Image(systemName: "default_photo")
													.resizable()
													.scaledToFit()
													.clipped()
													.accessibilityLabel("Image failed to load")
													.accessibilityIdentifier("selectedImageError")
											@unknown default:
												EmptyView()
													.accessibilityIdentifier("unknownImagePhase")
											}
										}
									}
									else if !images.isEmpty, let firstImage = images.first?.itemImageUrl, let firstImageUrl = URL(string: firstImage) {
										AsyncImage(url: firstImageUrl) { phase in
											switch phase {
											case .empty:
												ProgressView()
													.accessibilityLabel("Loading first image")
													.accessibilityIdentifier("loadingFirstImage")
											case let .success(image):
												image.resizable()
													.scaledToFit()
													.clipped()
													.accessibilityLabel("First image in gallery")
													.accessibilityIdentifier("firstImage")
											case .failure:
												Image(systemName: "default_photo")
													.resizable()
													.scaledToFit()
													.clipped()
													.accessibilityLabel("First image failed to load")
													.accessibilityIdentifier("firstImageError")
											@unknown default:
												EmptyView()
													.accessibilityIdentifier("unknownImagePhase")
											}
										}
									}
									else if let fallbackImageUrl = item.imageUrl, let url = URL(string: fallbackImageUrl) {
										AsyncImage(url: url) { phase in
											switch phase {
											case .empty:
												ProgressView()
													.accessibilityLabel("Loading fallback image")
													.accessibilityIdentifier("loadingFallbackImage")
											case let .success(image):
												image.resizable()
													.scaledToFit()
													.clipped()
													.accessibilityLabel("Fallback image")
													.accessibilityIdentifier("fallbackImage")
											case .failure:
												Image(systemName: "default_photo")
													.resizable()
													.scaledToFit()
													.clipped()
													.accessibilityLabel("Fallback image failed to load")
													.accessibilityIdentifier("fallbackImageError")
											@unknown default:
												EmptyView()
													.accessibilityIdentifier("unknownImagePhase")
											}
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
										switch phase {
										case .empty:
											ProgressView()
												.accessibilityLabel("Loading gallery image")
												.accessibilityIdentifier("loadingGalleryImage_\(index)")
										case let .success(image):
											image.resizable()
												.scaledToFit()
												.clipped()
												.background(Color.accentGrayBackground)
												.frame(width: itemWidth, height: itemHeight)
												.cornerRadius(10)
												.onTapGesture {
													selectedImage = imageUrl
													resetTimer()
												}
												.accessibilityLabel("Gallery image")
												.accessibilityIdentifier("galleryImage_\(index)")
												.overlay(
													RoundedRectangle(cornerRadius: 10)
														.stroke(selectedImage == imageUrl ? Color.blue : Color.clear, lineWidth: 2)
												)
										case .failure:
											Image(systemName: "default_photo")
												.resizable()
												.scaledToFit()
												.clipped()
												.background(Color.accentGrayBackground)
												.frame(width: itemWidth, height: itemHeight)
												.cornerRadius(10)
												.accessibilityLabel("Gallery image failed to load")
												.accessibilityIdentifier("galleryImageError_\(index)")
										@unknown default:
											EmptyView()
												.accessibilityIdentifier("unknownGalleryImagePhase_\(index)")
										}
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
					Text("This screen will close in \(remainingTime) seconds.")
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
}
