// Copyright (c) 2024 by Handbid. All rights reserved.

import Foundation

func convertTimestampToDate(timestamp: TimeInterval) -> String {
	let date = Date(timeIntervalSince1970: timestamp)
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "MMM d, yyyy"
	let formattedDate = dateFormatter.string(from: date)
	return formattedDate
}
