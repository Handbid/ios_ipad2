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

	static func == (lhs: ItemValueType, rhs: ItemValueType) -> Bool {
		switch (lhs, rhs) {
		case let (.bidAmount(a), .bidAmount(b)):
			a == b
		case let (.buyNow(a), .buyNow(b)):
			a == b
		case let (.quantity(a), .quantity(b)):
			a == b
		case (.none, .none):
			true
		default:
			false
		}
	}
}
