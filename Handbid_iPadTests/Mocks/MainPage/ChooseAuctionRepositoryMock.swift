// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
@testable import Handbid_iPad

class ChooseAuctionRepositoryMock: ChooseAuctionRepository {
	var fetchUserAuctionsCalled = false

	func fetchUserAuctions(status _: [AuctionStateStatuses]) -> AnyPublisher<[AuctionModel], Error> {
		fetchUserAuctionsCalled = true
		return Just([AuctionModel.mockAuction()])
			.setFailureType(to: Error.self)
			.eraseToAnyPublisher()
	}
}
