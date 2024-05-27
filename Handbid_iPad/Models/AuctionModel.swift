// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService
import SwiftData

struct AuctionModel: Identifiable, Codable, NetworkingJSONDecodable {
	var id: String
	var identity: Int?
	var key: String?
	var imageUrl: String?
	var auctionGuid: String?
	var name: String?
	var status: String?
	var timeZone: String?
	var startTime: Int?
	var endTime: Int?
	var hasExtendedBidding: Bool?
	var extendedBiddingTimeoutInMinutes: Int?
	var requireCreditCard: Bool?
	var spendingThreshold: Double?
	var auctionDescription: String?
	var auctionMessage: String?
	var currentPaddleNumber: String?
	var timerStartTime: Int?
	var timerEndTime: Int?
	var timerRemaining: Int?
	var currencyCode: String?
	var currencySymbol: String?
	var totalBidders: Int?
	var totalItems: Int?
	var enableTicketSales: Bool?
	var organization: [OrganizationModel]?
	var categories: [CategoryModel]?
	var vanityAddress: String?
	var auctionAddress: [AddressModel]?
	var enableCreditCardSupport: Bool?
	var enableCustomDonations: Bool?
	var enableDoubleDonation: Bool?
	var about: [AboutModel]?
	var taxRate: Double?
	var taxLabel: String?
	var lat: String?
	var lng: String?
	var itemsSort: Int?
	var attire: String?
	var gatewayId: Int?
	var extraGateways: [Int]?
	var requireTicketsToRegister: Bool?
	var requireTicketForOwners: Bool?
	var maxPaddleNumber: Int?
	var hasPuzzle: Bool?
	var applicationFee: Double?
	var amexFee: Double?
	var txnFee: Double?
	var isFundraiser: Bool?
	var isPrivate: Bool?
	var isVirtual: Bool?
	var allowTeamCreation: Bool?
	var goal: Double?
	var showGoals: Bool?
	var eventRevenue: Double?
	var donationLevels: [Double]?
	var enableMinimumDonationAmount: Bool?
	var minimumDonationAmount: Double?
	var donationTax: String?
	var enableOfflineDonations: Bool?
	var offlineDonationsUpdateThermometer: Bool?
	var bigDonationsNotifications: Bool?
	var bigDonationsAmount: Double?
	var defaultPageGoal: Double?
	var enablePromptPurchaseCoverCC: Bool?
	var enablePromptPurchaseCoverCCByDefault: Bool?
	var allowPledgeDonations: Bool?
	var allowRecurringDonations: Bool?
	var enableCustomPaddles: Bool?
	var paddleAutoAssignStartingNumber: Int?
	var streamStatus: String?
	var streamProvider: String?
	var streamDateStart: Int?
	var streamDateCompleted: Int?
	var streamUrl: String?
	var streamSponsorText: String?
	var streamSponsorImage: String?
	var goalAppeal: Double?
	var goalTicket: Double?
	var revenueAppeal: Double?
	var revenueTicket: Double?
	var bidderAddItems: Bool?
	var requireTicketToBid: Bool?
	var isNonAuctionEvent: Bool?
	var promotedDonationBlock: Bool?
	var allowMonthlyDonations: Bool?
	var allowQuarterlyDonations: Bool?
	var allowAnnuallyDonations: Bool?
	var defaultDonationFrequency: Int?
	var minDonationDurationAllowed: Int?
	var maxDonationDurationAllowed: Int?
	var enableChat: Bool?
	var bidder: BidderModel?
	var tickets: [TicketModel]?
	var puzzles: [PuzzleModel]?
	var promotedItem: [PromotedItemModel]?
	var promotedPoll: [PromotedPollModel]?
	var facebookPixel: String?
	var dtdPublicKey: String?
	var organizationEmail: String?
	var onSiteCustomLabel: String?
	var offSiteCustomLabel: String?
	var templateCustomTerms: String?
	var landingPage: [LandingPageModel]?
	var socialImage: String?
	var donationTicketImage: String?
	var enableLandingPage: Bool?
	var isPrivateEvent: Bool?
	var organizationName: String?
	var auctionAddressStreet1: String?
	var auctionAddressStreet2: String?
	var auctionAddressPostalCode: String?
	var auctionAddressCity: String?
	var auctionAddressProvince: String?
	var count: Int?
}

extension AuctionModel: ArrowParsable {
	init() {
		self.id = String()
	}

	enum CodingKeys: String, CodingKey {
		case id, key, imageUrl, auctionGuid, name, status, timeZone, startTime, endTime, hasExtendedBidding,
		     extendedBiddingTimeoutInMinutes, requireCreditCard, spendingThreshold, auctionDescription = "description",
		     auctionMessage, currentPaddleNumber, timerStartTime, timerEndTime, timerRemaining, currencyCode, currencySymbol,
		     totalBidders, totalItems, enableTicketSales, organization, categories, vanityAddress, auctionAddress,
		     enableCreditCardSupport, enableCustomDonations, enableDoubleDonation, about, taxRate, taxLabel, lat, lng,
		     itemsSort, attire, gatewayId, extraGateways, requireTicketsToRegister, requireTicketForOwners, maxPaddleNumber,
		     hasPuzzle, applicationFee, amexFee, txnFee, isFundraiser, isPrivate, isVirtual, allowTeamCreation, goal, showGoals,
		     eventRevenue, donationLevels, enableMinimumDonationAmount, minimumDonationAmount, donationTax, enableOfflineDonations,
		     offlineDonationsUpdateThermometer, bigDonationsNotifications, bigDonationsAmount, defaultPageGoal, enablePromptPurchaseCoverCC,
		     enablePromptPurchaseCoverCCByDefault, allowPledgeDonations, allowRecurringDonations, enableCustomPaddles, paddleAutoAssignStartingNumber,
		     streamStatus, streamProvider, streamDateStart, streamDateCompleted, streamUrl, streamSponsorText, streamSponsorImage,
		     goalAppeal, goalTicket, revenueAppeal, revenueTicket, bidderAddItems, requireTicketToBid, isNonAuctionEvent, promotedDonationBlock,
		     allowMonthlyDonations, allowQuarterlyDonations, allowAnnuallyDonations, defaultDonationFrequency, minDonationDurationAllowed,
		     maxDonationDurationAllowed, enableChat, bidder, tickets, puzzles, promotedItem, promotedPoll, facebookPixel, dtdPublicKey,
		     organizationEmail, onSiteCustomLabel, offSiteCustomLabel, templateCustomTerms, landingPage, socialImage, donationTicketImage,
		     enableLandingPage, isPrivateEvent, organizationName, auctionAddressStreet1, auctionAddressStreet2, auctionAddressPostalCode,
		     auctionAddressCity, auctionAddressProvince, count
	}

	mutating func deserialize(_ json: JSON) {
		id <-- json["auctionGuid"]
		identity <-- json["id"]
		key <-- json["key"]
		imageUrl <-- json["imageUrl"]
		auctionGuid <-- json["auctionGuid"]
		name <-- json["name"]
		status <-- json["status"]
		timeZone <-- json["timeZone"]
		startTime <-- json["startTime"]
		endTime <-- json["endTime"]
		hasExtendedBidding <-- json["hasExtendedBidding"]
		extendedBiddingTimeoutInMinutes <-- json["extendedBiddingTimeoutInMinutes"]
		requireCreditCard <-- json["requireCreditCard"]
		spendingThreshold <-- json["spendingThreshold"]
		auctionDescription <-- json["description"]
		auctionMessage <-- json["auctionMessage"]
		currentPaddleNumber <-- json["currentPaddleNumber"]
		timerStartTime <-- json["timerStartTime"]
		timerEndTime <-- json["timerEndTime"]
		timerRemaining <-- json["timerRemaining"]
		currencyCode <-- json["currencyCode"]
		currencySymbol <-- json["currencySymbol"]
		totalBidders <-- json["totalBidders"]
		totalItems <-- json["totalItems"]
		enableTicketSales <-- json["enableTicketSales"]
		vanityAddress <-- json["vanityAddress"]
		enableCreditCardSupport <-- json["enableCreditCardSupport"]
		enableCustomDonations <-- json["enableCustomDonations"]
		enableDoubleDonation <-- json["enableDoubleDonation"]
		taxRate <-- json["taxRate"]
		taxLabel <-- json["taxLabel"]
		lat <-- json["lat"]
		lng <-- json["lng"]
		itemsSort <-- json["itemsSort"]
		attire <-- json["attire"]
		gatewayId <-- json["gatewayId"]
		extraGateways <-- json["extraGateways"]
		requireTicketsToRegister <-- json["requireTicketsToRegister"]
		requireTicketForOwners <-- json["requireTicketForOwners"]
		maxPaddleNumber <-- json["maxPaddleNumber"]
		hasPuzzle <-- json["hasPuzzle"]
		applicationFee <-- json["applicationFee"]
		amexFee <-- json["amexFee"]
		txnFee <-- json["txnFee"]
		isFundraiser <-- json["isFundraiser"]
		isPrivate <-- json["isPrivate"]
		isVirtual <-- json["isVirtual"]
		allowTeamCreation <-- json["allowTeamCreation"]
		goal <-- json["goal"]
		showGoals <-- json["showGoals"]
		eventRevenue <-- json["eventRevenue"]
		donationLevels <-- json["donationLevels"]
		enableMinimumDonationAmount <-- json["enableMinimumDonationAmount"]
		minimumDonationAmount <-- json["minimumDonationAmount"]
		donationTax <-- json["donationTax"]
		enableOfflineDonations <-- json["enableOfflineDonations"]
		offlineDonationsUpdateThermometer <-- json["offlineDonationsUpdateThermometer"]
		bigDonationsNotifications <-- json["bigDonationsNotifications"]
		bigDonationsAmount <-- json["bigDonationsAmount"]
		defaultPageGoal <-- json["defaultPageGoal"]
		enablePromptPurchaseCoverCC <-- json["enablePromptPurchaseCoverCC"]
		enablePromptPurchaseCoverCCByDefault <-- json["enablePromptPurchaseCoverCCByDefault"]
		allowPledgeDonations <-- json["allowPledgeDonations"]
		allowRecurringDonations <-- json["allowRecurringDonations"]
		enableCustomPaddles <-- json["enableCustomPaddles"]
		paddleAutoAssignStartingNumber <-- json["paddleAutoAssignStartingNumber"]
		streamStatus <-- json["streamStatus"]
		streamProvider <-- json["streamProvider"]
		streamDateStart <-- json["streamDateStart"]
		streamDateCompleted <-- json["streamDateCompleted"]
		streamUrl <-- json["streamUrl"]
		streamSponsorText <-- json["streamSponsorText"]
		streamSponsorImage <-- json["streamSponsorImage"]
		goalAppeal <-- json["goalAppeal"]
		goalTicket <-- json["goalTicket"]
		revenueAppeal <-- json["revenueAppeal"]
		revenueTicket <-- json["revenueTicket"]
		bidderAddItems <-- json["bidderAddItems"]
		requireTicketToBid <-- json["requireTicketToBid"]
		isNonAuctionEvent <-- json["isNonAuctionEvent"]
		promotedDonationBlock <-- json["promotedDonationBlock"]
		allowMonthlyDonations <-- json["allowMonthlyDonations"]
		allowQuarterlyDonations <-- json["allowQuarterlyDonations"]
		allowAnnuallyDonations <-- json["allowAnnuallyDonations"]
		defaultDonationFrequency <-- json["defaultDonationFrequency"]
		minDonationDurationAllowed <-- json["minDonationDurationAllowed"]
		maxDonationDurationAllowed <-- json["maxDonationDurationAllowed"]
		enableChat <-- json["enableChat"]
		facebookPixel <-- json["facebookPixel"]
		dtdPublicKey <-- json["dtdPublicKey"]
		organizationEmail <-- json["organizationEmail"]
		onSiteCustomLabel <-- json["onSiteCustomLabel"]
		offSiteCustomLabel <-- json["offSiteCustomLabel"]
		templateCustomTerms <-- json["templateCustomTerms"]
		socialImage <-- json["socialImage"]
		donationTicketImage <-- json["donationTicketImage"]
		enableLandingPage <-- json["enableLandingPage"]
		isPrivateEvent <-- json["isPrivateEvent"]
		bidder <-- json["bidder"]
		organizationName <-- json["organizationName"]
		auctionAddressStreet1 <-- json["auctionAddressStreet1"]
		auctionAddressStreet2 <-- json["auctionAddressStreet2"]
		auctionAddressPostalCode <-- json["auctionAddressPostalCode"]
		auctionAddressCity <-- json["auctionAddressCity"]
		auctionAddressProvince <-- json["auctionAddressProvince"]
		count <-- json["count"]

		// TeamPermissions <-- json["TeamPermissions"]

		landingPage = (json["landingPage"]?.collection ?? [json["landingPage"]].compactMap { $0 }).map { jsonItem in
			var landingPage = LandingPageModel()
			landingPage.deserialize(jsonItem)
			return landingPage
		}

		auctionAddress = (json["auctionAddress"]?.collection ?? [json["auctionAddress"]].compactMap { $0 }).map { jsonItem in
			var auctionAddress = AddressModel()
			auctionAddress.deserialize(jsonItem)
			return auctionAddress
		}

		about = (json["about"]?.collection ?? [json["about"]].compactMap { $0 }).map { jsonItem in
			var about = AboutModel()
			about.deserialize(jsonItem)
			return about
		}

		tickets = (json["tickets"]?.collection ?? [json["tickets"]].compactMap { $0 }).map { jsonItem in
			var tickets = TicketModel()
			tickets.deserialize(jsonItem)
			return tickets
		}

		puzzles = (json["puzzles"]?.collection ?? [json["puzzles"]].compactMap { $0 }).map { jsonItem in
			var puzzles = PuzzleModel()
			puzzles.deserialize(jsonItem)
			return puzzles
		}

		promotedItem = (json["promotedItem"]?.collection ?? [json["promotedItem"]].compactMap { $0 }).map { jsonItem in
			var promotedItem = PromotedItemModel()
			promotedItem.deserialize(jsonItem)
			return promotedItem
		}

		promotedPoll = (json["promotedPoll"]?.collection ?? [json["promotedPoll"]].compactMap { $0 }).map { jsonItem in
			var promotedPoll = PromotedPollModel()
			promotedPoll.deserialize(jsonItem)
			return promotedPoll
		}

		organization = (json["organization"]?.collection ?? [json["organization"]].compactMap { $0 }).map { jsonItem in
			var organization = OrganizationModel()
			organization.deserialize(jsonItem)
			return organization
		}

		categories = (json["categories"]?.collection ?? [json["categories"]].compactMap { $0 }).map { jsonItem in
			var categories = CategoryModel()
			categories.deserialize(jsonItem)
			return categories
		}
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
	}
}
