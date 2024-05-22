// Copyright (c) 2024 by Handbid. All rights reserved.

class ProcessorRegistry {
	static let shared = ProcessorRegistry()
	private var registry = [Processor: WebSocketProcessor]()

	func registerProcessor(_ processor: WebSocketProcessor, for event: Processor) {
		registry[event] = processor
	}

	func getProcessor(for event: Processor) -> WebSocketProcessor? {
		guard let processor = registry[event] else { return nil }
		return processor
	}
}
