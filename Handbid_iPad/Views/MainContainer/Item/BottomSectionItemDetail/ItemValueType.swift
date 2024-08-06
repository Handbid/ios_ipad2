// Copyright (c) 2024 by Handbid. All rights reserved.

enum ItemValueType: Equatable {
	case bidAmount(Double)
	case buyNow(Double)
	case quantity(Int)
	case none

	var doubleValue: Double? {
		switch self {
		case let .bidAmount(amount):
			amount
		case let .buyNow(amount):
			amount
		case let .quantity(qty):
			Double(qty)
		case .none:
			nil
		}
	}
}
