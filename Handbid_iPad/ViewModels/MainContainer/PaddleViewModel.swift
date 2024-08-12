// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

class PaddleViewModel: ObservableObject, ViewModelTopBarProtocol {
	@ObservedObject var dataService: DataServiceWrapper
	@Published var title = "Paddle Number"
	@Published var pickedMethod: SearchBy
	@Published var email: String
	@Published var phone: String
	@Published var countryCode: String
	@Published var error: String

	var countryCodes = [
		"+1", "+273", "+35",
	]

	@Published var firstName: String
	@Published var lastName: String
	@Published var user: UserModel?
	var actions: [TopBarAction] { [] }

	init(dataService: DataServiceWrapper) {
		self.dataService = dataService
		self.pickedMethod = .email
		self.email = ""
		self.phone = ""
		self.countryCode = "+1"
		self.error = ""
		self.firstName = ""
		self.lastName = ""
		self.user = nil
	}

	var centerViewData: TopBarCenterViewData {
		TopBarCenterViewData(
			type: .title,
			title: title
		)
	}
}
