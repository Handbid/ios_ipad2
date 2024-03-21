// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

struct LogInView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@State private var currentPageView: AnyView?
	@ObservedObject private var viewModel = LogInViewModel()

	var body: some View {
		Text("Hello, World2!")
			.accessibilityIdentifier("HelloWorld2TextView")
		Button("next") {
			coordinator.push(RegistrationPage.getStarted as! T)
		}
		.accessibilityIdentifier("nextButton")
		Button("back 1") {
			coordinator.pop()
		}
		.accessibilityIdentifier("back1Button")
		Button("back 2") {
			viewModel.fetchAppVersion()
		}
		.accessibilityIdentifier("back2Button")
	}
}

class LogInViewModel: ObservableObject {
	private var cancellables = Set<AnyCancellable>()

	func fetchAppVersion() {
		AppVersionModel().fetchAppVersion()
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					break
				case let .failure(error):
					print("Error fetching app version: \(error)")
				}
			}, receiveValue: { version in
				print(version)
			})
			.store(in: &cancellables)
	}
}
