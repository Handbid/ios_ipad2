// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct PickerView<Data, Content>: View where Data: Hashable, Content: View {
	let data: [Data]
	@State var selection: Data
	private let itemBuilder: (Data) -> Content

	init(data: [Data],
	     @ViewBuilder itemBuilder: @escaping (Data) -> Content)
	{
		self.data = data
		self.selection = data[0]
		self.itemBuilder = itemBuilder
	}

	var body: some View {
		HStack {
			ForEach(data, id: \.self) { item in
				let view = itemBuilder(item)
					.padding()
					.frame(maxWidth: .infinity, maxHeight: 34)
					.background {
						RoundedRectangle(cornerRadius: 40)
							.fill(item == selection ? .accent : .itemBackground)
					}
					.onTapGesture {
						selection = item
					}
				if selection == item {
					view.foregroundStyle(.white)
				}
				else {
					view
				}
			}
		}
		.padding(.all, 4)
		.frame(maxWidth: .infinity, maxHeight: 42)
		.background {
			RoundedRectangle(cornerRadius: 40)
				.stroke(.hbGray, lineWidth: 1.0)
		}
	}
}
