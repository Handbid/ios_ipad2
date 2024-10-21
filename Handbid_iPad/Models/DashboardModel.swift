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
        overallGoal <-- json["data.overallGoal.goal"]
        overallRaised <-- json["data.overallGoal.raised"]
        overallRatio <-- json["data.overallGoal.ratio"]
        
        biddersRegistered <-- json["data.bidders.registered"]
        biddersActive <-- json["data.bidders.active"]
        donors <-- json["data.bidders.uniqueDonors"]
        local <-- json["data.bidders.local"]
        
        guestsRegistered <-- json["data.guests.registered"]
        guestsCheckedIn <-- json["data.guests.checkedIn"]
        
        performanceFmv <-- json["data.auctionPerformance.fmv"]
        performanceRaised <-- json["data.auctionPerformance.revenue"]
        performanceRatio <-- json["data.auctionPerformance.ratio"]
        
        itemsSilent <-- json["data.items.silent"]
        itemsLive <-- json["data.items.live"]
        itemsPurchase <-- json["data.items.purchase"]
        itemsTicket <-- json["data.items.ticket"]
        itemsDonation <-- json["data.items.donation"]
        
        revenueSilent <-- json["data.revenue.silent"]
        revenueLive <-- json["data.revenue.live"]
        revenuePurchase <-- json["data.revenue.purchase"]
        revenueTicket <-- json["data.revenue.ticket"]
        revenueDonation <-- json["data.revenue.donation"]
        revenueTotal <-- json["data.revenue.total"]
        
        itemsNoBids <-- json["data.bidStats.itemsNoBids"]
        bidderNoBids <-- json["data.bidStats.bidderNoBids"]
        bidsPerBidders <-- json["data.bidStats.bidsPerBidders"]
    }
    
    
}
