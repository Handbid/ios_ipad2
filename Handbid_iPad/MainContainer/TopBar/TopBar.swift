// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

import SwiftUI

struct TopBar: View {
	var content: TopBarContentProtocol
	let barHeight: CGFloat

	init(content: TopBarContentProtocol, barHeight: CGFloat) {
		self.content = content
		self.barHeight = barHeight
	}

	var body: some View {
		HStack {
			leftViews
				.accessibilityElement(children: .contain)
				.accessibility(identifier: "LeftViews")
			CenteredView(view: content.centerView)
				.accessibilityElement(children: .contain)
				.accessibility(identifier: "CenterView")
			rightViews
				.accessibilityElement(children: .contain)
				.accessibility(identifier: "RightViews")
		}
		.frame(height: barHeight)
		.background(Color(UIColor.systemBackground))
		.foregroundColor(Color(UIColor.label))
		.accessibilityElement(children: .contain)
		.accessibility(identifier: "TopBar")
	}

	private var leftViews: some View {
		HStack {
			ForEach(Array(content.leftViews.enumerated()), id: \.offset) { _, view in
				view
					.accessibilityElement(children: .contain)
					.accessibility(identifier: "LeftView\(view)")
			}
		}
		.frame(width: 90)
		.frame(maxHeight: .infinity)
		.clipped()
		.accessibilityElement(children: .combine)
	}

	private var rightViews: some View {
		HStack {
			ForEach(Array(content.rightViews.enumerated()), id: \.offset) { _, view in
				view
					.accessibilityElement(children: .contain)
					.accessibility(identifier: "RightView\(view)")
			}
		}
		.frame(width: 120)
		.padding(.trailing, 10)
		.frame(maxHeight: .infinity)
		.clipped()
		.accessibilityElement(children: .combine)
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
		.accessibilityElement(children: .contain)
		.accessibility(identifier: "CenteredView")
	}
}
