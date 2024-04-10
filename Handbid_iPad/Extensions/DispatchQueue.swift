// Copyright (c) 2024 by Handbid. All rights reserved.

extension DispatchQueue {
	static func safeMainAsync(execute work: @escaping () -> Void) {
		if Thread.isMainThread {
			work()
		}
		else {
			DispatchQueue.main.async {
				work()
			}
		}
	}
}
