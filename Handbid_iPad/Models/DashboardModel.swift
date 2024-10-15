//Copyright (c) 2024 by Handbid. All rights reserved.

import Arrow
import NetworkService

struct DashboardModel: Codable, NetworkingJSONDecodable, AutoEncodable {
    var overallGoal: String?
    var overallRaised: String?
    var overallRatio: Double?
    
    var biddersRegistered: Int?
    var biddersActive: Int?
    var donors: Int?
    var local: Int?
    
    var guestsRegistered: Int?
    var guestsCheckedIn: Int?
    
    var performanceFmv: String?
    var performanceRaised: String?
    var performanceRatio: Double?
    
    var itemsSilent: Int?
    var itemsLive: Int?
    var itemsPurchase: Int?
    var itemsTicket: Int?
    var itemsDonation: Int?
    
    var revenueSilent: String?
    var revenueLive: String?
    var revenuePurchase: String?
    var revenueTicket: String?
    var revenueDonation: String?
    var revenueTotal: String?
    
    var itemsNoBids: Int?
    var bidderNoBids: Int?
    var bidsPerBidders: Double?
}

extension DashboardModel: ArrowParsable {
    mutating func deserialize(_ json: JSON) {
        overallGoal <-- json["overallGoal.goal"]
        overallRaised <-- json["overallGoal.raised"]
        overallRatio <-- json["overallGoal.ratio"]
        
        biddersRegistered <-- json["bidders.registered"]
        biddersActive <-- json["bidders.active"]
        donors <-- json["bidders.uniqueDonors"]
        local <-- json["bidders.local"]
        
        guestsRegistered <-- json["guests.registered"]
        guestsCheckedIn <-- json["guests.checkedIn"]
        
        performanceFmv <-- json["auctionPerformance.fmv"]
        performanceRaised <-- json["auctionPerformance.revenue"]
        performanceRatio <-- json["auctionPerformance.ratio"]
        
        itemsSilent <-- json["items.silent"]
        itemsLive <-- json["items.live"]
        itemsPurchase <-- json["items.purchase"]
        itemsTicket <-- json["items.ticket"]
        itemsDonation <-- json["items.donation"]
        
        revenueSilent <-- json["revenue.silent"]
        revenueLive <-- json["revenue.live"]
        revenuePurchase <-- json["revenue.purchase"]
        revenueTicket <-- json["revenue.ticket"]
        revenueDonation <-- json["revenue.donation"]
        revenueTotal <-- json["revenue.total"]
        
        itemsNoBids <-- json["bidStats.itemsNoBids"]
        bidderNoBids <-- json["bidStats.bidderNoBids"]
        bidsPerBidders <-- json["bidStats.bidsPerBidders"]
    }
    
    
}
