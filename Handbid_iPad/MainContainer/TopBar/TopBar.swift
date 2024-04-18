// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct TopBar: View {
	var content: TopBarContent

	static let barHeight: CGFloat = 60

	var body: some View {
		HStack {
			ForEach(Array(content.leftViews.enumerated()), id: \.offset) { _, view in view }
			Spacer()
			content.centerView
			Spacer()
			ForEach(Array(content.rightViews.enumerated()), id: \.offset) { _, view in view }
		}
		.padding([.vertical, .leading, .trailing], 10)
		.frame(height: TopBar.barHeight)
		.background(Color.blue)
		.foregroundColor(.white)
	}
}
