// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct DetailInfoView: View {
	@Binding var isVisible: Bool
	let resetTimer: () -> Void
	let item: ItemModel

	var body: some View {
		VStack(alignment: .leading, spacing: 15) {
			HStack {
				Spacer()
				Text("Category Name")
					.foregroundColor(.black)
					.fontWeight(.light)
					.accessibilityIdentifier("categoryName")
				Text(" | ")
					.foregroundColor(.gray)
				Text("#123")
					.foregroundColor(.black)
					.fontWeight(.light)
					.accessibilityIdentifier("itemID")
				Text(" | ")
					.foregroundColor(.gray)
				Text("12 bids")
					.foregroundColor(.accentViolet)
					.fontWeight(.light)
					.accessibilityIdentifier("bidCount")
				Spacer()
			}
			HStack {
				Spacer()
				Text("Item Description - Name and List of Included Items")
					.font(.title2)
					.fontWeight(.medium)
					.multilineTextAlignment(.center)
					.accessibilityIdentifier("itemDescription")
				Spacer()
			}

			HStack(spacing: 30) {
				Spacer()
				VStack(alignment: .leading) {
					Text("VALUE")
						.font(.caption)
						.foregroundColor(.gray)
					Text("$5,000.00")
						.font(.headline)
						.accessibilityIdentifier("itemValue")
				}
				VStack(alignment: .leading) {
					Text("INCREMENT")
						.font(.caption)
						.foregroundColor(.gray)
					Text("$100.00")
						.font(.headline)
						.accessibilityIdentifier("bidIncrement")
				}
				VStack(alignment: .trailing) {
					Text("BUY NOW")
						.font(.caption)
						.foregroundColor(.gray)
					Text("$3,200.00")
						.font(.headline)
						.accessibilityIdentifier("buyNowPrice")
				}
				Spacer()
			}

			HTMLText(html: """
			Amet minim mollit non deserunt ullamco est sit aliqua <b>dolor</b> do amet sint.
			Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.
			Amet minim mollit non deserunt ullamco est sit aliqua <i>dolor</i> do amet sint.
			Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.
			""")
			.frame(maxWidth: .infinity, alignment: .leading)
			.fixedSize(horizontal: false, vertical: true)
			.onTapGesture {
				resetTimer()
			}
			.accessibilityIdentifier("itemDescription")

			Spacer()
		}
		.padding()
		.padding(.trailing, 20)
		.onTapGesture {
			resetTimer()
		}
		.frame(maxHeight: .infinity)
		.clipped()
	}
}
