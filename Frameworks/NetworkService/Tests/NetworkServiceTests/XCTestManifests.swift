// Copyright (c) 2024 by Handbid. All rights reserved.

import XCTest

#if !canImport(ObjectiveC)
	public func allTests() -> [XCTestCaseEntry] {
		[
			testCase(NetworkingTests.allTests),
		]
	}
#endif
