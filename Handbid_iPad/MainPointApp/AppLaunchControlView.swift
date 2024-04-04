// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct AppLaunchControlView: View {
	@EnvironmentObject var authManager: AuthManagerMainActor
	@State private var isValidToken = false
	@State private var isLoading = true
	@State private var animationDuration = 1.0

	var body: some View {
		ZStack {
			if isLoading {
				withAnimation(.easeOut(duration: animationDuration)) {
					StartupProgressAnimationView()
						.background(Color.white)
						.ignoresSafeArea(.all)
				}
			}
			else {
				if isValidToken {
					EmptyAuctionView<RegistrationPage>()
				}
				else {
					RootPageView(page: RegistrationPage.getStarted)
				}
			}
		}
		.onReceive(NotificationCenter.default.publisher(for: .userLoggedIn).receive(on: RunLoop.main)) { _ in
			isLoading = false
			isValidToken = true
		}
		.onReceive(NotificationCenter.default.publisher(for: .userLoggedOut).receive(on: RunLoop.main)) { _ in
			isValidToken = false
		}
		.onAppear {
			Task {
				try await Task.sleep(nanoseconds: 1_000_000_000)

				do {
					let isLoggedIn = try await authManager.isLoggedInAsync()
					isValidToken = isLoggedIn
					isLoading = false
				}
				catch {
					isValidToken = false
					isLoading = false
				}
			}
		}
	}

	func checkUserStatus() async {
		do {
			isValidToken = try await authManager.isLoggedInAsync()
		}
		catch {
			isValidToken = false
		}
	}
}
