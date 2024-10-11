//Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct RoundedBackgroundItemStyle<Data>: ViewModifier where Data: Hashable{
    let item: Data
    let selection: Data
    
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 34)
            .background {
                RoundedRectangle(cornerRadius: 40)
                    .fill(item == selection ? .accent : .itemBackground)
            }
            .foregroundStyle(item == selection ? .white : .bodyText)
    }
}
