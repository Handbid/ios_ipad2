// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
@testable import Handbid_iPad

class MockAuctionRepository: AuctionRepository {
	func getAuctionDetails(id _: Int) -> AnyPublisher<Handbid_iPad.AuctionModel, any Error> {
		Just(AuctionModel())
			.setFailureType(to: Error.self)
			.eraseToAnyPublisher()
	}
}
