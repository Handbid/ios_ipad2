// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct PickerView<Data, Content>: View where Data: Hashable, Content: View {
	let data: [Data]
	@Binding var selection: Data
    let style: Style
	let itemBuilder: (Data) -> Content

    var body: some View {
        HStack {
            ForEach(data, id: \.self) { item in
                applyItemStyleModifier(to: itemBuilder(item), item: item)
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
    
    @ViewBuilder
    private func applyItemStyleModifier(to view: some View, item: Data) -> some View {
        switch style {
        case .noBackground:
            view.modifier(NoBackgroundItemStyle(item: item, selection: selection))
        case .roundedBackground:
            view.modifier(RoundedBackgroundItemStyle(item: item, selection: selection))
        }
    }
    
    enum Style {
    case roundedBackground, noBackground
    }
}
