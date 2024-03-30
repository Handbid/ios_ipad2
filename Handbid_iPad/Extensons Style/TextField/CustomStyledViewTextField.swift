// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

extension TextField {
    @ViewBuilder
    func applyTextFieldStyle(config: TextStyleConfiguration) -> some View {
        let textField = font(config.font)
            .fontWeight(config.fontWeight)
            .foregroundColor(config.foregroundColor)
            .multilineTextAlignment(config.alignment)

        if config.rounded {
            textField.textFieldStyle(RoundedBorderTextFieldStyle())
        } else {
            textField
        }
    }
}
