// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct NormalValueView: ValueItemViewProtocol {
	var item: ItemModel
	@Binding var valueType: ItemValueType
	let resetTimer: () -> Void

	var body: some View {
		ItemValueView(valueType: $valueType, resetTimer: resetTimer, item: item)
	}
}
