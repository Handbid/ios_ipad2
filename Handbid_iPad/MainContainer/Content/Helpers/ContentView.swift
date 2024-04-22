// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

protocol ContentView: View {
	associatedtype ViewModel: ViewModelTopBarProtocol
	init(viewModel: ViewModel)
}
