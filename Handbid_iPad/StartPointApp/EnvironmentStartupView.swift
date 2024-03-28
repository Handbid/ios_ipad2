// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct EnvironmentStartupView: View {
	@EnvironmentObject var authManager: AuthManagerMainActor
	@State private var isValidToken = false
	@State private var isLoading = true
	@State private var animationDuration = 1.0

	var body: some View {
		ZStack {
			if isLoading {
				withAnimation(.easeOut(duration: animationDuration)) {
					ApplicationLaunchAnimationView()
						.background(Color.white)
						.ignoresSafeArea(.all)
				}
			}
			else {
				if isValidToken {
					/// Add implementation for AuctionView
				}
				else {
					RootPageView(page: RegistrationPage.getStarted)
						.onChange(of: authManager.isLoggedIn) {
							isValidToken = true
							print("User logged")
						}
				}
			}
		}
		.onAppear {
			Task {
				await checkUserStatus()
				try await Task.sleep(nanoseconds: 1_000_000_000)
				isLoading = false
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
