// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
	func makeBody(configuration: Configuration) -> some View {
		Button(action: {
			configuration.isOn.toggle()
		}, label: {
			HStack {
				Image(configuration.isOn ? .checkboxChecked : .checkboxNotChecked)

				configuration.label
			}
		})
	}
}
