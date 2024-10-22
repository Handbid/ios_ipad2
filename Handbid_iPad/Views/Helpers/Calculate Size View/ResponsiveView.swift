// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct ResponsiveView<Content: View>: View {
	var content: (LayoutProperties) -> Content
	var body: some View {
		GeometryReader { geo in
			let height = geo.size.height
			let width = geo.size.width
			let landScape = width / height >= 4 / 3
			let dimensValues = CustomDimensValues(height: height, width: width)
			let customFontSize = CustomFontSize(height: height, width: width)
			content(
				LayoutProperties(
					landscape: landScape,
					dimensValues: dimensValues,
					customFontSize: customFontSize,
					height: height,
					width: width
				)
			)
		}
	}
}
