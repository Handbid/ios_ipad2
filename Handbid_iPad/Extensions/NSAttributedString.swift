// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation
import SwiftUI
import UIKit

extension AttributedString {
	init?(html: String) {
		guard let data = html.data(using: .utf8) else { return nil }
		guard let attributedString = try? NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) else { return nil }

		attributedString.enumerateAttribute(.font, in: NSRange(location: 0, length: attributedString.length)) { value, range, _ in
			if let font = value as? UIFont {
				let increasedFont = font.withSize(font.pointSize * 1.4)
				attributedString.addAttribute(.font, value: increasedFont, range: range)
			}
		}

		self.init(attributedString)
	}
}
