// Copyright (c) 2024 by Handbid. All rights reserved.

struct ProcessorFactory {
	var type: Processor

	func build() -> WebSocketProcessor {
		switch type {
		case .user:
			UserProcessor()
		}
	}
}
