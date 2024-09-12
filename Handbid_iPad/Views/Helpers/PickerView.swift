// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct PickerView<Data, Content>: View where Data: Hashable, Content: View {
	let data: [Data]
	@Binding var selection: Data
	let itemBuilder: (Data) -> Content

	var body: some View {
		HStack {
			ForEach(data, id: \.self) { item in
				itemBuilder(item)
					.padding()
					.frame(maxWidth: .infinity, maxHeight: 34)
					.background {
						RoundedRectangle(cornerRadius: 40)
							.fill(item == selection ? .accent : .itemBackground)
					}
					.foregroundStyle(item == selection ? .white : .bodyText)
					.onTapGesture {
						selection = item
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
