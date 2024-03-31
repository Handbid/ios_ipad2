// Copyright (c) 2024 by Handbid. All rights reserved.

struct CustomFontSize {
	let small: CGFloat
	let smallMedium: CGFloat
	let medium: CGFloat
	let mediumLarge: CGFloat
	let large: CGFloat
	let extraLarge: CGFloat
	init(height: CGFloat, width: CGFloat) {
		let widthToCalculate = height < width ? height : width
		switch widthToCalculate {
		case _ where widthToCalculate < 700:
			self.small = 8
			self.smallMedium = 11
			self.medium = 14
			self.mediumLarge = 16
			self.large = 18
			self.extraLarge = 25
		case _ where widthToCalculate >= 700 && widthToCalculate < 1000:
			self.small = 15
			self.smallMedium = 18
			self.medium = 22
			self.mediumLarge = 26
			self.large = 30
			self.extraLarge = 40
		case _ where widthToCalculate >= 1000:
			self.small = 20
			self.smallMedium = 24
			self.medium = 28
			self.mediumLarge = 32
			self.large = 36
			self.extraLarge = 45
		default:
			self.small = 8
			self.smallMedium = 11
			self.medium = 14
			self.mediumLarge = 16
			self.large = 18
			self.extraLarge = 25
		}
	}
}
