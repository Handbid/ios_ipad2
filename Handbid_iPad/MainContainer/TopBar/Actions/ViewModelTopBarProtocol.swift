// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

protocol ViewModelTopBarProtocol: ObservableObject, TopBarActionProvider {
	var centerViewContent: AnyView { get }
}
