// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

protocol PaddleRepository {}

enum SearchBy: String, CaseIterable {
	case email, cellPhone

	func getLocalizedLabel() -> LocalizedStringKey {
		switch self {
		case .cellPhone:
			LocalizedStringKey("global_label_cellPhone")
		case .email:
			LocalizedStringKey("global_label_email")
		}
	}
}
