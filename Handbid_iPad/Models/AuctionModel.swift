// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService
import SwiftData

struct AuctionModel: Decodable, NetworkingJSONDecodable {
	@Attribute(.unique) var id: Int?
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

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decodeIfPresent(Int.self, forKey: .id)
		self.key = try container.decodeIfPresent(String.self, forKey: .key)
		self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
		self.auctionGuid = try container.decodeIfPresent(String.self, forKey: .auctionGuid)
		self.name = try container.decodeIfPresent(String.self, forKey: .name)
		self.status = try container.decodeIfPresent(String.self, forKey: .status)
		self.timeZone = try container.decodeIfPresent(String.self, forKey: .timeZone)
		self.startTime = try container.decodeIfPresent(Int.self, forKey: .startTime)
		self.endTime = try container.decodeIfPresent(Int.self, forKey: .endTime)
		self.hasExtendedBidding = try container.decodeIfPresent(Bool.self, forKey: .hasExtendedBidding)
		self.extendedBiddingTimeoutInMinutes = try container.decodeIfPresent(Int.self, forKey: .extendedBiddingTimeoutInMinutes)
		self.requireCreditCard = try container.decodeIfPresent(Bool.self, forKey: .requireCreditCard)
		self.spendingThreshold = try container.decodeIfPresent(Double.self, forKey: .spendingThreshold)
		self.auctionDescription = try container.decodeIfPresent(String.self, forKey: .auctionDescription)
		self.auctionMessage = try container.decodeIfPresent(String.self, forKey: .auctionMessage)
		self.currentPaddleNumber = try container.decodeIfPresent(String.self, forKey: .currentPaddleNumber)
		self.timerStartTime = try container.decodeIfPresent(Int.self, forKey: .timerStartTime)
		self.timerEndTime = try container.decodeIfPresent(Int.self, forKey: .timerEndTime)
		self.timerRemaining = try container.decodeIfPresent(Int.self, forKey: .timerRemaining)
		self.currencyCode = try container.decodeIfPresent(String.self, forKey: .currencyCode)
		self.currencySymbol = try container.decodeIfPresent(String.self, forKey: .currencySymbol)
		self.totalBidders = try container.decodeIfPresent(Int.self, forKey: .totalBidders)
		self.totalItems = try container.decodeIfPresent(Int.self, forKey: .totalItems)
		self.enableTicketSales = try container.decodeIfPresent(Bool.self, forKey: .enableTicketSales)
		self.organization = try container.decodeIfPresent([OrganizationModel].self, forKey: .organization)
		self.categories = try container.decodeIfPresent([CategoryModel].self, forKey: .categories)
		self.vanityAddress = try container.decodeIfPresent(String.self, forKey: .vanityAddress)
		self.auctionAddress = try container.decodeIfPresent([AddressModel].self, forKey: .auctionAddress)
		self.enableCreditCardSupport = try container.decodeIfPresent(Bool.self, forKey: .enableCreditCardSupport)
		self.enableCustomDonations = try container.decodeIfPresent(Bool.self, forKey: .enableCustomDonations)
		self.enableDoubleDonation = try container.decodeIfPresent(Bool.self, forKey: .enableDoubleDonation)
		self.about = try container.decodeIfPresent([AboutModel].self, forKey: .about)
		self.taxRate = try container.decodeIfPresent(Double.self, forKey: .taxRate)
		self.taxLabel = try container.decodeIfPresent(String.self, forKey: .taxLabel)
		self.lat = try container.decodeIfPresent(String.self, forKey: .lat)
		self.lng = try container.decodeIfPresent(String.self, forKey: .lng)
		self.itemsSort = try container.decodeIfPresent(Int.self, forKey: .itemsSort)
		self.attire = try container.decodeIfPresent(String.self, forKey: .attire)
		self.gatewayId = try container.decodeIfPresent(Int.self, forKey: .gatewayId)
		self.extraGateways = try container.decodeIfPresent([Int].self, forKey: .extraGateways)
		self.requireTicketsToRegister = try container.decodeIfPresent(Bool.self, forKey: .requireTicketsToRegister)
		self.requireTicketForOwners = try container.decodeIfPresent(Bool.self, forKey: .requireTicketForOwners)
		self.maxPaddleNumber = try container.decodeIfPresent(Int.self, forKey: .maxPaddleNumber)
		self.hasPuzzle = try container.decodeIfPresent(Bool.self, forKey: .hasPuzzle)
		self.applicationFee = try container.decodeIfPresent(Double.self, forKey: .applicationFee)
		self.amexFee = try container.decodeIfPresent(Double.self, forKey: .amexFee)
		self.txnFee = try container.decodeIfPresent(Double.self, forKey: .txnFee)
		self.isFundraiser = try container.decodeIfPresent(Bool.self, forKey: .isFundraiser)
		self.isPrivate = try container.decodeIfPresent(Bool.self, forKey: .isPrivate)
		self.isVirtual = try container.decodeIfPresent(Bool.self, forKey: .isVirtual)
		self.allowTeamCreation = try container.decodeIfPresent(Bool.self, forKey: .allowTeamCreation)
		self.goal = try container.decodeIfPresent(Double.self, forKey: .goal)
		self.showGoals = try container.decodeIfPresent(Bool.self, forKey: .showGoals)
		self.eventRevenue = try container.decodeIfPresent(Double.self, forKey: .eventRevenue)
		self.donationLevels = try container.decodeIfPresent([Double].self, forKey: .donationLevels)
		self.enableMinimumDonationAmount = try container.decodeIfPresent(Bool.self, forKey: .enableMinimumDonationAmount)
		self.minimumDonationAmount = try container.decodeIfPresent(Double.self, forKey: .minimumDonationAmount)
		self.donationTax = try container.decodeIfPresent(String.self, forKey: .donationTax)
		self.enableOfflineDonations = try container.decodeIfPresent(Bool.self, forKey: .enableOfflineDonations)
		self.offlineDonationsUpdateThermometer = try container.decodeIfPresent(Bool.self, forKey: .offlineDonationsUpdateThermometer)
		self.bigDonationsNotifications = try container.decodeIfPresent(Bool.self, forKey: .bigDonationsNotifications)
		self.bigDonationsAmount = try container.decodeIfPresent(Double.self, forKey: .bigDonationsAmount)
		self.defaultPageGoal = try container.decodeIfPresent(Double.self, forKey: .defaultPageGoal)
		self.enablePromptPurchaseCoverCC = try container.decodeIfPresent(Bool.self, forKey: .enablePromptPurchaseCoverCC)
		self.enablePromptPurchaseCoverCCByDefault = try container.decodeIfPresent(Bool.self, forKey: .enablePromptPurchaseCoverCCByDefault)
		self.allowPledgeDonations = try container.decodeIfPresent(Bool.self, forKey: .allowPledgeDonations)
		self.allowRecurringDonations = try container.decodeIfPresent(Bool.self, forKey: .allowRecurringDonations)
		self.enableCustomPaddles = try container.decodeIfPresent(Bool.self, forKey: .enableCustomPaddles)
		self.paddleAutoAssignStartingNumber = try container.decodeIfPresent(Int.self, forKey: .paddleAutoAssignStartingNumber)
		self.streamStatus = try container.decodeIfPresent(String.self, forKey: .streamStatus)
		self.streamProvider = try container.decodeIfPresent(String.self, forKey: .streamProvider)
		self.streamDateStart = try container.decodeIfPresent(Int.self, forKey: .streamDateStart)
		self.streamDateCompleted = try container.decodeIfPresent(Int.self, forKey: .streamDateCompleted)
		self.streamUrl = try container.decodeIfPresent(String.self, forKey: .streamUrl)
		self.streamSponsorText = try container.decodeIfPresent(String.self, forKey: .streamSponsorText)
		self.streamSponsorImage = try container.decodeIfPresent(String.self, forKey: .streamSponsorImage)
		self.goalAppeal = try container.decodeIfPresent(Double.self, forKey: .goalAppeal)
		self.goalTicket = try container.decodeIfPresent(Double.self, forKey: .goalTicket)
		self.revenueAppeal = try container.decodeIfPresent(Double.self, forKey: .revenueAppeal)
		self.revenueTicket = try container.decodeIfPresent(Double.self, forKey: .revenueTicket)
		self.bidderAddItems = try container.decodeIfPresent(Bool.self, forKey: .bidderAddItems)
		self.requireTicketToBid = try container.decodeIfPresent(Bool.self, forKey: .requireTicketToBid)
		self.isNonAuctionEvent = try container.decodeIfPresent(Bool.self, forKey: .isNonAuctionEvent)
		self.promotedDonationBlock = try container.decodeIfPresent(Bool.self, forKey: .promotedDonationBlock)
		self.allowMonthlyDonations = try container.decodeIfPresent(Bool.self, forKey: .allowMonthlyDonations)
		self.allowQuarterlyDonations = try container.decodeIfPresent(Bool.self, forKey: .allowQuarterlyDonations)
		self.allowAnnuallyDonations = try container.decodeIfPresent(Bool.self, forKey: .allowAnnuallyDonations)
		self.defaultDonationFrequency = try container.decodeIfPresent(Int.self, forKey: .defaultDonationFrequency)
		self.minDonationDurationAllowed = try container.decodeIfPresent(Int.self, forKey: .minDonationDurationAllowed)
		self.maxDonationDurationAllowed = try container.decodeIfPresent(Int.self, forKey: .maxDonationDurationAllowed)
		self.enableChat = try container.decodeIfPresent(Bool.self, forKey: .enableChat)
		self.bidder = try container.decodeIfPresent(BidderModel.self, forKey: .bidder)
		self.tickets = try container.decodeIfPresent([TicketModel].self, forKey: .tickets)
		self.puzzles = try container.decodeIfPresent([PuzzleModel].self, forKey: .puzzles)
		self.promotedItem = try container.decodeIfPresent([PromotedItemModel].self, forKey: .promotedItem)
		self.promotedPoll = try container.decodeIfPresent([PromotedPollModel].self, forKey: .promotedPoll)
		self.facebookPixel = try container.decodeIfPresent(String.self, forKey: .facebookPixel)
		self.dtdPublicKey = try container.decodeIfPresent(String.self, forKey: .dtdPublicKey)
		self.organizationEmail = try container.decodeIfPresent(String.self, forKey: .organizationEmail)
		self.onSiteCustomLabel = try container.decodeIfPresent(String.self, forKey: .onSiteCustomLabel)
		self.offSiteCustomLabel = try container.decodeIfPresent(String.self, forKey: .offSiteCustomLabel)
		self.templateCustomTerms = try container.decodeIfPresent(String.self, forKey: .templateCustomTerms)
		self.socialImage = try container.decodeIfPresent(String.self, forKey: .socialImage)
		self.donationTicketImage = try container.decodeIfPresent(String.self, forKey: .donationTicketImage)
		self.enableLandingPage = try container.decodeIfPresent(Bool.self, forKey: .enableLandingPage)
		self.isPrivateEvent = try container.decodeIfPresent(Bool.self, forKey: .isPrivateEvent)
		self.bidder = try container.decodeIfPresent(BidderModel.self, forKey: .bidder)
		self.organizationName = try container.decodeIfPresent(String.self, forKey: .organizationName)
		self.auctionAddressStreet1 = try container.decodeIfPresent(String.self, forKey: .auctionAddressStreet1)
		self.auctionAddressStreet2 = try container.decodeIfPresent(String.self, forKey: .auctionAddressStreet2)
		self.auctionAddressPostalCode = try container.decodeIfPresent(String.self, forKey: .auctionAddressPostalCode)
		self.auctionAddressCity = try container.decodeIfPresent(String.self, forKey: .auctionAddressCity)
		self.auctionAddressProvince = try container.decodeIfPresent(String.self, forKey: .auctionAddressProvince)
		self.count = try container.decodeIfPresent(Int.self, forKey: .count)
		self.landingPage = try container.decodeIfPresent([LandingPageModel].self, forKey: .landingPage)
		self.auctionAddress = try container.decodeIfPresent([AddressModel].self, forKey: .auctionAddress)
		self.about = try container.decodeIfPresent([AboutModel].self, forKey: .about)
		self.tickets = try container.decodeIfPresent([TicketModel].self, forKey: .tickets)
		self.puzzles = try container.decodeIfPresent([PuzzleModel].self, forKey: .puzzles)
		self.promotedItem = try container.decodeIfPresent([PromotedItemModel].self, forKey: .promotedItem)
		self.promotedPoll = try container.decodeIfPresent([PromotedPollModel].self, forKey: .promotedPoll)
		self.organization = try container.decodeIfPresent([OrganizationModel].self, forKey: .organization)
		self.categories = try container.decodeIfPresent([CategoryModel].self, forKey: .categories)
	}

	mutating func deserialize(_ json: JSON) {
		id <-- json["id"]
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
}
