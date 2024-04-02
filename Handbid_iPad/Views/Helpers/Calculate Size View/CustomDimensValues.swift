// Copyright (c) 2024 by Handbid. All rights reserved.

struct CustomDimensValues {
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
			self.small = 7
			self.smallMedium = 10
			self.medium = 12
			self.mediumLarge = 15
			self.large = 17
			self.extraLarge = 22
		case _ where widthToCalculate >= 700 && widthToCalculate < 1000:
			self.small = 14
			self.smallMedium = 16
			self.medium = 19
			self.mediumLarge = 22
			self.large = 24
			self.extraLarge = 29
		case _ where widthToCalculate >= 1000:
			self.small = 17
			self.smallMedium = 20
			self.medium = 23
			self.mediumLarge = 25
			self.large = 28
			self.extraLarge = 32
		default:
			self.small = 5
			self.smallMedium = 8
			self.medium = 10
			self.mediumLarge = 13
			self.large = 15
			self.extraLarge = 20
		}
	}
}
