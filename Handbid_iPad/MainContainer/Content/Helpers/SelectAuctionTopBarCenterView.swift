// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct SelectAuctionTopBarCenterView: View {
	var title: String
	var countAuctions: Int
	var deviceContext = DeviceContext()

	var body: some View {
		VStack(alignment: .center, spacing: 2) {
			Text(title)
				.font(.headline)
				.foregroundColor(.primary)
			Text("\(countAuctions) \(String(format: NSLocalizedString("topBar_label_auctions", comment: "")))")
				.font(deviceContext.isPhone ? .caption2 : .caption)
				.foregroundColor(.primary)
		}
	}
}
