// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

enum AuctionStateStatuses: String, CaseIterable, Codable {
	case open, presale, preview, closed, reconciled, all

	func color(for _: ColorScheme) -> Color {
		switch self {
		case .open, .all:
			Color(hex: "39C436")
		case .presale:
			Color(hex: "E2296C")
		case .preview:
			Color(hex: "FEB62B")
		case .closed:
			Color(hex: "E1E6E8")
		case .reconciled:
			Color(hex: "1672B3")
		}
	}

	static func color(for status: String, in scheme: ColorScheme) -> Color {
		(AuctionStateStatuses(rawValue: status)?.color(for: scheme) ?? Color.gray)
	}
}
