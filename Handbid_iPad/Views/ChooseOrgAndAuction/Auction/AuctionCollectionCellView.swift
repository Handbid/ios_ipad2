// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct AuctionCollectionCellView<T: PageProtocol>: View {
	@EnvironmentObject var coordinator: Coordinator<T, Any?>
	@Environment(\.colorScheme) private var defaultColorScheme
	var colorScheme: ColorScheme? = nil
	let auction: AuctionModel
	var inspection = Inspection<Self>()

	var body: some View {
		let colorScheme = colorScheme ?? defaultColorScheme

		Button(action: {
			coordinator.push(MainContainerPage.mainContainer as! T)
		}) {
			VStack(alignment: .center, spacing: 10) {
				VStack {
					HStack {
						HStack(spacing: 5) {
							Text("\(auction.totalItems ?? 0) ")
							Text(LocalizedStringKey("auction_label_items"))
						}
						.padding(10)
						.background(colorScheme == .dark ? Color.white : Color.black)
						.foregroundColor(colorScheme == .dark ? .black : .white)
						.bold()
						.cornerRadius(30)
						.frame(height: 30)
						.accessibilityIdentifier("auctionItemsLabel")

						Spacer()

						Text(auction.status?.uppercased() ?? "")
							.bold()
							.foregroundColor(AuctionStateStatuses.color(for: auction.status!, in: colorScheme))
							.accessibilityIdentifier("auctionStatusLabel")
					}
					.padding([.leading, .trailing], 10)
				}
				.frame(height: 50)

				Spacer(minLength: 0)

				AsyncImage(url: URL(string: auction.imageUrl ?? "")) { phase in
					switch phase {
					case .empty:
						ProgressView()
							.progressViewStyle(CircularProgressViewStyle())
							.scaleEffect(1.5)
							.frame(maxWidth: .infinity, maxHeight: .infinity)
							.accessibilityIdentifier("auctionImageEmpty")
					case let .success(image):
						image.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 150, height: 150, alignment: .center)
							.cornerRadius(10)
							.accessibilityIdentifier("auctionImage")
					case .failure:
						Image(systemName: "photo")
							.resizable()
							.scaledToFit()
							.foregroundColor(colorScheme == .dark ? .white : .gray)
							.frame(width: 150, height: 150, alignment: .center)
							.padding()
							.accessibilityIdentifier("auctionImageError")
					@unknown default:
						EmptyView()
					}
				}
				.frame(height: 150)

				VStack(spacing: 10) {
					Text(auction.name ?? "")
						.font(.headline)
						.bold()
						.lineLimit(3)
						.multilineTextAlignment(.center)
						.truncationMode(.tail)
						.foregroundColor(colorScheme == .dark ? .white : .black)
						.accessibilityIdentifier("auctionNameLabel")

					Text(auction.auctionAddressStreet1 ?? "")
						.font(.subheadline)
						.bold()
						.lineLimit(2)
						.multilineTextAlignment(.center)
						.truncationMode(.tail)
						.foregroundColor(colorScheme == .dark ? .white : .black)
						.accessibilityIdentifier("auctionAddressLabel")

					HStack {
						Spacer()
						Image(systemName: "clock")
							.foregroundColor(colorScheme == .dark ? .white : .black)
						Text(convertTimestampToDate(timestamp: TimeInterval(auction.endTime ?? 0)))
							.font(.caption)
							.foregroundColor(colorScheme == .dark ? .white : .black)
						Spacer()
					}
					.accessibilityIdentifier("auctionEndTimeLabel")
				}
				.frame(height: 100)
				.frame(maxWidth: .infinity)

				Spacer(minLength: 0)
			}
			.padding()
			.frame(width: 307, height: 370)
			.background(colorScheme == .dark ? Color.black : Color.white)
			.cornerRadius(40)
			.shadow(color: Color.accentGrayBorder.opacity(0.6), radius: 10, x: 0, y: 2)
		}
		.accentColor(colorScheme == .dark ? .white : .black)
		.accessibilityIdentifier("auctionCellButton")
		.onReceive(inspection.notice) {
			inspection.visit(self, $0)
		}
	}
}
