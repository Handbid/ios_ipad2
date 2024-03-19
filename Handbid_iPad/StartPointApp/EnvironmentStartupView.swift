// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct EnvironmentStartupView: View {
	var body: some View {
		ZStack {
			RootPageView(page: RegistrationPage.getStarted)
		}
	}
}
