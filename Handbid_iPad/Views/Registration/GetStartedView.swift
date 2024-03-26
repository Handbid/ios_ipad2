// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import NetworkService
import SwiftUI

struct GetStartedView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>
	@State private var currentPageView: AnyView?
	@ObservedObject var viewmodel = LogInViewModel()
	var body: some View {
		ZStack {
			Color.yellow.edgesIgnoringSafeArea(.all)
			VStack {
				Spacer()
				Text("Get Started")
					.accessibilityIdentifier("GetStartedView")
				Spacer()
				Button("next") {
					coordinator.push(RegistrationPage.logIn as! T)
				}
				.accessibilityIdentifier("nextButton")
				Spacer()
				Button("env") {
					if EnvironmentManager.isProdActive() {
						EnvironmentManager.setEnvironment(for: .d1)
						viewmodel.fetchAppVersion()
					}
					else {
						EnvironmentManager.setEnvironment(for: .prod)
						viewmodel.fetchAppVersion()
					}
				}
				.accessibilityIdentifier("env")
				Spacer()
			}
		}
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
