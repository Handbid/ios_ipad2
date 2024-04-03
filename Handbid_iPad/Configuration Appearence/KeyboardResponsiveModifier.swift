//Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct KeyboardResponsiveModifier: ViewModifier {
    @FocusState var isFocused: Bool

    func body(content: Content) -> some View {
        content
            .onTapGesture {
                if isFocused {
                    isFocused = false
                }
            }
            .focused($isFocused, equals: true)
    }
}
