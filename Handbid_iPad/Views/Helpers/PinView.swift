// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct PinView: View {
	var length: Int

	var body: some View {
		VStack {
			ForEach(0 ..< length, id: \.self) { _ in
			}
		}
	}
}
