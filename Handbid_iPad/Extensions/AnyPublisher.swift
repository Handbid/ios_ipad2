// Copyright (c) 2024 by Handbid. All rights reserved.

import Combine

extension AnyPublisher {
	func async() async throws -> Output {
		try await withCheckedThrowingContinuation { continuation in
			var cancellable: AnyCancellable?

			cancellable = sink(receiveCompletion: { result in
				switch result {
				case .finished:
					break
				case let .failure(error):
					continuation.resume(throwing: error)
				}
				cancellable?.cancel()
			}, receiveValue: { value in
				continuation.resume(with: .success(value))
			})
		}
	}
}
