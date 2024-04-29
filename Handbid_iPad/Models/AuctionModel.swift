// Copyright (c) 2024 by Handbid. All rights reserved.

struct AuctionModel {
	let id: UUID = .init()
	let name: String
	let address: String
	let endDate: String
	let itemCount: Int
	let status: String
	let imageUrl: URL?
}
