//Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct NoBackgroundItemStyle<Data>: ViewModifier where Data: Hashable {
    let item: Data
    let selection: Data
    
    func body(content: Content) -> some View {
        VStack {
            content
                .foregroundStyle(item == selection ? .managerTabSelected : .managerTab)
                .padding()
                .padding(.bottom, 16)
            
            if item == selection {
                Divider()
                    .foregroundStyle(.managerTabSelected)
            }
        }
        .frame(maxHeight: 34)
    }
}
