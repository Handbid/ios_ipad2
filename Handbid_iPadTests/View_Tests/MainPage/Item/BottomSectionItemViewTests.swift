// Copyright (c) 2024 by Handbid. All rights reserved.

// import XCTest
// import SwiftUI
// import ViewInspector
// @testable import Handbid_iPad
//
// final class BottomSectionItemViewTests: XCTestCase {
//
//    func testValueSectionAccessibilityLabel() throws {
//        let item = ItemModel(name: "Test Item", itemType: .normal)  // Przykladowa inicjalizacja
//        let view = BottomSectionItemView(
//            item: item,
//            resetTimer: {},
//            showPaddleInput: .constant(false),
//            valueType: .constant(.none),
//            selectedAction: .constant(nil)
//        )
//
//        let label = try view.inspect().vStack().zStack(0).accessibilityLabel().string()
//        XCTAssertEqual(label, "Value section for Test Item")
//    }
//
//    func testButtonSectionAccessibilityLabel() throws {
//        let item = ItemModel(name: "Test Item", itemType: .normal)
//        let view = BottomSectionItemView(
//            item: item,
//            resetTimer: {},
//            showPaddleInput: .constant(false),
//            valueType: .constant(.none),
//            selectedAction: .constant(nil)
//        )
//
//        let buttonSection = try view.inspect().vStack().view(ButtonSectionItemFactory.ButtonSectionView.self, 1)
//        let label = try buttonSection.accessibilityLabel().string()
//        XCTAssertEqual(label, "Button section for Test Item")
//    }
//
//    func testOnTapGestureCallsResetTimer() throws {
//        let item = ItemModel(name: "Test Item", itemType: .normal)
//        var resetTimerCalled = false
//        let view = BottomSectionItemView(
//            item: item,
//            resetTimer: { resetTimerCalled = true },
//            showPaddleInput: .constant(false),
//            valueType: .constant(.none),
//            selectedAction: .constant(nil)
//        )
//
//        try view.inspect().vStack().callOnTapGesture()
//        XCTAssertTrue(resetTimerCalled)
//    }
//
//    func testOnChangeUpdatesValueType() throws {
//        let item = ItemModel(name: "Test Item", itemType: .normal)
//        let viewModelValueType = Binding<ItemValueType>(wrappedValue: .none)
//        let externalValueType = Binding<ItemValueType>(wrappedValue: .bidAmount(50))
//
//        let view = BottomSectionItemView(
//            item: item,
//            resetTimer: {},
//            showPaddleInput: .constant(false),
//            valueType: externalValueType,
//            selectedAction: .constant(nil)
//        )
//
//        try view.inspect().vStack().view(ButtonSectionItemFactory.ButtonSectionView.self, 1)
//            .binding(ItemValueType.self, keyPath: \.valueType)
//            .wrappedValue = .buyNow(100)
//
//        XCTAssertEqual(externalValueType.wrappedValue, .buyNow(100))
//    }
// }
