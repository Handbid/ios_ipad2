// Copyright (c) 2024 by Handbid. All rights reserved.

enum Processor: String {
	case afterBid = "event.item.afterbid"
	case auction = "event.auction"
	case bid = "event.bid"
	case broadcast = "event.broadcast"
	case card = "event.card"
	case close = "event.close"
	case dashboard = "event.dashboard"
	case favorite = "event.favorite"
	case final = "event.final"
	case guest = "event.guest"
	case item = "event.item"
	case itemsPromotedQueue = "event.items_promoted_queue"
	case page = "event.page"
	case paymentIntent = "event.payment_intent"
	case poll = "event.poll"
	case pollStop = "event.poll_stop"
	case promoted = "event.promoted"
	case purchase = "event.purchase"
	case puzzle = "event.puzzle"
	case quantityThreshold = "event.quantity_threshold"
	case receipt = "event.receipt"
	case reset = "event.reset"
	case scheduler = "event.scheduler"
	case stream = "event.stream"
	case user = "event.user"
}
