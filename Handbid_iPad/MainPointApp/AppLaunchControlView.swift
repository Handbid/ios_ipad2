// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

struct AppLaunchControlView: View {
	@EnvironmentObject var authManager: AuthManager
	@State private var isValidToken = false
	@State private var isLoading = true
	let dataServiceWrapper = DataServiceFactory.getService()

	var body: some View {
		ZStack {
			if isLoading {
				withAnimation(.easeOut(duration: 1.0)) {
					StartupProgressAnimationView()
						.background(Color.white)
						.ignoresSafeArea(.all)
				}
			}
			else {
				if isValidToken {
					RootPageView(page: MainContainerPage.searchItems)
						.environmentObject(dataServiceWrapper)
				}
				else {
					RootPageView(page: RegistrationPage.getStarted)
				}
			}
		}
		.onReceive(NotificationCenter.default.publisher(for: .userLoggedIn).receive(on: RunLoop.main)) { _ in
			updateStatus(loggedIn: true)
		}
		.onReceive(NotificationCenter.default.publisher(for: .userLoggedOut).receive(on: RunLoop.main)) { _ in
			updateStatus(loggedIn: false)
			checkUserStatus()
		}
		.onAppear {
			checkUserStatus()
		}
	}

	private func updateStatus(loggedIn: Bool) {
		isLoading = !loggedIn
		isValidToken = loggedIn
	}

	private func checkUserStatus() {
		Task {
			try await Task.sleep(nanoseconds: 1_000_000_000)

			do {
				isValidToken = try await authManager.isLoggedInAsync()
			}
			catch {
				isValidToken = false
			}
			isLoading = false
		}
	}
}
