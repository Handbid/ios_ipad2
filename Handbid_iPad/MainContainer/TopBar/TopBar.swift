// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct TopBar: View {
	var content: TopBarContent
	static let barHeight: CGFloat = 60

	var body: some View {
		HStack {
			leftViews
			CenteredView(view: content.centerView)
			rightViews
		}
		.frame(height: TopBar.barHeight)
		.background(Color(UIColor.systemBackground))
		.foregroundColor(Color(UIColor.label))
	}

	private var leftViews: some View {
		HStack {
			ForEach(Array(content.leftViews.enumerated()), id: \.offset) { _, view in
				view
			}
		}
		.frame(width: 90)
		.frame(maxHeight: .infinity)
		.clipped()
	}

	private var rightViews: some View {
		HStack {
			ForEach(Array(content.rightViews.enumerated()), id: \.offset) { _, view in
				view
			}
		}
		.frame(width: 120)
		.padding(.trailing, 10)
		.frame(maxHeight: .infinity)
		.clipped()
	}
}

struct CenteredView<Content: View>: View {
	var view: Content

	var body: some View {
		HStack {
			Spacer()
			view
			Spacer()
		}
	}
}
