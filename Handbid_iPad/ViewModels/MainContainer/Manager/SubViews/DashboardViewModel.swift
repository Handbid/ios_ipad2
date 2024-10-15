//Copyright (c) 2024 by Handbid. All rights reserved.

class DashboardViewModel: ObservableObject {
    @Published var dashboardModel: DashboardModel? =
    DashboardModel(
        overallGoal: "$1000",
        overallRaised: "$500",
        overallRatio: 0.5,
        biddersRegistered: 15,
        biddersActive: 5,
        guestsRegistered: 5,
        guestsCheckedIn: 1,
        performanceFmv: "$300",
        performanceRaised: "$500",
        performanceRatio: 5/3
    )
}
