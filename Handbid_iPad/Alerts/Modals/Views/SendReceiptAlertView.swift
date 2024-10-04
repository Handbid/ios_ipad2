// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

struct SendReceiptAlertView: View {
	var sendMethod: String
	var sendTo: String
	var errorSend: Bool = false

	var body: some View {
		OverlayInternalView(cornerRadius: 40) {
			VStack(spacing: 20) {
				Text("\(sendMethod) Invocie")
					.fontWeight(.semibold)
					.font(.title)

				HStack(spacing: 0, content: {
					Text("\(sendMethod) Invoice\(errorSend ? " " : " not ")sent to ")
						.font(.body)
					Text("\(sendTo)")
						.font(.body)
						.fontWeight(.bold)
				})

				Button<Text>.styled(config: .secondaryButtonStyle, action: {
					AlertManager.shared.dismissAlert()

				}, label: {
					Text("GO BACK TO SCREEN")
						.textCase(.uppercase)
				})
			}
			.padding(32)
			.frame(maxWidth: .infinity)
		}
	}
}
