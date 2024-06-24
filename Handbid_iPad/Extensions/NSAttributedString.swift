// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation
import SwiftUI
import UIKit

extension AttributedString {
	init?(html: String) {
		guard let data = html.data(using: .utf8) else { return nil }
		guard let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) else { return nil }
		self.init(attributedString)
	}
}
