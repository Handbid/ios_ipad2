// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

extension MultipartData: HttpBodyConvertible {
	public func buildHttpBodyPart(boundary: String) -> Data {
		let httpBody = NSMutableData()
		httpBody.appendString("--\(boundary)\r\n")
		httpBody.appendString("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n")
		httpBody.appendString("Content-Type: \(mimeType)\r\n\r\n")
		httpBody.append(fileData)
		httpBody.appendString("\r\n")
		return httpBody as Data
	}
}

extension NSMutableData {
	func appendString(_ string: String) {
		if let data = string.data(using: .utf8) {
			append(data)
		}
	}
}
