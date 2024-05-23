// Copyright (c) 2024 by Handbid. All rights reserved.

enum ModelType {
	case user, auction

	func isModelType(_ type: (some Any).Type) -> Bool {
		switch self {
		case .user:
			type == UserModel.self
		case .auction:
			type == AuctionModel.self
		}
	}
}
