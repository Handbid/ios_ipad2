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
	static let bidCreate = "/bid/create"
	static let findPaddle = "/auth/lookup"
	static let checkInUser = "/auth/checkin"
	static let registerUser = "/auth/register"
	static let getCountries = "/country/index"
	static let fetchDashboard = "/auction/dashboard"
	static let findBidder = "/auction/bidder"
	static let paddleBids = "/auction/paddlebids"
	static let fetchInvoice = "/auction/paddlereceipts"
	static let sendReceipt = "/receipt/send"
	static let verifyManagerPin = "/guest/accesstolist?auctionId="
}
