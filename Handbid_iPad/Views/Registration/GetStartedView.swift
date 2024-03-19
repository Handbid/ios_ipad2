// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct GetStartedView<T: PageProtocol>: View, PageView {
	typealias PageType = T

	let coordinator = RegistrationCoordinator<T, GetStartedView<T>>(registrationPageType: RegistrationPage.self)

	var body: some View {
		Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
		//        coordinator.push(RegistrationPage.logIn, with: nil)
	}
}

// #Preview {
//    GetStartedView()
// }
