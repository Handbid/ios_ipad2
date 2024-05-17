// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

enum ModelTypeData {
	case user

	func isModelType(_ type: (some Any).Type) -> Bool {
		switch self {
		case .user:
			type == UserModel.self
		}
	}
}
