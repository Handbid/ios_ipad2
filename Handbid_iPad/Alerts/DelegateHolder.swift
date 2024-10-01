// Copyright (c) 2024 by Handbid. All rights reserved.

class DelegateHolder<T: AnyObject> {
	weak var delegate: T?
	init(delegate: T?) {
		self.delegate = delegate
	}
}
