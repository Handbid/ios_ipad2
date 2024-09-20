// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI
import UIKit

struct HTMLTextView: UIViewRepresentable {
	let htmlContent: String

	var processedHtmlContent: String {
		htmlContent.replacingOccurrences(of: "\n", with: "<br>")
	}

	func makeUIView(context _: Context) -> UITextView {
		let textView = UITextView()
		textView.isEditable = false
		textView.isSelectable = true
		textView.isScrollEnabled = false
		textView.backgroundColor = .clear
		textView.textContainerInset = .zero
		textView.textContainer.lineFragmentPadding = 0
		textView.dataDetectorTypes = [.all]
		textView.textContainer.lineBreakMode = .byWordWrapping
		return textView
	}

	func updateUIView(_ uiView: UITextView, context _: Context) {
		DispatchQueue.main.async {
			if let data = processedHtmlContent.data(using: .utf8) {
				if let attributedString = try? NSMutableAttributedString(
					data: data,
					options: [
						.documentType: NSAttributedString.DocumentType.html,
						.characterEncoding: String.Encoding.utf8.rawValue,
					],
					documentAttributes: nil
				) {
					let paragraphStyle = NSMutableParagraphStyle()
					paragraphStyle.lineBreakMode = .byWordWrapping
					paragraphStyle.alignment = .left
					attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))

					uiView.attributedText = attributedString
					uiView.textContainer.lineBreakMode = .byWordWrapping
				}
				else {
					uiView.text = processedHtmlContent
				}
			}
			else {
				uiView.text = processedHtmlContent
			}
		}
	}
}
