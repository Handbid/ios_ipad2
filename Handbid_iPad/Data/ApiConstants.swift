// Copyright (c) 2024 by Handbid. All rights reserved.

enum ApiEndpoints {
	static let getAppVersion = "/auth/app-info"
	static let logInUser = "/auth/login"
	static let resetPassword = "/auth/reset"
	static let auctionUser = "/auction/user"
	static let organizationIndex = "/organization/index"
	static let auctionInventory = "/auction/inventory"
	static let getAuctionsUser = "/auction/index"
	static let items = "/api/v2/items"
	static let findPaddle = "auth/lookup"
	static let checkInUser = "auth/checkin"
	static let registerUser = "auth/register"
}
