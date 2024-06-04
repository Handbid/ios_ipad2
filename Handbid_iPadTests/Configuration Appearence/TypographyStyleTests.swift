// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import XCTest

class TypographyStyleTests: XCTestCase {
	func testHeaderTitleRegistrationFontName() {
		let style = TypographyStyle.headerTitleRegistration
		XCTAssertEqual(style.fontName, "Inter", "Font name for headerTitleRegistration should be 'Inter'")
	}

	func testHeaderTitleRegistrationFontTextStyle() {
		let style = TypographyStyle.headerTitleRegistration
		XCTAssertEqual(style.fontTextStyle, .headline, "Font text style for headerTitleRegistration should be 'headline'")
	}

	func testHeaderTitleRegistrationiPhoneFontSize() {
		let style = TypographyStyle.headerTitleRegistration
		XCTAssertEqual(style.iPhoneFontSize, 26, "iPhone font size for headerTitleRegistration should be 26")
	}

	func testHeaderTitleRegistrationiPadFontSize() {
		let style = TypographyStyle.headerTitleRegistration
		XCTAssertEqual(style.iPadFontSize, 40, "iPad font size for headerTitleRegistration should be 40")
	}

	func testHeaderTitleRegistrationFontSize() {
		let style = TypographyStyle.headerTitleRegistration
		XCTAssertEqual(style.fontSize, 40, "Font size for headerTitleRegistration should be 40")
	}

	func testHeaderTitleRegistrationAsFont() {
		let style = TypographyStyle.headerTitleRegistration
		let expectedFontSize = UIDevice.current.userInterfaceIdiom == .pad ? style.iPadFontSize : style.iPhoneFontSize
		let font = style.asFont()
		XCTAssertEqual(font, Font.custom(style.fontName, size: expectedFontSize, relativeTo: style.fontTextStyle), "Font should be correctly configured")
	}
}
