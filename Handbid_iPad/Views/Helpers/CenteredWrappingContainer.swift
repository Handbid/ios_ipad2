// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine
import SwiftUI

struct CenteredWrappingContainer<Content: View>: View {
	@State private var contentHeight: CGFloat = 0
	@State private var keyboardHeight: CGFloat = 0
	let overlayContent: () -> Content
	let cornerRadius: CGFloat
	let backgroundColor: Color?

	init(cornerRadius: CGFloat,
	     backgroundColor: Color? = .white,
	     overlayContent: @escaping () -> Content)
	{
		self.cornerRadius = cornerRadius
		self.overlayContent = overlayContent
		self.backgroundColor = backgroundColor
	}

	var body: some View {
		ResponsiveView { layoutProperties in
			VStack {
				Spacer()
				HStack {
					Spacer()
					RoundedRectangle(cornerRadius: cornerRadius)
						.foregroundColor(backgroundColor)
						.cornerRadius(cornerRadius)
						.frame(
							width: calculateWidth(layoutProperties: layoutProperties),
							height: min(contentHeight + keyboardHeight, UIScreen.main.bounds.height * 0.8)
						)
						.overlay {
							overlayContent()
								.fixedSize(horizontal: false, vertical: true)
								.background(
									GeometryReader { geo in
										Color.clear
											.onAppear {
												DispatchQueue.main.async {
													contentHeight = geo.size.height
												}
											}
									}
								)
						}
						.padding(.bottom, keyboardHeight)
					Spacer()
				}
				Spacer()
			}
		}
	}

	private func calculateWidth(layoutProperties: LayoutProperties) -> CGFloat {
		switch UIDevice.current.userInterfaceIdiom {
		case .pad:
			layoutProperties.landscape ? layoutProperties.width * 0.5 : layoutProperties.width * 0.7
		case .phone:
			layoutProperties.landscape ? layoutProperties.width * 0.8 : layoutProperties.width * 0.9
		case .tv:
			layoutProperties.width * 0.6
		case .carPlay:
			layoutProperties.width * 0.7
		case .mac:
			layoutProperties.width * 0.8
		case .vision:
			layoutProperties.width * 0.9
		default:
			layoutProperties.width * 0.7
		}
	}

	private func calculateHeight(layoutProperties: LayoutProperties) -> CGFloat {
		switch UIDevice.current.userInterfaceIdiom {
		case .pad:
			layoutProperties.landscape ? layoutProperties.height * 0.6 : layoutProperties.height * 0.5
		case .phone:
			layoutProperties.landscape ? layoutProperties.height * 0.95 : layoutProperties.height * 0.8
		case .tv:
			layoutProperties.height * 0.5
		case .carPlay:
			layoutProperties.height * 0.6
		case .mac:
			layoutProperties.height * 0.7
		case .vision:
			layoutProperties.height * 0.8
		default:
			layoutProperties.height * 0.6
		}
	}
}

struct LayoutProperties {
	var landscape: Bool
	var dimensValues: CustomDimensValues
	var customFontSize: CustomFontSize
	var height: CGFloat
	var width: CGFloat
}

struct ResponsiveView<Content: View>: View {
	var content: (LayoutProperties) -> Content
	var body: some View {
		GeometryReader { geo in
			let height = geo.size.height
			let width = geo.size.width
			let landScape = height < width
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
