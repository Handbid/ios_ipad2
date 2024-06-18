// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct RegistrationBackButton: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	let style: NavigationBackButtonStyle

	var body: some View {
		Button(action: {
			presentationMode.wrappedValue.dismiss()
		}) {
			switch style {
			case .registration:
				Image(systemName: "arrowshape.left.fill")
					.foregroundColor(.white)
					.padding()
					.font(.title)
			case .mainContainer:
				Image(systemName: "arrowshape.left.fill")
					.foregroundColor(.accentViolet)
					.padding()
					.font(.title)
			}
		}
	}
}
