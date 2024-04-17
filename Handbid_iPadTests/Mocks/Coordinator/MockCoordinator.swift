// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI

class MockCoordinator<T: PageProtocol, U>: Coordinator<T, U> {
	var pushedPage: T? = nil

	init() {
		super.init(viewBuilder: { _ in
			AnyView(EmptyView())
		})
	}

	override func push(_ page: T, with _: U? = nil) {
		pushedPage = page
	}
}
