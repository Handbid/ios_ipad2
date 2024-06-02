// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

protocol TopBarContentProtocol {
	var leftViews: [AnyView] { get }
	var centerView: AnyView { get }
	var rightViews: [AnyView] { get }
}

struct TopBarContent: TopBarContentProtocol {
	var leftViews: [AnyView]
	var centerView: AnyView
	var rightViews: [AnyView]
}
