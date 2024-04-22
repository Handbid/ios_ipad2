// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct AuctionTopBarCenterView: View {
	var title: String
	var status: String
	var date: TimeInterval
	var countItems: Int

	@ObservedObject var deviceContext = DeviceContext()

	var body: some View {
		VStack(alignment: .center, spacing: 2) {
			Text(title)
				.font(.headline)
				.foregroundColor(.primary)
			HStack(spacing: deviceContext.isPhone ? 0 : 5) {
				Text(status)
					.font(deviceContext.isPhone ? .caption2 : .caption)
					.foregroundColor(.green)
					.bold()
				Text("•")
					.font(deviceContext.isPhone ? .caption2 : .subheadline)
					.foregroundColor(.accentGrayForm)
				Text(convertTimestampToDate(timestamp: date))
					.font(deviceContext.isPhone ? .caption2 : .caption)
					.foregroundColor(.primary)
					.lineLimit(1)
				Text("•")
					.font(deviceContext.isPhone ? .caption2 : .subheadline)
					.foregroundColor(.accentGrayForm)
				Text("\(countItems) Items")
					.font(deviceContext.isPhone ? .caption2 : .caption)
					.foregroundColor(.primary)
			}
		}
	}
}
