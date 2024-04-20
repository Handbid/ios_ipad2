// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct TopBar: View {
	var content: TopBarContent
	let centerViewWidthRatio: CGFloat = 0.6
	static let barHeight: CGFloat = 60

	var body: some View {
		HStack {
			HStack {
				ForEach(Array(content.leftViews.enumerated()), id: \.offset) { _, view in
					view
				}
			}
			.frame(width: 90)
			.frame(maxHeight: .infinity)
			.clipped()
			Spacer()
			content.centerView
			Spacer()

			HStack {
				ForEach(Array(content.rightViews.enumerated()), id: \.offset) { _, view in view }
			}
			.frame(width: 120)
			.frame(maxHeight: .infinity)
			.clipped()
			.padding(.trailing, 10)
		}
		.padding([.vertical, .leading, .trailing], 0)
		.frame(height: TopBar.barHeight)
		.background(Color(UIColor.systemBackground))
		.foregroundColor(Color(UIColor.label))
	}
}
