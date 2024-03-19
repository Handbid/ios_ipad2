// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

struct RootPageView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>

	var body: some View {
		NavigationStack(path: $coordinator.navigationStack) {
			coordinator.build(page: RegistrationPage.getStarted as! T)
				.navigationDestination(for: T.self) { page in
					coordinator.build(page: page)
				}
		}
		.environmentObject(coordinator)
	}
}
