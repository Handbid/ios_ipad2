// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct Sidebar: View {
	@Binding var selectedView: MainContainerTypeView

	var body: some View {
		VStack(alignment: .leading, spacing: 20) {
			Button("Auction") {
				selectedView = .auction
			}
			Button("Paddle") {
				selectedView = .paddle
			}
		}
		.padding(10)
		.frame(minWidth: 200, idealWidth: 250, maxWidth: 300, maxHeight: .infinity)
		.background(Color.white)
		.foregroundColor(.black)
	}
}
