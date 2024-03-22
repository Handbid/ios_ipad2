// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct GetStartedView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@State private var currentPageView: AnyView?

	var body: some View {
		ZStack {
			Color.yellow.edgesIgnoringSafeArea(.all)
			VStack {
				Spacer()
				Text("Welcome to Handbid App")
					.titleTextStyle()
					.accessibilityIdentifier("GetStartedView")
				Spacer()
				HStack {
					Button("next") {
						coordinator.push(RegistrationPage.logIn as! T)
					}
					.solidAccentStyle()
					.accessibilityIdentifier("nextButton")
					Spacer()
					Button("previous") {}
						.borderAccentStyle()
				}
				Spacer()
			}
			.padding()
		}
	}
}
