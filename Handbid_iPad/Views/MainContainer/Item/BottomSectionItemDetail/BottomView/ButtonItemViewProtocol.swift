// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

protocol ButtonItemViewProtocol: View {
	init(item: ItemModel, resetTimer: @escaping () -> Void, showPaddleInput: Binding<Bool>)
}
