// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

protocol TopBarContent {
	var leftViews: [AnyView] { get }
	var centerView: AnyView { get }
	var rightViews: [AnyView] { get }
}
