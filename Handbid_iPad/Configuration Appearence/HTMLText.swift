// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI
import UIKit

struct HTMLText: View {
	let html: String

	var body: some View {
		if let attributedString = AttributedString(html: html) {
			Text(attributedString)
				.padding(.vertical)
		}
		else {
			Text(html)
				.padding(.vertical)
		}
	}
}
