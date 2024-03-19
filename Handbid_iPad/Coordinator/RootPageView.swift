// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct RootPageView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	let page: T

	var body: some View {
		NavigationStack(path: $coordinator.navigationStack) {
			coordinator.build(page: page)
				.navigationDestination(for: T.self) { nextPage in
					coordinator.build(page: nextPage)
				}
		}
		.environmentObject(coordinator)
	}
}
