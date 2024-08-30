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
											case let .success(image):
												image.resizable()
													.scaledToFit()
													.clipped()
													.accessibilityIdentifier("selectedImage")
											case .failure:
												Image(systemName: "default_photo")
													.resizable()
													.scaledToFit()
													.clipped()
													.accessibilityIdentifier("selectedImageError")
											@unknown default:
												EmptyView()
											}
										}
									}
									else if !images.isEmpty, let firstImage = images.first?.itemImageUrl, let firstImageUrl = URL(string: firstImage) {
										AsyncImage(url: firstImageUrl) { phase in
											switch phase {
											case .empty:
												ProgressView()
											case let .success(image):
												image.resizable()
													.scaledToFit()
													.clipped()
													.accessibilityIdentifier("firstImage")
											case .failure:
												Image(systemName: "default_photo")
													.resizable()
													.scaledToFit()
													.clipped()
													.accessibilityIdentifier("firstImageError")
											@unknown default:
												EmptyView()
											}
										}
									}
									else if let fallbackImageUrl = item.imageUrl, let url = URL(string: fallbackImageUrl) {
										AsyncImage(url: url) { phase in
											switch phase {
											case .empty:
												ProgressView()
											case let .success(image):
												image.resizable()
													.scaledToFit()
													.clipped()
													.accessibilityIdentifier("fallbackImage")
											case .failure:
												Image(systemName: "default_photo")
													.resizable()
													.scaledToFit()
													.clipped()
													.accessibilityIdentifier("fallbackImageError")
											@unknown default:
												EmptyView()
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

					if item.isLive ?? false || item.isDirectPurchaseItem ?? false {
						Text(item.isLive ?? false ? "LIVE" : "FOR SALE")
							.font(.caption)
							.fontWeight(.medium)
							.foregroundColor(.white)
							.padding(5)
							.background(item.isLive ?? false ? Color.green : Color.accentViolet)
							.cornerRadius(20)
							.padding([.top, .trailing], 10)
							.accessibilityIdentifier("badgeItem")
					}
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

								if let imageUrl = image.itemImageUrl, let url = URL(string: imageUrl), loadImages {
									AsyncImage(url: url) { phase in
										switch phase {
										case .empty:
											ProgressView()
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
												.accessibilityIdentifier("galleryImage_\(imageUrl)")
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
												.accessibilityIdentifier("galleryImageError")
										@unknown default:
											EmptyView()
										}
									}
								}
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
						.padding(5)
						.accessibilityIdentifier("progressIndicator")
					Text("This screen will close in \(remainingTime) seconds.")
						.font(.callout)
						.fontWeight(.light)
						.padding(.leading, 5)
						.accessibilityIdentifier("remainingTimeText")
					Spacer()
				}
				.padding(3)
			}
		}
	}
}
