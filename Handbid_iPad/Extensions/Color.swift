// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation
import SwiftUI

extension Color {
	init(hex: String) {
		var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
		hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

		var rgb: UInt64 = 0

		Scanner(string: hexSanitized).scanHexInt64(&rgb)

		let red = Double((rgb & 0xFF0000) >> 16) / 255.0
		let green = Double((rgb & 0x00FF00) >> 8) / 255.0
		let blue = Double(rgb & 0x0000FF) / 255.0

		self.init(red: red, green: green, blue: blue)
	}

	static var accentViolet = Color(hex: "694BFF")
	static var white = Color(hex: "ffffff")
}

extension Color {
	func toUIColor() -> UIColor {
		if #available(iOS 15.0, *) {
			return UIColor(self)
		}
		else {
			let components = cgColor!.components!
			return UIColor(red: components[0], green: components[1], blue: components[2], alpha: components[3])
		}
	}
}
