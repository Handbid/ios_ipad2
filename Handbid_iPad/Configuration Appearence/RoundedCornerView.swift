// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct RoundedCornerView: Shape {
	var radius: CGFloat
	var corners: UIRectCorner

	func path(in rect: CGRect) -> Path {
		let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		return Path(path.cgPath)
	}
}
