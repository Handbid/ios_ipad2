// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import Foundation
import NetworkService

struct ResetPasswordModel: Decodable, Encodable, NetworkingJSONDecodable {
	var success: Bool?
	var message: String?
}

extension ResetPasswordModel: ArrowParsable {
	mutating func deserialize(_ json: JSON) {
		success <-- json["success"]
		message <-- json["data.message"] ?? json["data.errors.identifier"]
	}
}
