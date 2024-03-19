// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

struct GetStartedView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>

	var body: some View {
		Text("Hello, World!")
		Button("next") {
			coordinator.push(RegistrationPage.logIn as! T)
		}
	}
}
