// Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService
import SwiftData

struct AuctionModel: Identifiable, Codable, NetworkingJSONDecodable, AutoEncodable {
	var id: String
	var identity: Int?
	var key: String?
	var imageUrl: String?
	var auctionGuid: String?
	var name: String?
	var status: AuctionStatus?
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
    
    enum AuctionStatus: String, Codable {
        case open, paused, setup, presale, preview, reconciled, closed
    }
}

extension AuctionModel: ArrowParsable {
	init() {
		self.id = String()
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
		// bidder <-- json["bidder"]
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

extension AuctionModel {
	enum AuctionModelFields: String {
		case id
		case identity
		case key
		case imageUrl
		case auctionGuid
		case name
		case status
		case timeZone
		case startTime
		case endTime
		case hasExtendedBidding
		case extendedBiddingTimeoutInMinutes
		case requireCreditCard
		case spendingThreshold
		case auctionDescription
		case auctionMessage
		case currentPaddleNumber
		case timerStartTime
		case timerEndTime
		case timerRemaining
		case currencyCode
		case currencySymbol
		case totalBidders
		case totalItems
		case enableTicketSales
		case organization
		case categories
		case vanityAddress
		case auctionAddress
		case enableCreditCardSupport
		case enableCustomDonations
		case enableDoubleDonation
		case about
		case taxRate
		case taxLabel
		case lat
		case lng
		case itemsSort
		case attire
		case gatewayId
		case extraGateways
		case requireTicketsToRegister
		case requireTicketForOwners
		case maxPaddleNumber
		case hasPuzzle
		case applicationFee
		case amexFee
		case txnFee
		case isFundraiser
		case isPrivate
		case isVirtual
		case allowTeamCreation
		case goal
		case showGoals
		case eventRevenue
		case donationLevels
		case enableMinimumDonationAmount
		case minimumDonationAmount
		case donationTax
		case enableOfflineDonations
		case offlineDonationsUpdateThermometer
		case bigDonationsNotifications
		case bigDonationsAmount
		case defaultPageGoal
		case enablePromptPurchaseCoverCC
		case enablePromptPurchaseCoverCCByDefault
		case allowPledgeDonations
		case allowRecurringDonations
		case enableCustomPaddles
		case paddleAutoAssignStartingNumber
		case streamStatus
		case streamProvider
		case streamDateStart
		case streamDateCompleted
		case streamUrl
		case streamSponsorText
		case streamSponsorImage
		case goalAppeal
		case goalTicket
		case revenueAppeal
		case revenueTicket
		case bidderAddItems
		case requireTicketToBid
		case isNonAuctionEvent
		case promotedDonationBlock
		case allowMonthlyDonations
		case allowQuarterlyDonations
		case allowAnnuallyDonations
		case defaultDonationFrequency
		case minDonationDurationAllowed
		case maxDonationDurationAllowed
		case enableChat
		case bidder
		case tickets
		case puzzles
		case promotedItem
		case promotedPoll
		case facebookPixel
		case dtdPublicKey
		case organizationEmail
		case onSiteCustomLabel
		case offSiteCustomLabel
		case templateCustomTerms
		case landingPage
		case socialImage
		case donationTicketImage
		case enableLandingPage
		case isPrivateEvent
		case organizationName
		case auctionAddressStreet1
		case auctionAddressStreet2
		case auctionAddressPostalCode
		case auctionAddressCity
		case auctionAddressProvince
		case count
	}

	mutating func merge(with model: AuctionModel, fields: [AuctionModelFields]) {
		for field in fields {
			switch field {
			case .id:
				id = model.id
			case .identity:
				identity = model.identity
			case .key:
				key = model.key
			case .imageUrl:
				imageUrl = model.imageUrl
			case .auctionGuid:
				auctionGuid = model.auctionGuid
			case .name:
				name = model.name
			case .status:
				status = model.status
			case .timeZone:
				timeZone = model.timeZone
			case .startTime:
				startTime = model.startTime
			case .endTime:
				endTime = model.endTime
			case .hasExtendedBidding:
				hasExtendedBidding = model.hasExtendedBidding
			case .extendedBiddingTimeoutInMinutes:
				extendedBiddingTimeoutInMinutes = model.extendedBiddingTimeoutInMinutes
			case .requireCreditCard:
				requireCreditCard = model.requireCreditCard
			case .spendingThreshold:
				spendingThreshold = model.spendingThreshold
			case .auctionDescription:
				auctionDescription = model.auctionDescription
			case .auctionMessage:
				auctionMessage = model.auctionMessage
			case .currentPaddleNumber:
				currentPaddleNumber = model.currentPaddleNumber
			case .timerStartTime:
				timerStartTime = model.timerStartTime
			case .timerEndTime:
				timerEndTime = model.timerEndTime
			case .timerRemaining:
				timerRemaining = model.timerRemaining
			case .currencyCode:
				currencyCode = model.currencyCode
			case .currencySymbol:
				currencySymbol = model.currencySymbol
			case .totalBidders:
				totalBidders = model.totalBidders
			case .totalItems:
				totalItems = model.totalItems
			case .enableTicketSales:
				enableTicketSales = model.enableTicketSales
			case .organization:
				organization = model.organization
			case .categories:
				categories = model.categories
			case .vanityAddress:
				vanityAddress = model.vanityAddress
			case .auctionAddress:
				auctionAddress = model.auctionAddress
			case .enableCreditCardSupport:
				enableCreditCardSupport = model.enableCreditCardSupport
			case .enableCustomDonations:
				enableCustomDonations = model.enableCustomDonations
			case .enableDoubleDonation:
				enableDoubleDonation = model.enableDoubleDonation
			case .about:
				about = model.about
			case .taxRate:
				taxRate = model.taxRate
			case .taxLabel:
				taxLabel = model.taxLabel
			case .lat:
				lat = model.lat
			case .lng:
				lng = model.lng
			case .itemsSort:
				itemsSort = model.itemsSort
			case .attire:
				attire = model.attire
			case .gatewayId:
				gatewayId = model.gatewayId
			case .extraGateways:
				extraGateways = model.extraGateways
			case .requireTicketsToRegister:
				requireTicketsToRegister = model.requireTicketsToRegister
			case .requireTicketForOwners:
				requireTicketForOwners = model.requireTicketForOwners
			case .maxPaddleNumber:
				maxPaddleNumber = model.maxPaddleNumber
			case .hasPuzzle:
				hasPuzzle = model.hasPuzzle
			case .applicationFee:
				applicationFee = model.applicationFee
			case .amexFee:
				amexFee = model.amexFee
			case .txnFee:
				txnFee = model.txnFee
			case .isFundraiser:
				isFundraiser = model.isFundraiser
			case .isPrivate:
				isPrivate = model.isPrivate
			case .isVirtual:
				isVirtual = model.isVirtual
			case .allowTeamCreation:
				allowTeamCreation = model.allowTeamCreation
			case .goal:
				goal = model.goal
			case .showGoals:
				showGoals = model.showGoals
			case .eventRevenue:
				eventRevenue = model.eventRevenue
			case .donationLevels:
				donationLevels = model.donationLevels
			case .enableMinimumDonationAmount:
				enableMinimumDonationAmount = model.enableMinimumDonationAmount
			case .minimumDonationAmount:
				minimumDonationAmount = model.minimumDonationAmount
			case .donationTax:
				donationTax = model.donationTax
			case .enableOfflineDonations:
				enableOfflineDonations = model.enableOfflineDonations
			case .offlineDonationsUpdateThermometer:
				offlineDonationsUpdateThermometer = model.offlineDonationsUpdateThermometer
			case .bigDonationsNotifications:
				bigDonationsNotifications = model.bigDonationsNotifications
			case .bigDonationsAmount:
				bigDonationsAmount = model.bigDonationsAmount
			case .defaultPageGoal:
				defaultPageGoal = model.defaultPageGoal
			case .enablePromptPurchaseCoverCC:
				enablePromptPurchaseCoverCC = model.enablePromptPurchaseCoverCC
			case .enablePromptPurchaseCoverCCByDefault:
				enablePromptPurchaseCoverCCByDefault = model.enablePromptPurchaseCoverCCByDefault
			case .allowPledgeDonations:
				allowPledgeDonations = model.allowPledgeDonations
			case .allowRecurringDonations:
				allowRecurringDonations = model.allowRecurringDonations
			case .enableCustomPaddles:
				enableCustomPaddles = model.enableCustomPaddles
			case .paddleAutoAssignStartingNumber:
				paddleAutoAssignStartingNumber = model.paddleAutoAssignStartingNumber
			case .streamStatus:
				streamStatus = model.streamStatus
			case .streamProvider:
				streamProvider = model.streamProvider
			case .streamDateStart:
				streamDateStart = model.streamDateStart
			case .streamDateCompleted:
				streamDateCompleted = model.streamDateCompleted
			case .streamUrl:
				streamUrl = model.streamUrl
			case .streamSponsorText:
				streamSponsorText = model.streamSponsorText
			case .streamSponsorImage:
				streamSponsorImage = model.streamSponsorImage
			case .goalAppeal:
				goalAppeal = model.goalAppeal
			case .goalTicket:
				goalTicket = model.goalTicket
			case .revenueAppeal:
				revenueAppeal = model.revenueAppeal
			case .revenueTicket:
				revenueTicket = model.revenueTicket
			case .bidderAddItems:
				bidderAddItems = model.bidderAddItems
			case .requireTicketToBid:
				requireTicketToBid = model.requireTicketToBid
			case .isNonAuctionEvent:
				isNonAuctionEvent = model.isNonAuctionEvent
			case .promotedDonationBlock:
				promotedDonationBlock = model.promotedDonationBlock
			case .allowMonthlyDonations:
				allowMonthlyDonations = model.allowMonthlyDonations
			case .allowQuarterlyDonations:
				allowQuarterlyDonations = model.allowQuarterlyDonations
			case .allowAnnuallyDonations:
				allowAnnuallyDonations = model.allowAnnuallyDonations
			case .defaultDonationFrequency:
				defaultDonationFrequency = model.defaultDonationFrequency
			case .minDonationDurationAllowed:
				minDonationDurationAllowed = model.minDonationDurationAllowed
			case .maxDonationDurationAllowed:
				maxDonationDurationAllowed = model.maxDonationDurationAllowed
			case .enableChat:
				enableChat = model.enableChat
			case .bidder:
				bidder = model.bidder
			case .tickets:
				tickets = model.tickets
			case .puzzles:
				puzzles = model.puzzles
			case .promotedItem:
				promotedItem = model.promotedItem
			case .promotedPoll:
				promotedPoll = model.promotedPoll
			case .facebookPixel:
				facebookPixel = model.facebookPixel
			case .dtdPublicKey:
				dtdPublicKey = model.dtdPublicKey
			case .organizationEmail:
				organizationEmail = model.organizationEmail
			case .onSiteCustomLabel:
				onSiteCustomLabel = model.onSiteCustomLabel
			case .offSiteCustomLabel:
				offSiteCustomLabel = model.offSiteCustomLabel
			case .templateCustomTerms:
				templateCustomTerms = model.templateCustomTerms
			case .landingPage:
				landingPage = model.landingPage
			case .socialImage:
				socialImage = model.socialImage
			case .donationTicketImage:
				donationTicketImage = model.donationTicketImage
			case .enableLandingPage:
				enableLandingPage = model.enableLandingPage
			case .isPrivateEvent:
				isPrivateEvent = model.isPrivateEvent
			case .organizationName:
				organizationName = model.organizationName
			case .auctionAddressStreet1:
				auctionAddressStreet1 = model.auctionAddressStreet1
			case .auctionAddressStreet2:
				auctionAddressStreet2 = model.auctionAddressStreet2
			case .auctionAddressPostalCode:
				auctionAddressPostalCode = model.auctionAddressPostalCode
			case .auctionAddressCity:
				auctionAddressCity = model.auctionAddressCity
			case .auctionAddressProvince:
				auctionAddressProvince = model.auctionAddressProvince
			case .count:
				count = model.count
			}
		}
	}
}
