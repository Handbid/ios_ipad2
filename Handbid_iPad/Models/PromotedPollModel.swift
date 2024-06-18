// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct PromotedPollModel: Identifiable, Codable, NetworkingJSONDecodable, AutoEncodable {
	var id: Int?
	var auctionId: Int?
	var pollCode: String?
	var pollQuestion: String?
	var status: Int?
	var answerA: String?
	var answerB: String?
	var answerC: String?
	var answerD: String?
	var answerE: String?
	var isPromoted: Bool?
	var isDeleted: Bool?
	var dateUpdated: String?
	var dateCreated: String?
}

extension PromotedPollModel: ArrowParsable {
	mutating func deserialize(_ json: JSON) {
		id <-- json["id"]
		auctionId <-- json["auctionId"]
		pollCode <-- json["pollCode"]
		pollQuestion <-- json["pollQuestion"]
		status <-- json["status"]
		answerA <-- json["answerA"]
		answerB <-- json["answerB"]
		answerC <-- json["answerC"]
		answerD <-- json["answerD"]
		answerE <-- json["answerE"]
		isPromoted <-- json["isPromoted"]
		isDeleted <-- json["isDeleted"]
		dateUpdated <-- json["dateUpdated"]
		dateCreated <-- json["dateCreated"]
	}
}
