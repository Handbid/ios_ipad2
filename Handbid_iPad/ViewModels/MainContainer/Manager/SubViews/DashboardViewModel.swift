//Copyright (c) 2024 by Handbid. All rights reserved.

class DashboardViewModel: ObservableObject {
    @Published var dashboardModel: DashboardModel? =
    DashboardModel(
        overallGoal: "$1000000000",
        overallRaised: "$500",
        overallRatio: 0.5,
        biddersRegistered: 15,
        biddersActive: 5,
        donors: 2,
        local: 1,
        guestsRegistered: 5,
        guestsCheckedIn: 1,
        performanceFmv: "$300",
        performanceRaised: "$500",
        performanceRatio: 5/3,
        itemsSilent: 15,
        itemsLive: 5,
        itemsPurchase: 12,
        itemsTicket: 10,
        itemsDonation: 7,
        revenueSilent: "$12,000",
        revenueLive: "$5,000",
        revenuePurchase: "$24,500",
        revenueTicket: "$2,500",
        revenueDonation: "$2,300",
        revenueTotal: "$46,300",
        itemsNoBids: 6,
        bidderNoBids: 2,
        bidsPerBidders: 5.67
    )
}
