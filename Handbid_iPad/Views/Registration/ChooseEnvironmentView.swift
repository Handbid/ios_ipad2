// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ChooseEnvironmentView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: Coordinator<T, Any?>

	var body: some View {
		Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)

		//                if EnvironmentManager.isProdActive() {
		//                    EnvironmentManager.setEnvironment(for: .d1)
		//                    viewmodel.fetchAppVersion()
		//                }
		//                else {
		//                    EnvironmentManager.setEnvironment(for: .prod)
		//                    viewmodel.fetchAppVersion()
		//                }
	}
}
