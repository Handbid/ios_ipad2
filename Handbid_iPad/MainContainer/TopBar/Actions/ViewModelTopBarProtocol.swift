// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

protocol ViewModelTopBarProtocol: ObservableObject, TopBarActionProvider {
	var centerViewData: TopBarCenterViewData { get }
}

struct TopBarCenterViewData {
	var type: CenterViewType
	var title: String?
	var image: Image?
	var customView: AnyView?
}

enum CenterViewType {
	case title
	case image
	case custom
}
