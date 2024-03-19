// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct GetStartedView<T: PageProtocol>: View {
	@EnvironmentObject private var coordinator: RegistrationCoordinator<T>

	var body: some View {
		Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
	}
}

// #Preview {
//    GetStartedView()
// }
