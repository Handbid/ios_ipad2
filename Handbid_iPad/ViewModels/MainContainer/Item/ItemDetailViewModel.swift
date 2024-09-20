// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

class ItemDetailViewModel: ObservableObject {
	let item: ItemModel

	init(item: ItemModel) {
		self.item = item
	}
}
