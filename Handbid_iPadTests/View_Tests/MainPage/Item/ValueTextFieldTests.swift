// Copyright (c) 2024 by Handbid. All rights reserved.

@testable import Handbid_iPad
import SwiftUI
import ViewInspector
import XCTest

final class ValueTextFieldTests: XCTestCase {
	func testValueTextFieldForQuantity() throws {
		let binding = Binding<ItemValueType>(wrappedValue: .quantity(1))
		let view = ValueTextField(valueType: binding)

		let textField = try view.inspect().textField()
		let value = try textField.input() as String
		XCTAssertEqual(value, "1")
		XCTAssertTrue(textField.isDisabled())
		XCTAssertEqual(try textField.accessibilityIdentifier(), "valueTextField")
	}

	func testValueTextFieldForBidAmount() throws {
		let binding = Binding<ItemValueType>(wrappedValue: .bidAmount(100.0))
		let view = ValueTextField(valueType: binding)

		let textField = try view.inspect().textField()
		let value = try textField.input() as String
		XCTAssertEqual(value, "100.0")
		XCTAssertTrue(textField.isDisabled())
		XCTAssertEqual(try textField.accessibilityIdentifier(), "valueTextField")
	}

	func testValueTextFieldForNone() throws {
		let view = ValueTextField(valueType: .constant(.none))

		XCTAssertThrowsError(try view.inspect().textField())
	}
}
