// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

protocol ValueItemViewProtocol: View {
	init(item: ItemModel, valueType: Binding<ItemValueType>, resetTimer: @escaping () -> Void)
}
