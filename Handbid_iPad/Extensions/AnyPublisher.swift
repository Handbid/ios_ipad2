// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine

extension AnyPublisher {
	func async() async throws -> Output {
		try await withCheckedThrowingContinuation { continuation in
			var cancellable: AnyCancellable?
			var receivedValue = false
			var isContinued = false

			cancellable = sink(receiveCompletion: { result in
				if !receivedValue, !isContinued {
					isContinued = true
					switch result {
					case .finished:
						continuation.resume(throwing: NSError(domain: "", code: 2, userInfo: [NSLocalizedDescriptionKey: "No value received before completion"]))
					case let .failure(error):
						continuation.resume(throwing: error)
					}
				}
				cancellable?.cancel()
			}, receiveValue: { value in
				if !isContinued {
					receivedValue = true
					isContinued = true
					continuation.resume(returning: value)
					cancellable?.cancel()
				}
			})
		}
	}
}
